package com.turismo.module.membership.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record MembershipPlanResponse(
        UUID id,
        String name,
        BigDecimal monthlyPrice,
        String featuresJson,
        boolean active
) {
}
