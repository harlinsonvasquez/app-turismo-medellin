package com.turismo.module.itinerary.service;

import com.turismo.module.itinerary.dto.ItineraryGenerateRequest;
import com.turismo.module.itinerary.dto.ItineraryResponse;
import com.turismo.module.itinerary.dto.ItinerarySaveRequest;
import java.util.List;
import java.util.UUID;

public interface ItineraryService {

    ItineraryResponse generate(ItineraryGenerateRequest request);

    ItineraryResponse save(ItinerarySaveRequest request);

    List<ItineraryResponse> findMine();

    ItineraryResponse findById(UUID id);
}
