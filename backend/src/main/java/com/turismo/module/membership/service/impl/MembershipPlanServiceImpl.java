package com.turismo.module.membership.service.impl;

import com.turismo.exception.ResourceNotFoundException;
import com.turismo.module.membership.dto.MembershipPlanResponse;
import com.turismo.module.membership.dto.MembershipPlanUpsertRequest;
import com.turismo.module.membership.entity.MembershipPlan;
import com.turismo.module.membership.repository.MembershipPlanRepository;
import com.turismo.module.membership.service.MembershipPlanService;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class MembershipPlanServiceImpl implements MembershipPlanService {

    private final MembershipPlanRepository membershipPlanRepository;

    @Override
    @Transactional(readOnly = true)
    public List<MembershipPlanResponse> findAll() {
        return membershipPlanRepository.findAll().stream().map(this::toResponse).toList();
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public MembershipPlanResponse create(MembershipPlanUpsertRequest request) {
        MembershipPlan plan = new MembershipPlan();
        apply(plan, request);
        return toResponse(membershipPlanRepository.save(plan));
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public MembershipPlanResponse update(UUID id, MembershipPlanUpsertRequest request) {
        MembershipPlan plan = membershipPlanRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Membership plan not found"));
        apply(plan, request);
        return toResponse(membershipPlanRepository.save(plan));
    }

    private void apply(MembershipPlan plan, MembershipPlanUpsertRequest request) {
        plan.setName(request.name().trim());
        plan.setMonthlyPrice(request.monthlyPrice());
        plan.setFeaturesJson(request.featuresJson());
        if (request.active() != null) {
            plan.setActive(request.active());
        }
    }

    private MembershipPlanResponse toResponse(MembershipPlan plan) {
        return new MembershipPlanResponse(
                plan.getId(),
                plan.getName(),
                plan.getMonthlyPrice(),
                plan.getFeaturesJson(),
                plan.isActive()
        );
    }
}
