package com.turismo.config;

import java.util.List;
import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app")
public record AppProperties(Jwt jwt, Cors cors) {

    public record Jwt(String secret, long expirationMs) {
    }

    public record Cors(
            List<String> allowedOriginPatterns,
            List<String> allowedMethods,
            List<String> allowedHeaders,
            List<String> exposedHeaders,
            Boolean allowCredentials,
            Long maxAgeSeconds
    ) {
    }
}
