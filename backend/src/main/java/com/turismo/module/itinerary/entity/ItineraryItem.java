package com.turismo.module.itinerary.entity;

import com.turismo.common.entity.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "itinerary_items")
public class ItineraryItem extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "itinerary_id", nullable = false)
    private Itinerary itinerary;

    @Column(nullable = false)
    private Integer dayNumber;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private ItineraryPeriod period;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private ItineraryItemType itemType;

    private UUID referenceId;

    @Column(nullable = false, length = 180)
    private String title;

    @Column(precision = 12, scale = 2)
    private BigDecimal estimatedCost;

    @Column(nullable = false)
    private Integer sortOrder;
}
