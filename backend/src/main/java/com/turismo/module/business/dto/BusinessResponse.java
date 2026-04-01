package com.turismo.module.business.dto;

import com.turismo.module.business.entity.BusinessType;
import java.time.OffsetDateTime;
import java.util.UUID;

public record BusinessResponse(
        UUID id,
        UUID ownerId,
        String ownerName,
        String businessName,
        BusinessType businessType,
        String description,
        String phone,
        String email,
        String website,
        boolean verified,
        boolean active,
        OffsetDateTime createdAt,
        OffsetDateTime updatedAt
) {
}
