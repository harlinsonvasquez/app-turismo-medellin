package com.turismo.module.place.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;

public record PlaceImageRequest(
        @NotBlank String imageUrl,
        boolean cover,
        @NotNull @PositiveOrZero Integer sortOrder
) {
}
