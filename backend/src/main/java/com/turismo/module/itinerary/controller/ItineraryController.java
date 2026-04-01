package com.turismo.module.itinerary.controller;

import com.turismo.module.itinerary.dto.ItineraryGenerateRequest;
import com.turismo.module.itinerary.dto.ItineraryResponse;
import com.turismo.module.itinerary.dto.ItinerarySaveRequest;
import com.turismo.module.itinerary.service.ItineraryService;
import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/itineraries")
public class ItineraryController {

    private final ItineraryService itineraryService;

    public ItineraryController(ItineraryService itineraryService) {
        this.itineraryService = itineraryService;
    }

    @PostMapping("/generate")
    public ItineraryResponse generate(@Valid @RequestBody ItineraryGenerateRequest request) {
        return itineraryService.generate(request);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ItineraryResponse save(@Valid @RequestBody ItinerarySaveRequest request) {
        return itineraryService.save(request);
    }

    @GetMapping
    public List<ItineraryResponse> findMine() {
        return itineraryService.findMine();
    }

    @GetMapping("/{id}")
    public ItineraryResponse findById(@PathVariable UUID id) {
        return itineraryService.findById(id);
    }
}
