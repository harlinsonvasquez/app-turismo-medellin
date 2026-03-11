package com.turismo.module.favorite.service;

import com.turismo.exception.ConflictException;
import com.turismo.exception.ResourceNotFoundException;
import com.turismo.module.event.entity.Event;
import com.turismo.module.event.repository.EventRepository;
import com.turismo.module.favorite.dto.FavoriteCreateRequest;
import com.turismo.module.favorite.dto.FavoriteResponse;
import com.turismo.module.favorite.entity.Favorite;
import com.turismo.module.favorite.entity.FavoriteItemType;
import com.turismo.module.favorite.repository.FavoriteRepository;
import com.turismo.module.place.entity.Place;
import com.turismo.module.place.repository.PlaceRepository;
import com.turismo.module.user.entity.User;
import com.turismo.module.user.repository.UserRepository;
import com.turismo.security.SecurityUtils;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class FavoriteService {

    private final FavoriteRepository favoriteRepository;
    private final UserRepository userRepository;
    private final PlaceRepository placeRepository;
    private final EventRepository eventRepository;

    public FavoriteService(
            FavoriteRepository favoriteRepository,
            UserRepository userRepository,
            PlaceRepository placeRepository,
            EventRepository eventRepository
    ) {
        this.favoriteRepository = favoriteRepository;
        this.userRepository = userRepository;
        this.placeRepository = placeRepository;
        this.eventRepository = eventRepository;
    }

    @Transactional(readOnly = true)
    public List<FavoriteResponse> findMine() {
        return favoriteRepository.findByUserIdOrderByCreatedAtDesc(SecurityUtils.currentUserId())
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional
    public FavoriteResponse create(FavoriteCreateRequest request) {
        UUID userId = SecurityUtils.currentUserId();
        if (favoriteRepository.existsByUserIdAndItemTypeAndReferenceId(userId, request.itemType(), request.referenceId())) {
            throw new ConflictException("Favorite already exists");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        ensureReferenceExists(request.itemType(), request.referenceId());

        Favorite favorite = new Favorite();
        favorite.setUser(user);
        favorite.setItemType(request.itemType());
        favorite.setReferenceId(request.referenceId());
        return toResponse(favoriteRepository.save(favorite));
    }

    @Transactional
    public void delete(UUID id) {
        Favorite favorite = favoriteRepository.findByIdAndUserId(id, SecurityUtils.currentUserId())
                .orElseThrow(() -> new ResourceNotFoundException("Favorite not found"));
        favoriteRepository.delete(favorite);
    }

    private void ensureReferenceExists(FavoriteItemType itemType, UUID referenceId) {
        switch (itemType) {
            case PLACE -> placeRepository.findById(referenceId)
                    .orElseThrow(() -> new ResourceNotFoundException("Place not found"));
            case EVENT -> eventRepository.findById(referenceId)
                    .orElseThrow(() -> new ResourceNotFoundException("Event not found"));
        }
    }

    private FavoriteResponse toResponse(Favorite favorite) {
        if (favorite.getItemType() == FavoriteItemType.PLACE) {
            Place place = placeRepository.findById(favorite.getReferenceId())
                    .orElseThrow(() -> new ResourceNotFoundException("Place not found"));
            String imageUrl = place.getImages().stream().findFirst().map(image -> image.getImageUrl()).orElse(null);
            return new FavoriteResponse(favorite.getId(), favorite.getItemType(), favorite.getReferenceId(), place.getName(), place.getCity(), imageUrl, favorite.getCreatedAt());
        }

        Event event = eventRepository.findById(favorite.getReferenceId())
                .orElseThrow(() -> new ResourceNotFoundException("Event not found"));
        return new FavoriteResponse(favorite.getId(), favorite.getItemType(), favorite.getReferenceId(), event.getTitle(), event.getCity(), null, favorite.getCreatedAt());
    }
}
