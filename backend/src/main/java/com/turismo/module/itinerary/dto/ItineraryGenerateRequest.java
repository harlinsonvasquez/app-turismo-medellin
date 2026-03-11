package com.turismo.module.itinerary.dto;

import com.turismo.module.itinerary.entity.CompanionType;
import com.turismo.module.itinerary.entity.TravelStyle;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;
import java.util.List;

public record ItineraryGenerateRequest(
        @NotBlank String city,
        @NotNull @Positive Integer totalDays,
        @NotNull @Positive BigDecimal totalBudget,
        @NotNull TravelStyle travelStyle,
        @NotNull CompanionType companionType,
        @NotEmpty List<String> interests,
        Boolean safeZoneOnly,
        String notes
) {
}
