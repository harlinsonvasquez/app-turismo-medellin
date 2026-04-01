package com.turismo.module.membership.entity;

import com.turismo.common.entity.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "membership_plans")
public class MembershipPlan extends BaseEntity {

    @Column(nullable = false, length = 120)
    private String name;

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal monthlyPrice;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String featuresJson;

    @Column(nullable = false)
    private boolean active = true;
}
