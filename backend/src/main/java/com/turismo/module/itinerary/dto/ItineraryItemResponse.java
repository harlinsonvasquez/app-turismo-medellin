package com.turismo.module.itinerary.dto;

import com.turismo.module.itinerary.entity.ItineraryItemType;
import com.turismo.module.itinerary.entity.ItineraryPeriod;
import java.math.BigDecimal;
import java.util.UUID;

public record ItineraryItemResponse(
        UUID id,
        Integer dayNumber,
        ItineraryPeriod period,
        ItineraryItemType itemType,
        UUID referenceId,
        String title,
        BigDecimal estimatedCost,
        Integer sortOrder
) {
}
