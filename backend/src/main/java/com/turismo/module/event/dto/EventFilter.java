package com.turismo.module.event.dto;

import com.turismo.module.event.entity.EventCategory;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

public record EventFilter(
        String city,
        EventCategory category,
        Boolean featured,
        OffsetDateTime startDateFrom,
        OffsetDateTime startDateTo,
        BigDecimal minPrice,
        BigDecimal maxPrice,
        Boolean active
) {
}
