package com.turismo.module.place.dto;

import com.turismo.module.place.entity.PlaceCategory;
import com.turismo.module.place.entity.PriceLevel;
import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

public record PlaceUpsertRequest(
        UUID businessId,
        @NotBlank String name,
        @NotBlank String slug,
        @NotNull PlaceCategory category,
        String subcategory,
        @NotBlank String description,
        @NotBlank String city,
        @NotBlank String department,
        @NotBlank String address,
        @NotNull BigDecimal latitude,
        @NotNull BigDecimal longitude,
        @PositiveOrZero BigDecimal averagePrice,
        @NotNull PriceLevel estimatedPriceLevel,
        @NotNull @DecimalMin("0.0") @DecimalMax("5.0") BigDecimal rating,
        boolean safeZone,
        boolean featured,
        Boolean active,
        String openingHoursJson,
        @Valid @NotEmpty List<PlaceImageRequest> images
) {
}
