package com.turismo.module.itinerary.dto;

import com.turismo.module.itinerary.entity.ItineraryItemType;
import com.turismo.module.itinerary.entity.ItineraryPeriod;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;
import java.math.BigDecimal;
import java.util.UUID;

public record ItineraryItemRequest(
        @NotNull @Positive Integer dayNumber,
        @NotNull ItineraryPeriod period,
        @NotNull ItineraryItemType itemType,
        UUID referenceId,
        @NotBlank String title,
        @PositiveOrZero BigDecimal estimatedCost,
        @NotNull @PositiveOrZero Integer sortOrder
) {
}
