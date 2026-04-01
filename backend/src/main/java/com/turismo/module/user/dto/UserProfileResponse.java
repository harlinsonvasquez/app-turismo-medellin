package com.turismo.module.user.dto;

import com.turismo.module.user.entity.UserRole;
import java.time.OffsetDateTime;
import java.util.UUID;

public record UserProfileResponse(
        UUID id,
        String fullName,
        String email,
        UserRole role,
        boolean active,
        OffsetDateTime createdAt,
        OffsetDateTime updatedAt
) {
}
