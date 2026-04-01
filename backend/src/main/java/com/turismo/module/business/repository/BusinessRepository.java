package com.turismo.module.business.repository;

import com.turismo.module.business.entity.Business;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BusinessRepository extends JpaRepository<Business, UUID> {

    List<Business> findByOwnerId(UUID ownerId);
}
