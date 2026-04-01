package com.turismo.module.itinerary.dto;

import com.turismo.module.itinerary.entity.CompanionType;
import com.turismo.module.itinerary.entity.TravelStyle;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

public record ItineraryResponse(
        UUID id,
        String title,
        String cityBase,
        Integer totalDays,
        BigDecimal totalBudget,
        TravelStyle travelStyle,
        CompanionType companionType,
        List<String> interests,
        String notes,
        List<ItineraryItemResponse> items,
        OffsetDateTime createdAt,
        OffsetDateTime updatedAt,
        boolean generated
) {
}
