package com.turismo.module.auth.service.impl;

import com.turismo.exception.ConflictException;
import com.turismo.exception.UnauthorizedException;
import com.turismo.module.auth.dto.AuthResponse;
import com.turismo.module.auth.dto.LoginRequest;
import com.turismo.module.auth.dto.RegisterRequest;
import com.turismo.module.auth.service.AuthService;
import com.turismo.module.user.dto.UserProfileResponse;
import com.turismo.module.user.entity.User;
import com.turismo.module.user.entity.UserRole;
import com.turismo.module.user.repository.UserRepository;
import com.turismo.security.AuthenticatedUser;
import com.turismo.security.JwtService;
import com.turismo.security.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    @Override
    @Transactional
    public AuthResponse register(RegisterRequest request) {
        String normalizedEmail = request.email().trim().toLowerCase();
        if (userRepository.existsByEmailIgnoreCase(normalizedEmail)) {
            throw new ConflictException("A user with that email already exists");
        }

        User user = new User();
        user.setFullName(request.fullName().trim());
        user.setEmail(normalizedEmail);
        user.setPasswordHash(passwordEncoder.encode(request.password()));
        user.setRole(UserRole.TOURIST);
        user.setActive(true);

        User savedUser = userRepository.saveAndFlush(user);
        return buildAuthResponse(savedUser);
    }

    @Override
    @Transactional(readOnly = true)
    public AuthResponse login(LoginRequest request) {
        String normalizedEmail = request.email().trim().toLowerCase();
        User user = userRepository.findByEmailIgnoreCase(normalizedEmail)
                .orElseThrow(() -> new UnauthorizedException("Invalid credentials"));

        if (!user.isActive() || !passwordEncoder.matches(request.password(), user.getPasswordHash())) {
            throw new UnauthorizedException("Invalid credentials");
        }

        return buildAuthResponse(user);
    }

    @Override
    @Transactional(readOnly = true)
    public UserProfileResponse me() {
        User user = userRepository.findById(SecurityUtils.currentUserId())
                .orElseThrow(() -> new UnauthorizedException("Authenticated user was not found"));
        return toProfile(user);
    }

    private AuthResponse buildAuthResponse(User user) {
        AuthenticatedUser principal = new AuthenticatedUser(
                user.getId(),
                user.getEmail(),
                user.getPasswordHash(),
                user.isActive(),
                user.getRole().name()
        );
        return new AuthResponse(jwtService.generateToken(principal), toProfile(user));
    }

    private UserProfileResponse toProfile(User user) {
        return new UserProfileResponse(
                user.getId(),
                user.getFullName(),
                user.getEmail(),
                user.getRole(),
                user.isActive(),
                user.getCreatedAt(),
                user.getUpdatedAt()
        );
    }
}
