package com.turismo.module.event.controller;

import com.turismo.module.event.dto.EventFilter;
import com.turismo.module.event.dto.EventResponse;
import com.turismo.module.event.dto.EventUpsertRequest;
import com.turismo.module.event.entity.EventCategory;
import com.turismo.module.event.service.EventService;
import jakarta.validation.Valid;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/events")
public class EventController {

    private final EventService eventService;

    public EventController(EventService eventService) {
        this.eventService = eventService;
    }

    @GetMapping
    public List<EventResponse> findAll(
            @RequestParam(required = false) String city,
            @RequestParam(required = false) EventCategory category,
            @RequestParam(required = false) Boolean featured,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime startDateFrom,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime startDateTo,
            @RequestParam(required = false) BigDecimal minPrice,
            @RequestParam(required = false) BigDecimal maxPrice,
            @RequestParam(required = false) Boolean active
    ) {
        return eventService.findAll(new EventFilter(city, category, featured, startDateFrom, startDateTo, minPrice, maxPrice, active));
    }

    @GetMapping("/{id}")
    public EventResponse findById(@PathVariable UUID id) {
        return eventService.findById(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public EventResponse create(@Valid @RequestBody EventUpsertRequest request) {
        return eventService.create(request);
    }

    @PutMapping("/{id}")
    public EventResponse update(@PathVariable UUID id, @Valid @RequestBody EventUpsertRequest request) {
        return eventService.update(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable UUID id) {
        eventService.delete(id);
    }
}
