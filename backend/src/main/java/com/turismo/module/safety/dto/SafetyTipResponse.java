package com.turismo.module.safety.dto;

import com.turismo.module.safety.entity.RiskLevel;
import java.time.OffsetDateTime;
import java.util.UUID;

public record SafetyTipResponse(
        UUID id,
        String city,
        String zone,
        String title,
        String description,
        RiskLevel riskLevel,
        boolean active,
        OffsetDateTime createdAt
) {
}
