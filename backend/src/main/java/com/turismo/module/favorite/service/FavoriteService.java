package com.turismo.module.favorite.service;

import com.turismo.module.favorite.dto.FavoriteCreateRequest;
import com.turismo.module.favorite.dto.FavoriteResponse;
import java.util.List;
import java.util.UUID;

public interface FavoriteService {

    List<FavoriteResponse> findMine();

    FavoriteResponse create(FavoriteCreateRequest request);

    void delete(UUID id);
}
