package com.turismo.module.event.dto;

import com.turismo.module.event.entity.EventCategory;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.UUID;

public record EventResponse(
        UUID id,
        UUID businessId,
        String businessName,
        String title,
        String slug,
        String description,
        EventCategory category,
        String city,
        String department,
        String address,
        BigDecimal latitude,
        BigDecimal longitude,
        OffsetDateTime startDate,
        OffsetDateTime endDate,
        BigDecimal averagePrice,
        boolean featured,
        boolean active,
        OffsetDateTime createdAt,
        OffsetDateTime updatedAt
) {
}
