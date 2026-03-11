package com.turismo.module.membership.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import java.math.BigDecimal;

public record MembershipPlanUpsertRequest(
        @NotBlank String name,
        @NotNull @PositiveOrZero BigDecimal monthlyPrice,
        @NotBlank String featuresJson,
        Boolean active
) {
}
