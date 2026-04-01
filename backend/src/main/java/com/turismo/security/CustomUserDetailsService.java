package com.turismo.security;

import com.turismo.exception.ResourceNotFoundException;
import com.turismo.module.user.entity.User;
import com.turismo.module.user.repository.UserRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String username) {
        User user = userRepository.findByEmailIgnoreCase(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        return new AuthenticatedUser(
                user.getId(),
                user.getEmail(),
                user.getPasswordHash(),
                user.isActive(),
                user.getRole().name()
        );
    }
}
