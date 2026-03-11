package com.turismo.module.favorite.repository;

import com.turismo.module.favorite.entity.Favorite;
import com.turismo.module.favorite.entity.FavoriteItemType;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FavoriteRepository extends JpaRepository<Favorite, UUID> {

    List<Favorite> findByUserIdOrderByCreatedAtDesc(UUID userId);

    Optional<Favorite> findByIdAndUserId(UUID id, UUID userId);

    boolean existsByUserIdAndItemTypeAndReferenceId(UUID userId, FavoriteItemType itemType, UUID referenceId);
}
