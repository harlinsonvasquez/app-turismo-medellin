package com.turismo.module.itinerary.dto;

import com.turismo.module.itinerary.entity.CompanionType;
import com.turismo.module.itinerary.entity.TravelStyle;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;
import java.util.List;

public record ItinerarySaveRequest(
        @NotBlank String title,
        @NotBlank String cityBase,
        @NotNull @Positive Integer totalDays,
        @NotNull @Positive BigDecimal totalBudget,
        @NotNull TravelStyle travelStyle,
        @NotNull CompanionType companionType,
        @NotEmpty List<String> interests,
        String notes,
        @Valid @NotEmpty List<ItineraryItemRequest> items
) {
}
