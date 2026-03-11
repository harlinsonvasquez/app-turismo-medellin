package com.turismo.module.place.dto;

import com.turismo.module.place.entity.PlaceCategory;
import com.turismo.module.place.entity.PriceLevel;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

public record PlaceResponse(
        UUID id,
        UUID businessId,
        String businessName,
        String name,
        String slug,
        PlaceCategory category,
        String subcategory,
        String description,
        String city,
        String department,
        String address,
        BigDecimal latitude,
        BigDecimal longitude,
        BigDecimal averagePrice,
        PriceLevel estimatedPriceLevel,
        BigDecimal rating,
        boolean safeZone,
        boolean featured,
        boolean active,
        String openingHoursJson,
        List<PlaceImageResponse> images,
        OffsetDateTime createdAt,
        OffsetDateTime updatedAt,
        Double distanceKm
) {
}
