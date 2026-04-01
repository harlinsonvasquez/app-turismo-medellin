package com.turismo.module.business.entity;

import com.turismo.common.entity.AuditableEntity;
import com.turismo.module.user.entity.User;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "businesses")
public class Business extends AuditableEntity {

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "owner_id", nullable = false)
    private User owner;

    @Column(nullable = false, length = 180)
    private String businessName;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 40)
    private BusinessType businessType;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(length = 40)
    private String phone;

    @Column(length = 180)
    private String email;

    @Column(length = 255)
    private String website;

    @Column(nullable = false)
    private boolean verified = false;

    @Column(nullable = false)
    private boolean active = true;
}
