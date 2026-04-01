package com.turismo.module.itinerary.repository;

import com.turismo.module.itinerary.entity.Itinerary;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ItineraryRepository extends JpaRepository<Itinerary, UUID> {

    @EntityGraph(attributePaths = "items")
    List<Itinerary> findByUserIdOrderByCreatedAtDesc(UUID userId);

    @EntityGraph(attributePaths = "items")
    Optional<Itinerary> findByIdAndUserId(UUID id, UUID userId);
}
