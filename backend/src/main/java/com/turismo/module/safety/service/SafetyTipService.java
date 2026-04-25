package com.turismo.module.safety.service;

import com.turismo.module.safety.dto.SafetyTipResponse;
import com.turismo.module.safety.dto.SafetyTipUpsertRequest;
import java.util.List;
import java.util.UUID;

public interface SafetyTipService {

    List<SafetyTipResponse> findAll(String city, String zone);

    SafetyTipResponse findById(UUID id);

    SafetyTipResponse create(SafetyTipUpsertRequest request);

    SafetyTipResponse update(UUID id, SafetyTipUpsertRequest request);
}
