enum PlaceCategory {
  hotel,
  restaurant,
  touristPlace,
  event,
  nightlife,
  town,
  experience,
  transport,
}

enum SafetyLevel {
  safe,
  caution,
  avoid,
}

enum BudgetLevel {
  budget,
  moderate,
  upscale,
  luxury,
}

class PlaceModel {
  final String id;
  final String name;
  final PlaceCategory category;
  final String description;
  final double rating;
  final int reviewCount;
  final String priceRange;
  final int pricePerPerson; // COP
  final double distanceKm;
  final String address;
  final String neighborhood;
  final String city;
  final String openingHours;
  final bool isOpenNow;
  final SafetyLevel safetyLevel;
  final BudgetLevel budgetLevel;
  final List<String> tags;
  final List<String> imageUrls;
  final double latitude;
  final double longitude;
  final String? safetyNote;
  final bool isFeatured;
  final bool isPopular;

  const PlaceModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.priceRange,
    required this.pricePerPerson,
    required this.distanceKm,
    required this.address,
    required this.neighborhood,
    required this.city,
    required this.openingHours,
    required this.isOpenNow,
    required this.safetyLevel,
    required this.budgetLevel,
    required this.tags,
    required this.imageUrls,
    required this.latitude,
    required this.longitude,
    this.safetyNote,
    this.isFeatured = false,
    this.isPopular = false,
  });

  String get categoryLabel {
    switch (category) {
      case PlaceCategory.hotel:
        return 'Hotel';
      case PlaceCategory.restaurant:
        return 'Restaurante';
      case PlaceCategory.touristPlace:
        return 'Lugar Turístico';
      case PlaceCategory.event:
        return 'Evento';
      case PlaceCategory.nightlife:
        return 'Vida Nocturna';
      case PlaceCategory.town:
        return 'Pueblo';
      case PlaceCategory.experience:
        return 'Experiencia';
      case PlaceCategory.transport:
        return 'Transporte';
    }
  }

  String get safetyLabel {
    switch (safetyLevel) {
      case SafetyLevel.safe:
        return 'Zona Segura';
      case SafetyLevel.caution:
        return 'Precaución';
      case SafetyLevel.avoid:
        return 'Evitar';
    }
  }

  String get budgetLabel {
    switch (budgetLevel) {
      case BudgetLevel.budget:
        return 'Económico';
      case BudgetLevel.moderate:
        return 'Moderado';
      case BudgetLevel.upscale:
        return 'Premium';
      case BudgetLevel.luxury:
        return 'Lujo';
    }
  }

  String get formattedPrice {
    if (pricePerPerson >= 1000000) {
      return '\$${(pricePerPerson / 1000000).toStringAsFixed(1)}M COP';
    } else if (pricePerPerson >= 1000) {
      return '\$${(pricePerPerson / 1000).toStringAsFixed(0)}K COP';
    }
    return '\$$pricePerPerson COP';
  }
}
