package com.turismo.module.business.controller;

import com.turismo.module.business.dto.BusinessResponse;
import com.turismo.module.business.dto.BusinessUpsertRequest;
import com.turismo.module.business.service.BusinessService;
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
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/businesses")
public class BusinessController {

    private final BusinessService businessService;

    public BusinessController(BusinessService businessService) {
        this.businessService = businessService;
    }

    @GetMapping
    public List<BusinessResponse> findAll() {
        return businessService.findAll();
    }

    @GetMapping("/{id}")
    public BusinessResponse findById(@PathVariable UUID id) {
        return businessService.findById(id);
    }

    @GetMapping("/me")
    public List<BusinessResponse> findMine() {
        return businessService.findMine();
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public BusinessResponse create(@Valid @RequestBody BusinessUpsertRequest request) {
        return businessService.create(request);
    }

    @PutMapping("/{id}")
    public BusinessResponse update(@PathVariable UUID id, @Valid @RequestBody BusinessUpsertRequest request) {
        return businessService.update(id, request);
    }
}
