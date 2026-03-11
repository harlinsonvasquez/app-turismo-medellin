package com.turismo.module.safety.repository;

import com.turismo.module.safety.entity.SafetyTip;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SafetyTipRepository extends JpaRepository<SafetyTip, UUID> {

    List<SafetyTip> findByCityIgnoreCaseAndActiveTrue(String city);

    List<SafetyTip> findByCityIgnoreCaseAndZoneIgnoreCaseAndActiveTrue(String city, String zone);
}
