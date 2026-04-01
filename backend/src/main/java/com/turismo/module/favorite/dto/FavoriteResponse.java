package com.turismo.module.favorite.dto;

import com.turismo.module.favorite.entity.FavoriteItemType;
import java.time.OffsetDateTime;
import java.util.UUID;

public record FavoriteResponse(
        UUID id,
        FavoriteItemType itemType,
        UUID referenceId,
        String title,
        String subtitle,
        String imageUrl,
        OffsetDateTime createdAt
) {
}
