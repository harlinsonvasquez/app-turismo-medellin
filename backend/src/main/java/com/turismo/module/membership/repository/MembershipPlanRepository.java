package com.turismo.module.membership.repository;

import com.turismo.module.membership.entity.MembershipPlan;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MembershipPlanRepository extends JpaRepository<MembershipPlan, UUID> {
}
