package com.turismo.module.safety.controller;

import com.turismo.module.safety.dto.SafetyTipResponse;
import com.turismo.module.safety.dto.SafetyTipUpsertRequest;
import com.turismo.module.safety.service.SafetyTipService;
import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/safety-tips")
public class SafetyTipController {

    private final SafetyTipService safetyTipService;

    public SafetyTipController(SafetyTipService safetyTipService) {
        this.safetyTipService = safetyTipService;
    }

    @GetMapping
    public List<SafetyTipResponse> findAll(@RequestParam(required = false) String city, @RequestParam(required = false) String zone) {
        return safetyTipService.findAll(city, zone);
    }

    @GetMapping("/{id}")
    public SafetyTipResponse findById(@PathVariable UUID id) {
        return safetyTipService.findById(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public SafetyTipResponse create(@Valid @RequestBody SafetyTipUpsertRequest request) {
        return safetyTipService.create(request);
    }

    @PutMapping("/{id}")
    public SafetyTipResponse update(@PathVariable UUID id, @Valid @RequestBody SafetyTipUpsertRequest request) {
        return safetyTipService.update(id, request);
    }
}
