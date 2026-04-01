package com.turismo.security;

import com.turismo.exception.UnauthorizedException;
import java.util.UUID;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

public final class SecurityUtils {

    private SecurityUtils() {
    }

    public static AuthenticatedUser getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !(authentication.getPrincipal() instanceof AuthenticatedUser user)) {
            throw new UnauthorizedException("Authenticated user was not found");
        }
        return user;
    }

    public static UUID currentUserId() {
        return getCurrentUser().getId();
    }
}
