package com.turismo.module.place.controller;

import com.turismo.module.place.dto.PlaceFilter;
import com.turismo.module.place.dto.PlaceResponse;
import com.turismo.module.place.dto.PlaceUpsertRequest;
import com.turismo.module.place.entity.PlaceCategory;
import com.turismo.module.place.service.PlaceService;
import jakarta.validation.Valid;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
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
@RequestMapping("/api/places")
public class PlaceController {

    private final PlaceService placeService;

    public PlaceController(PlaceService placeService) {
        this.placeService = placeService;
    }

    @GetMapping
    public List<PlaceResponse> findAll(
            @RequestParam(required = false) String city,
            @RequestParam(required = false) PlaceCategory category,
            @RequestParam(required = false) String subcategory,
            @RequestParam(required = false) BigDecimal minPrice,
            @RequestParam(required = false) BigDecimal maxPrice,
            @RequestParam(required = false) Boolean safeZone,
            @RequestParam(required = false) Boolean featured,
            @RequestParam(required = false) Boolean active,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) BigDecimal latitude,
            @RequestParam(required = false) BigDecimal longitude,
            @RequestParam(required = false) BigDecimal radiusKm
    ) {
        return placeService.findAll(new PlaceFilter(city, category, subcategory, minPrice, maxPrice, safeZone, featured, active, search, latitude, longitude, radiusKm));
    }

    @GetMapping("/{id}")
    public PlaceResponse findById(@PathVariable UUID id) {
        return placeService.findById(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public PlaceResponse create(@Valid @RequestBody PlaceUpsertRequest request) {
        return placeService.create(request);
    }

    @PutMapping("/{id}")
    public PlaceResponse update(@PathVariable UUID id, @Valid @RequestBody PlaceUpsertRequest request) {
        return placeService.update(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable UUID id) {
        placeService.delete(id);
    }
}
