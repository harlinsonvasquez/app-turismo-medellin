package com.turismo.module.place.repository;

import com.turismo.module.place.entity.Place;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface PlaceRepository extends JpaRepository<Place, UUID>, JpaSpecificationExecutor<Place> {
}
