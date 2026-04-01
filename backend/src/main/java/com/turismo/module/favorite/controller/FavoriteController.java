package com.turismo.module.favorite.controller;

import com.turismo.module.favorite.dto.FavoriteCreateRequest;
import com.turismo.module.favorite.dto.FavoriteResponse;
import com.turismo.module.favorite.service.FavoriteService;
import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/favorites")
public class FavoriteController {

    private final FavoriteService favoriteService;

    public FavoriteController(FavoriteService favoriteService) {
        this.favoriteService = favoriteService;
    }

    @GetMapping
    public List<FavoriteResponse> findMine() {
        return favoriteService.findMine();
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public FavoriteResponse create(@Valid @RequestBody FavoriteCreateRequest request) {
        return favoriteService.create(request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable UUID id) {
        favoriteService.delete(id);
    }
}
