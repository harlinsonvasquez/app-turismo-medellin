package com.turismo.module.membership.service;

import com.turismo.module.membership.dto.MembershipPlanResponse;
import com.turismo.module.membership.dto.MembershipPlanUpsertRequest;
import java.util.List;
import java.util.UUID;

public interface MembershipPlanService {

    List<MembershipPlanResponse> findAll();

    MembershipPlanResponse create(MembershipPlanUpsertRequest request);

    MembershipPlanResponse update(UUID id, MembershipPlanUpsertRequest request);
}
