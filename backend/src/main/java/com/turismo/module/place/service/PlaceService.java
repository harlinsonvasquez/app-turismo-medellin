package com.turismo.module.place.service;

import com.turismo.exception.ForbiddenException;
import com.turismo.exception.ResourceNotFoundException;
import com.turismo.module.business.entity.Business;
import com.turismo.module.business.repository.BusinessRepository;
import com.turismo.module.place.dto.PlaceFilter;
import com.turismo.module.place.dto.PlaceImageRequest;
import com.turismo.module.place.dto.PlaceImageResponse;
import com.turismo.module.place.dto.PlaceResponse;
import com.turismo.module.place.dto.PlaceUpsertRequest;
import com.turismo.module.place.entity.Place;
import com.turismo.module.place.entity.PlaceImage;
import com.turismo.module.place.repository.PlaceRepository;
import com.turismo.security.SecurityUtils;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PlaceService {

    private final PlaceRepository placeRepository;
    private final BusinessRepository businessRepository;

    public PlaceService(PlaceRepository placeRepository, BusinessRepository businessRepository) {
        this.placeRepository = placeRepository;
        this.businessRepository = businessRepository;
    }

    @Transactional(readOnly = true)
    public List<PlaceResponse> findAll(PlaceFilter filter) {
        List<Place> places = placeRepository.findAll(PlaceSpecifications.withFilter(filter));
        return places.stream()
                .map(place -> toResponse(place, calculateDistance(place, filter.latitude(), filter.longitude())))
                .filter(place -> filter.radiusKm() == null || place.distanceKm() == null || place.distanceKm() <= filter.radiusKm().doubleValue())
                .sorted(Comparator.comparing(PlaceResponse::distanceKm, Comparator.nullsLast(Double::compareTo)))
                .toList();
    }

    @Transactional(readOnly = true)
    public PlaceResponse findById(UUID id) {
        return toResponse(getPlace(id), null);
    }

    @Transactional
    @PreAuthorize("hasAnyRole('ADMIN','BUSINESS_OWNER')")
    public PlaceResponse create(PlaceUpsertRequest request) {
        Place place = new Place();
        apply(place, request);
        return toResponse(placeRepository.save(place), null);
    }

    @Transactional
    @PreAuthorize("hasAnyRole('ADMIN','BUSINESS_OWNER')")
    public PlaceResponse update(UUID id, PlaceUpsertRequest request) {
        Place place = getPlace(id);
        authorizeBusinessOwnership(place.getBusiness());
        apply(place, request);
        return toResponse(placeRepository.save(place), null);
    }

    @Transactional
    @PreAuthorize("hasAnyRole('ADMIN','BUSINESS_OWNER')")
    public void delete(UUID id) {
        Place place = getPlace(id);
        authorizeBusinessOwnership(place.getBusiness());
        place.setActive(false);
        placeRepository.save(place);
    }

    private void apply(Place place, PlaceUpsertRequest request) {
        place.setBusiness(resolveBusiness(request.businessId()));
        place.setName(request.name().trim());
        place.setSlug(request.slug().trim().toLowerCase());
        place.setCategory(request.category());
        place.setSubcategory(request.subcategory());
        place.setDescription(request.description().trim());
        place.setCity(request.city().trim());
        place.setDepartment(request.department().trim());
        place.setAddress(request.address().trim());
        place.setLatitude(request.latitude());
        place.setLongitude(request.longitude());
        place.setAveragePrice(request.averagePrice());
        place.setEstimatedPriceLevel(request.estimatedPriceLevel());
        place.setRating(request.rating());
        place.setSafeZone(request.safeZone());
        place.setFeatured(request.featured());
        place.setOpeningHoursJson(request.openingHoursJson());
        if (request.active() != null) {
            place.setActive(request.active());
        }

        place.getImages().clear();
        for (PlaceImageRequest imageRequest : request.images()) {
            PlaceImage image = new PlaceImage();
            image.setPlace(place);
            image.setImageUrl(imageRequest.imageUrl());
            image.setCover(imageRequest.cover());
            image.setSortOrder(imageRequest.sortOrder());
            place.getImages().add(image);
        }
    }

    private Business resolveBusiness(UUID businessId) {
        if (businessId == null) {
            if (!"ADMIN".equals(SecurityUtils.getCurrentUser().getRole())) {
                throw new ForbiddenException("Only admins can create orphan places without a linked business");
            }
            return null;
        }
        Business business = businessRepository.findById(businessId)
                .orElseThrow(() -> new ResourceNotFoundException("Business not found"));
        authorizeBusinessOwnership(business);
        return business;
    }

    private void authorizeBusinessOwnership(Business business) {
        if (business == null) {
            if (!"ADMIN".equals(SecurityUtils.getCurrentUser().getRole())) {
                throw new ForbiddenException("Only admins can manage places without a linked business");
            }
            return;
        }
        UUID currentUserId = SecurityUtils.currentUserId();
        if (!business.getOwner().getId().equals(currentUserId) && !"ADMIN".equals(SecurityUtils.getCurrentUser().getRole())) {
            throw new ForbiddenException("You are not allowed to manage this business resource");
        }
    }

    private Place getPlace(UUID id) {
        return placeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Place not found"));
    }

    private PlaceResponse toResponse(Place place, Double distanceKm) {
        return new PlaceResponse(
                place.getId(),
                place.getBusiness() != null ? place.getBusiness().getId() : null,
                place.getBusiness() != null ? place.getBusiness().getBusinessName() : null,
                place.getName(),
                place.getSlug(),
                place.getCategory(),
                place.getSubcategory(),
                place.getDescription(),
                place.getCity(),
                place.getDepartment(),
                place.getAddress(),
                place.getLatitude(),
                place.getLongitude(),
                place.getAveragePrice(),
                place.getEstimatedPriceLevel(),
                place.getRating(),
                place.isSafeZone(),
                place.isFeatured(),
                place.isActive(),
                place.getOpeningHoursJson(),
                place.getImages().stream().map(this::toImageResponse).toList(),
                place.getCreatedAt(),
                place.getUpdatedAt(),
                distanceKm
        );
    }

    private PlaceImageResponse toImageResponse(PlaceImage image) {
        return new PlaceImageResponse(image.getId(), image.getImageUrl(), image.isCover(), image.getSortOrder());
    }

    private Double calculateDistance(Place place, BigDecimal latitude, BigDecimal longitude) {
        if (latitude == null || longitude == null) {
            return null;
        }
        double lat1 = Math.toRadians(latitude.doubleValue());
        double lon1 = Math.toRadians(longitude.doubleValue());
        double lat2 = Math.toRadians(place.getLatitude().doubleValue());
        double lon2 = Math.toRadians(place.getLongitude().doubleValue());
        double deltaLat = lat2 - lat1;
        double deltaLon = lon2 - lon1;
        double a = Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2)
                + Math.cos(lat1) * Math.cos(lat2) * Math.sin(deltaLon / 2) * Math.sin(deltaLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return BigDecimal.valueOf(6371.0 * c).setScale(2, RoundingMode.HALF_UP).doubleValue();
    }
}
