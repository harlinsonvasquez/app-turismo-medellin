package com.turismo.module.auth.service;

import com.turismo.module.auth.dto.AuthResponse;
import com.turismo.module.auth.dto.LoginRequest;
import com.turismo.module.auth.dto.RegisterRequest;
import com.turismo.module.user.dto.UserProfileResponse;

public interface AuthService {

    AuthResponse register(RegisterRequest request);

    AuthResponse login(LoginRequest request);

    UserProfileResponse me();
}
