package com.turismo.module.business.service;

import com.turismo.module.business.dto.BusinessResponse;
import com.turismo.module.business.dto.BusinessUpsertRequest;
import java.util.List;
import java.util.UUID;

public interface BusinessService {

    List<BusinessResponse> findAll();

    BusinessResponse findById(UUID id);

    List<BusinessResponse> findMine();

    BusinessResponse create(BusinessUpsertRequest request);

    BusinessResponse update(UUID id, BusinessUpsertRequest request);
}
