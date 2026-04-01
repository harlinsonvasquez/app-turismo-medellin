package com.turismo.security;

import com.turismo.config.AppProperties;
import java.util.List;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    private static final List<String> DEFAULT_ALLOWED_ORIGIN_PATTERNS = List.of(
            "http://localhost:*",
            "http://127.0.0.1:*"
    );
    private static final List<String> DEFAULT_ALLOWED_METHODS = List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS");
    private static final List<String> DEFAULT_ALLOWED_HEADERS = List.of("*");
    private static final List<String> DEFAULT_EXPOSED_HEADERS = List.of("Authorization", "Content-Type");
    private static final long DEFAULT_MAX_AGE_SECONDS = 3600L;

    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final CustomUserDetailsService userDetailsService;
    private final AppProperties appProperties;
    private final SecurityErrorResponseWriter errorResponseWriter;

    public SecurityConfig(
            JwtAuthenticationFilter jwtAuthenticationFilter,
            CustomUserDetailsService userDetailsService,
            AppProperties appProperties,
            SecurityErrorResponseWriter errorResponseWriter
    ) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
        this.userDetailsService = userDetailsService;
        this.appProperties = appProperties;
        this.errorResponseWriter = errorResponseWriter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .cors(Customizer.withDefaults())
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .exceptionHandling(exception -> exception
                        .authenticationEntryPoint((request, response, ex) -> errorResponseWriter.write(
                                response,
                                401,
                                "Unauthorized",
                                "Authentication is required to access this resource",
                                request.getRequestURI()
                        ))
                        .accessDeniedHandler((request, response, ex) -> errorResponseWriter.write(
                                response,
                                403,
                                "Forbidden",
                                "You do not have permission to access this resource",
                                request.getRequestURI()
                        )))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                        .requestMatchers("/error").permitAll()
                        .requestMatchers("/actuator/health").permitAll()
                        .requestMatchers(HttpMethod.POST, "/api/auth/register", "/api/auth/login").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/places/**", "/api/events/**", "/api/safety-tips/**",
                                "/api/membership-plans/**", "/api/businesses/**").permitAll()
                        .requestMatchers(HttpMethod.POST, "/api/itineraries/generate").permitAll()
                        .anyRequest().authenticated())
                .authenticationProvider(authenticationProvider())
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    @Profile({"local", "dev"})
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        AppProperties.Cors cors = appProperties.cors();
        configuration.setAllowedOriginPatterns(valueOrDefault(cors != null ? cors.allowedOriginPatterns() : null, DEFAULT_ALLOWED_ORIGIN_PATTERNS));
        configuration.setAllowedMethods(valueOrDefault(cors != null ? cors.allowedMethods() : null, DEFAULT_ALLOWED_METHODS));
        configuration.setAllowedHeaders(valueOrDefault(cors != null ? cors.allowedHeaders() : null, DEFAULT_ALLOWED_HEADERS));
        configuration.setExposedHeaders(valueOrDefault(cors != null ? cors.exposedHeaders() : null, DEFAULT_EXPOSED_HEADERS));
        configuration.setAllowCredentials(cors == null || cors.allowCredentials() == null || cors.allowCredentials());
        configuration.setMaxAge(cors == null || cors.maxAgeSeconds() == null ? DEFAULT_MAX_AGE_SECONDS : cors.maxAgeSeconds());

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    private <T> List<T> valueOrDefault(List<T> configuredValues, List<T> defaultValues) {
        return configuredValues == null || configuredValues.isEmpty() ? defaultValues : configuredValues;
    }

    @Bean
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(userDetailsService);
        provider.setPasswordEncoder(passwordEncoder());
        return provider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
