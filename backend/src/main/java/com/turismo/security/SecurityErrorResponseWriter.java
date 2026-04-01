package com.turismo.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.turismo.common.dto.ApiErrorResponse;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.OffsetDateTime;
import java.util.List;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;

@Component
public class SecurityErrorResponseWriter {

    private final ObjectMapper objectMapper;

    public SecurityErrorResponseWriter(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    public void write(HttpServletResponse response, int status, String error, String message, String path) throws IOException {
        if (response.isCommitted()) {
            return;
        }

        response.setStatus(status);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding("UTF-8");

        ApiErrorResponse payload = new ApiErrorResponse(
                OffsetDateTime.now(),
                status,
                error,
                message,
                path,
                List.of()
        );

        objectMapper.writeValue(response.getWriter(), payload);
    }
}
