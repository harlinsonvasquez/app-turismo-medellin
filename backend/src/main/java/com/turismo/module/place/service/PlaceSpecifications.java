package com.turismo.module.place.service;

import com.turismo.module.place.dto.PlaceFilter;
import com.turismo.module.place.entity.Place;
import jakarta.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;
import org.springframework.data.jpa.domain.Specification;

public final class PlaceSpecifications {

    private PlaceSpecifications() {
    }

    public static Specification<Place> withFilter(PlaceFilter filter) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (filter.city() != null && !filter.city().isBlank()) {
                predicates.add(cb.equal(cb.lower(root.get("city")), filter.city().trim().toLowerCase()));
            }
            if (filter.category() != null) {
                predicates.add(cb.equal(root.get("category"), filter.category()));
            }
            if (filter.subcategory() != null && !filter.subcategory().isBlank()) {
                predicates.add(cb.equal(cb.lower(root.get("subcategory")), filter.subcategory().trim().toLowerCase()));
            }
            if (filter.minPrice() != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("averagePrice"), filter.minPrice()));
            }
            if (filter.maxPrice() != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("averagePrice"), filter.maxPrice()));
            }
            if (filter.safeZone() != null) {
                predicates.add(cb.equal(root.get("safeZone"), filter.safeZone()));
            }
            if (filter.featured() != null) {
                predicates.add(cb.equal(root.get("featured"), filter.featured()));
            }
            if (filter.active() != null) {
                predicates.add(cb.equal(root.get("active"), filter.active()));
            }
            if (filter.search() != null && !filter.search().isBlank()) {
                String pattern = "%" + filter.search().trim().toLowerCase() + "%";
                predicates.add(cb.or(
                        cb.like(cb.lower(root.get("name")), pattern),
                        cb.like(cb.lower(root.get("description")), pattern),
                        cb.like(cb.lower(root.get("address")), pattern)
                ));
            }
            return cb.and(predicates.toArray(Predicate[]::new));
        };
    }
}
