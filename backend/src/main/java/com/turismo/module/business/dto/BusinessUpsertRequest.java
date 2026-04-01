package com.turismo.module.business.dto;

import com.turismo.module.business.entity.BusinessType;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record BusinessUpsertRequest(
        @NotBlank @Size(max = 180) String businessName,
        @NotNull BusinessType businessType,
        @Size(max = 2000) String description,
        @Size(max = 40) String phone,
        @Email @Size(max = 180) String email,
        @Size(max = 255) String website,
        Boolean active
) {
}
