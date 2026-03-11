package com.turismo.module.safety.dto;

import com.turismo.module.safety.entity.RiskLevel;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record SafetyTipUpsertRequest(
        @NotBlank String city,
        String zone,
        @NotBlank String title,
        @NotBlank String description,
        @NotNull RiskLevel riskLevel,
        Boolean active
) {
}
