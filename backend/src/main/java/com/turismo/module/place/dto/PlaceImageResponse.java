package com.turismo.module.place.dto;

import java.util.UUID;

public record PlaceImageResponse(UUID id, String imageUrl, boolean cover, Integer sortOrder) {
}
