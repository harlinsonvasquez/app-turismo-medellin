package com.turismo.module.place.dto;

import com.turismo.module.place.entity.PlaceCategory;
import java.math.BigDecimal;

public record PlaceFilter(
        String city,
        PlaceCategory category,
        String subcategory,
        BigDecimal minPrice,
        BigDecimal maxPrice,
        Boolean safeZone,
        Boolean featured,
        Boolean active,
        String search,
        BigDecimal latitude,
        BigDecimal longitude,
        BigDecimal radiusKm
) {
}
