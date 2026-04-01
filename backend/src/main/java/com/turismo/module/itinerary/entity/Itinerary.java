package com.turismo.module.itinerary.entity;

import com.turismo.common.entity.AuditableEntity;
import com.turismo.module.user.entity.User;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OrderBy;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "itineraries")
public class Itinerary extends AuditableEntity {

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false, length = 180)
    private String title;

    @Column(nullable = false, length = 120)
    private String cityBase;

    @Column(nullable = false)
    private Integer totalDays;

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal totalBudget;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private TravelStyle travelStyle;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private CompanionType companionType;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String interestsJson;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @OneToMany(mappedBy = "itinerary", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("dayNumber asc, sortOrder asc")
    private List<ItineraryItem> items = new ArrayList<>();
}
