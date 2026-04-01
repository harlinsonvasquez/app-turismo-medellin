package com.turismo.module.membership.controller;

import com.turismo.module.membership.dto.MembershipPlanResponse;
import com.turismo.module.membership.dto.MembershipPlanUpsertRequest;
import com.turismo.module.membership.service.MembershipPlanService;
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
@RequestMapping("/api/membership-plans")
public class MembershipPlanController {

    private final MembershipPlanService membershipPlanService;

    public MembershipPlanController(MembershipPlanService membershipPlanService) {
        this.membershipPlanService = membershipPlanService;
    }

    @GetMapping
    public List<MembershipPlanResponse> findAll() {
        return membershipPlanService.findAll();
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public MembershipPlanResponse create(@Valid @RequestBody MembershipPlanUpsertRequest request) {
        return membershipPlanService.create(request);
    }

    @PutMapping("/{id}")
    public MembershipPlanResponse update(@PathVariable UUID id, @Valid @RequestBody MembershipPlanUpsertRequest request) {
        return membershipPlanService.update(id, request);
    }
}
