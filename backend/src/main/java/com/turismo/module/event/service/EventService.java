package com.turismo.module.event.service;

import com.turismo.module.event.dto.EventFilter;
import com.turismo.module.event.dto.EventResponse;
import com.turismo.module.event.dto.EventUpsertRequest;
import java.util.List;
import java.util.UUID;

public interface EventService {

    List<EventResponse> findAll(EventFilter filter);

    EventResponse findById(UUID id);

    EventResponse create(EventUpsertRequest request);

    EventResponse update(UUID id, EventUpsertRequest request);

    void delete(UUID id);
}
