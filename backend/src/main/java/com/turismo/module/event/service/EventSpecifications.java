package com.turismo.module.event.service;

import com.turismo.module.event.dto.EventFilter;
import com.turismo.module.event.entity.Event;
import jakarta.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;
import org.springframework.data.jpa.domain.Specification;

public final class EventSpecifications {

    private EventSpecifications() {
    }

    public static Specification<Event> withFilter(EventFilter filter) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (filter.city() != null && !filter.city().isBlank()) {
                predicates.add(cb.equal(cb.lower(root.get("city")), filter.city().trim().toLowerCase()));
            }
            if (filter.category() != null) {
                predicates.add(cb.equal(root.get("category"), filter.category()));
            }
            if (filter.featured() != null) {
                predicates.add(cb.equal(root.get("featured"), filter.featured()));
            }
            if (filter.startDateFrom() != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("startDate"), filter.startDateFrom()));
            }
            if (filter.startDateTo() != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("startDate"), filter.startDateTo()));
            }
            if (filter.minPrice() != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("averagePrice"), filter.minPrice()));
            }
            if (filter.maxPrice() != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("averagePrice"), filter.maxPrice()));
            }
            if (filter.active() != null) {
                predicates.add(cb.equal(root.get("active"), filter.active()));
            }
            return cb.and(predicates.toArray(Predicate[]::new));
        };
    }
}
