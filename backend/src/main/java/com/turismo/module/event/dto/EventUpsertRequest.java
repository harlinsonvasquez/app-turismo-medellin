package com.turismo.module.event.dto;

import com.turismo.module.event.entity.EventCategory;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.UUID;

public record EventUpsertRequest(
        UUID businessId,
        @NotBlank String title,
        @NotBlank String slug,
        @NotBlank String description,
        @NotNull EventCategory category,
        @NotBlank String city,
        @NotBlank String department,
        @NotBlank String address,
        @NotNull BigDecimal latitude,
        @NotNull BigDecimal longitude,
        @NotNull OffsetDateTime startDate,
        OffsetDateTime endDate,
        @PositiveOrZero BigDecimal averagePrice,
        boolean featured,
        Boolean active
) {
}
