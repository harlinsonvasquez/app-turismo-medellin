package com.turismo.module.itinerary.service.impl;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.turismo.exception.BadRequestException;
import com.turismo.exception.ResourceNotFoundException;
import com.turismo.module.event.entity.Event;
import com.turismo.module.event.repository.EventRepository;
import com.turismo.module.itinerary.dto.ItineraryGenerateRequest;
import com.turismo.module.itinerary.dto.ItineraryItemRequest;
import com.turismo.module.itinerary.dto.ItineraryItemResponse;
import com.turismo.module.itinerary.dto.ItineraryResponse;
import com.turismo.module.itinerary.dto.ItinerarySaveRequest;
import com.turismo.module.itinerary.entity.Itinerary;
import com.turismo.module.itinerary.entity.ItineraryItem;
import com.turismo.module.itinerary.entity.ItineraryItemType;
import com.turismo.module.itinerary.entity.ItineraryPeriod;
import com.turismo.module.itinerary.entity.TravelStyle;
import com.turismo.module.itinerary.repository.ItineraryRepository;
import com.turismo.module.itinerary.service.ItineraryService;
import com.turismo.module.place.entity.Place;
import com.turismo.module.place.entity.PlaceCategory;
import com.turismo.module.place.entity.PriceLevel;
import com.turismo.module.place.repository.PlaceRepository;
import com.turismo.module.safety.entity.SafetyTip;
import com.turismo.module.safety.repository.SafetyTipRepository;
import com.turismo.module.user.entity.User;
import com.turismo.module.user.repository.UserRepository;
import com.turismo.security.SecurityUtils;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ItineraryServiceImpl implements ItineraryService {

    private final ItineraryRepository itineraryRepository;
    private final UserRepository userRepository;
    private final PlaceRepository placeRepository;
    private final EventRepository eventRepository;
    private final SafetyTipRepository safetyTipRepository;
    private final ObjectMapper objectMapper;

    @Override
    @Transactional(readOnly = true)
    public ItineraryResponse generate(ItineraryGenerateRequest request) {
        List<Place> cityPlaces = placeRepository.findAll().stream()
                .filter(Place::isActive)
                .filter(place -> place.getCity().equalsIgnoreCase(request.city()))
                .filter(place -> request.safeZoneOnly() == null || !request.safeZoneOnly() || place.isSafeZone())
                .sorted(Comparator.comparing(Place::isFeatured).reversed().thenComparing(Place::getRating).reversed())
                .toList();

        List<Event> cityEvents = eventRepository.findAll().stream()
                .filter(Event::isActive)
                .filter(event -> event.getCity().equalsIgnoreCase(request.city()))
                .sorted(Comparator.comparing(Event::isFeatured).reversed().thenComparing(Event::getStartDate))
                .toList();

        if (cityPlaces.isEmpty() && cityEvents.isEmpty()) {
            throw new BadRequestException("There is not enough catalog data to generate an itinerary for the requested city");
        }

        BigDecimal dailyBudget = request.totalBudget().divide(BigDecimal.valueOf(request.totalDays()), 2, RoundingMode.HALF_UP);
        List<ItineraryItemResponse> items = new ArrayList<>();
        Set<UUID> usedReferences = new HashSet<>();
        int sortSeed = 0;

        for (int day = 1; day <= request.totalDays(); day++) {
            Place morningPlace = choosePlace(cityPlaces, usedReferences, dailyBudget, request.interests(), List.of(PlaceCategory.TOURIST_PLACE, PlaceCategory.EXPERIENCE, PlaceCategory.TOWN));
            if (morningPlace != null) {
                items.add(toGeneratedItem(day, ItineraryPeriod.MORNING, inferItemType(morningPlace), morningPlace.getId(), morningPlace.getName(), defaultCost(morningPlace), sortSeed++));
                usedReferences.add(morningPlace.getId());
            }

            Event afternoonEvent = chooseEvent(cityEvents, usedReferences, dailyBudget);
            if (afternoonEvent != null && day % 2 == 0) {
                items.add(toGeneratedItem(day, ItineraryPeriod.AFTERNOON, ItineraryItemType.EVENT, afternoonEvent.getId(), afternoonEvent.getTitle(), afternoonEvent.getAveragePrice(), sortSeed++));
                usedReferences.add(afternoonEvent.getId());
            } else {
                Place afternoonPlace = choosePlace(cityPlaces, usedReferences, dailyBudget, request.interests(), List.of(PlaceCategory.TOURIST_PLACE, PlaceCategory.EXPERIENCE, PlaceCategory.TOWN, PlaceCategory.TRANSPORT));
                if (afternoonPlace != null) {
                    items.add(toGeneratedItem(day, ItineraryPeriod.AFTERNOON, inferItemType(afternoonPlace), afternoonPlace.getId(), afternoonPlace.getName(), defaultCost(afternoonPlace), sortSeed++));
                    usedReferences.add(afternoonPlace.getId());
                }
            }

            Place nightPlace = chooseNightPlace(cityPlaces, usedReferences, dailyBudget, request.travelStyle());
            if (nightPlace != null) {
                items.add(toGeneratedItem(day, ItineraryPeriod.NIGHT, inferItemType(nightPlace), nightPlace.getId(), nightPlace.getName(), defaultCost(nightPlace), sortSeed++));
                usedReferences.add(nightPlace.getId());
            }
        }

        List<SafetyTip> tips = safetyTipRepository.findByCityIgnoreCaseAndActiveTrue(request.city());
        if (!tips.isEmpty()) {
            SafetyTip tip = tips.stream().min(Comparator.comparing(SafetyTip::getCreatedAt)).orElse(tips.get(0));
            items.add(new ItineraryItemResponse(null, 1, ItineraryPeriod.NIGHT, ItineraryItemType.SAFETY_NOTE, tip.getId(), tip.getTitle(), BigDecimal.ZERO, sortSeed));
        }

        return new ItineraryResponse(
                null,
                request.city() + " personalized itinerary",
                request.city(),
                request.totalDays(),
                request.totalBudget(),
                request.travelStyle(),
                request.companionType(),
                request.interests(),
                request.notes(),
                items,
                null,
                null,
                true
        );
    }

    @Override
    @Transactional
    public ItineraryResponse save(ItinerarySaveRequest request) {
        User user = userRepository.findById(SecurityUtils.currentUserId())
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        Itinerary itinerary = new Itinerary();
        itinerary.setUser(user);
        itinerary.setTitle(request.title().trim());
        itinerary.setCityBase(request.cityBase().trim());
        itinerary.setTotalDays(request.totalDays());
        itinerary.setTotalBudget(request.totalBudget());
        itinerary.setTravelStyle(request.travelStyle());
        itinerary.setCompanionType(request.companionType());
        itinerary.setInterestsJson(writeJson(request.interests()));
        itinerary.setNotes(request.notes());

        itinerary.getItems().clear();
        for (ItineraryItemRequest itemRequest : request.items()) {
            ItineraryItem item = new ItineraryItem();
            item.setItinerary(itinerary);
            item.setDayNumber(itemRequest.dayNumber());
            item.setPeriod(itemRequest.period());
            item.setItemType(itemRequest.itemType());
            item.setReferenceId(itemRequest.referenceId());
            item.setTitle(itemRequest.title());
            item.setEstimatedCost(itemRequest.estimatedCost());
            item.setSortOrder(itemRequest.sortOrder());
            itinerary.getItems().add(item);
        }

        return toResponse(itineraryRepository.save(itinerary), false);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ItineraryResponse> findMine() {
        return itineraryRepository.findByUserIdOrderByCreatedAtDesc(SecurityUtils.currentUserId())
                .stream()
                .map(itinerary -> toResponse(itinerary, false))
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public ItineraryResponse findById(UUID id) {
        Itinerary itinerary = itineraryRepository.findByIdAndUserId(id, SecurityUtils.currentUserId())
                .orElseThrow(() -> new ResourceNotFoundException("Itinerary not found"));
        return toResponse(itinerary, false);
    }

    private Place choosePlace(List<Place> places, Set<UUID> usedReferences, BigDecimal dailyBudget, List<String> interests, List<PlaceCategory> allowedCategories) {
        return places.stream()
                .filter(place -> !usedReferences.contains(place.getId()))
                .filter(place -> allowedCategories.contains(place.getCategory()))
                .filter(place -> withinBudget(place.getAveragePrice(), dailyBudget))
                .filter(place -> matchesInterest(place, interests))
                .findFirst()
                .orElseGet(() -> places.stream()
                        .filter(place -> !usedReferences.contains(place.getId()))
                        .filter(place -> allowedCategories.contains(place.getCategory()))
                        .filter(place -> withinBudget(place.getAveragePrice(), dailyBudget))
                        .findFirst()
                        .orElse(null));
    }

    private Event chooseEvent(List<Event> events, Set<UUID> usedReferences, BigDecimal dailyBudget) {
        return events.stream()
                .filter(event -> !usedReferences.contains(event.getId()))
                .filter(event -> withinBudget(event.getAveragePrice(), dailyBudget))
                .findFirst()
                .orElse(null);
    }

    private Place chooseNightPlace(List<Place> places, Set<UUID> usedReferences, BigDecimal dailyBudget, TravelStyle style) {
        List<PlaceCategory> categories = style == TravelStyle.NIGHTLIFE
                ? List.of(PlaceCategory.NIGHTLIFE, PlaceCategory.RESTAURANT)
                : List.of(PlaceCategory.RESTAURANT, PlaceCategory.NIGHTLIFE, PlaceCategory.HOTEL);
        return places.stream()
                .filter(place -> !usedReferences.contains(place.getId()))
                .filter(place -> categories.contains(place.getCategory()))
                .filter(place -> withinBudget(place.getAveragePrice(), dailyBudget))
                .findFirst()
                .orElse(null);
    }

    private ItineraryItemType inferItemType(Place place) {
        return switch (place.getCategory()) {
            case HOTEL -> ItineraryItemType.HOTEL;
            case RESTAURANT -> ItineraryItemType.RESTAURANT;
            default -> ItineraryItemType.PLACE;
        };
    }

    private BigDecimal defaultCost(Place place) {
        if (place.getAveragePrice() != null) {
            return place.getAveragePrice();
        }
        return switch (place.getEstimatedPriceLevel()) {
            case LOW -> BigDecimal.valueOf(30000);
            case MEDIUM -> BigDecimal.valueOf(80000);
            case HIGH -> BigDecimal.valueOf(180000);
        };
    }

    private boolean withinBudget(BigDecimal amount, BigDecimal dailyBudget) {
        if (amount == null) {
            return true;
        }
        return amount.compareTo(dailyBudget.multiply(BigDecimal.valueOf(0.60))) <= 0;
    }

    private boolean matchesInterest(Place place, List<String> interests) {
        if (interests == null || interests.isEmpty()) {
            return true;
        }
        String subcategory = place.getSubcategory() == null ? "" : place.getSubcategory();
        String haystack = (place.getCategory().name() + " " + subcategory + " " + place.getDescription()).toLowerCase(Locale.ROOT);
        return interests.stream().map(value -> value.toLowerCase(Locale.ROOT)).anyMatch(haystack::contains);
    }

    private ItineraryItemResponse toGeneratedItem(int day, ItineraryPeriod period, ItineraryItemType itemType, UUID referenceId, String title, BigDecimal estimatedCost, int sortOrder) {
        return new ItineraryItemResponse(null, day, period, itemType, referenceId, title, estimatedCost, sortOrder);
    }

    private ItineraryResponse toResponse(Itinerary itinerary, boolean generated) {
        return new ItineraryResponse(
                itinerary.getId(),
                itinerary.getTitle(),
                itinerary.getCityBase(),
                itinerary.getTotalDays(),
                itinerary.getTotalBudget(),
                itinerary.getTravelStyle(),
                itinerary.getCompanionType(),
                readInterests(itinerary.getInterestsJson()),
                itinerary.getNotes(),
                itinerary.getItems().stream().map(this::toItemResponse).toList(),
                itinerary.getCreatedAt(),
                itinerary.getUpdatedAt(),
                generated
        );
    }

    private ItineraryItemResponse toItemResponse(ItineraryItem item) {
        return new ItineraryItemResponse(
                item.getId(),
                item.getDayNumber(),
                item.getPeriod(),
                item.getItemType(),
                item.getReferenceId(),
                item.getTitle(),
                item.getEstimatedCost(),
                item.getSortOrder()
        );
    }

    private String writeJson(List<String> values) {
        try {
            return objectMapper.writeValueAsString(values);
        } catch (JsonProcessingException ex) {
            throw new BadRequestException("Could not serialize itinerary interests");
        }
    }

    private List<String> readInterests(String json) {
        try {
            return objectMapper.readValue(json, new TypeReference<>() {
            });
        } catch (JsonProcessingException ex) {
            throw new BadRequestException("Could not deserialize itinerary interests");
        }
    }
}
