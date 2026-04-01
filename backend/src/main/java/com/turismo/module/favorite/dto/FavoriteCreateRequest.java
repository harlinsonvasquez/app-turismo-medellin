package com.turismo.module.favorite.dto;

import com.turismo.module.favorite.entity.FavoriteItemType;
import jakarta.validation.constraints.NotNull;
import java.util.UUID;

public record FavoriteCreateRequest(
        @NotNull FavoriteItemType itemType,
        @NotNull UUID referenceId
) {
}
