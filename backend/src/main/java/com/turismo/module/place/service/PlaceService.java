package com.turismo.module.place.service;

import com.turismo.module.place.dto.PlaceFilter;
import com.turismo.module.place.dto.PlaceResponse;
import com.turismo.module.place.dto.PlaceUpsertRequest;
import java.util.List;
import java.util.UUID;

public interface PlaceService {

    List<PlaceResponse> findAll(PlaceFilter filter);

    PlaceResponse findById(UUID id);

    PlaceResponse create(PlaceUpsertRequest request);

    PlaceResponse update(UUID id, PlaceUpsertRequest request);

    void delete(UUID id);
}
