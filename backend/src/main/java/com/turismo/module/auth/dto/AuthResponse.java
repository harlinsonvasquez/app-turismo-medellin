package com.turismo.module.auth.dto;

import com.turismo.module.user.dto.UserProfileResponse;

public record AuthResponse(String accessToken, UserProfileResponse user) {
}
