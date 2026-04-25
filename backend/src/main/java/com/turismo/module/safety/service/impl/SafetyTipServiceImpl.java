package com.turismo.module.safety.service.impl;

import com.turismo.exception.ResourceNotFoundException;
import com.turismo.module.safety.dto.SafetyTipResponse;
import com.turismo.module.safety.dto.SafetyTipUpsertRequest;
import com.turismo.module.safety.entity.SafetyTip;
import com.turismo.module.safety.repository.SafetyTipRepository;
import com.turismo.module.safety.service.SafetyTipService;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class SafetyTipServiceImpl implements SafetyTipService {

    private final SafetyTipRepository safetyTipRepository;

    @Override
    @Transactional(readOnly = true)
    public List<SafetyTipResponse> findAll(String city, String zone) {
        List<SafetyTip> tips;
        if (city != null && !city.isBlank() && zone != null && !zone.isBlank()) {
            tips = safetyTipRepository.findByCityIgnoreCaseAndZoneIgnoreCaseAndActiveTrue(city, zone);
        } else if (city != null && !city.isBlank()) {
            tips = safetyTipRepository.findByCityIgnoreCaseAndActiveTrue(city);
        } else {
            tips = safetyTipRepository.findAll();
        }
        return tips.stream().map(this::toResponse).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public SafetyTipResponse findById(UUID id) {
        return toResponse(getTip(id));
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public SafetyTipResponse create(SafetyTipUpsertRequest request) {
        SafetyTip tip = new SafetyTip();
        apply(tip, request);
        return toResponse(safetyTipRepository.save(tip));
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public SafetyTipResponse update(UUID id, SafetyTipUpsertRequest request) {
        SafetyTip tip = getTip(id);
        apply(tip, request);
        return toResponse(safetyTipRepository.save(tip));
    }

    private SafetyTip getTip(UUID id) {
        return safetyTipRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Safety tip not found"));
    }

    private void apply(SafetyTip tip, SafetyTipUpsertRequest request) {
        tip.setCity(request.city().trim());
        tip.setZone(request.zone());
        tip.setTitle(request.title().trim());
        tip.setDescription(request.description().trim());
        tip.setRiskLevel(request.riskLevel());
        if (request.active() != null) {
            tip.setActive(request.active());
        }
    }

    private SafetyTipResponse toResponse(SafetyTip tip) {
        return new SafetyTipResponse(
                tip.getId(),
                tip.getCity(),
                tip.getZone(),
                tip.getTitle(),
                tip.getDescription(),
                tip.getRiskLevel(),
                tip.isActive(),
                tip.getCreatedAt()
        );
    }
}
