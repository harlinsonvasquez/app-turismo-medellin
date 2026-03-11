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

enum SafetyLevel { safe, caution, avoid }

enum BudgetLevel { budget, moderate, upscale, luxury }

class PlaceImageModel {
  final String id;
  final String imageUrl;
  final bool cover;
  final int sortOrder;

  const PlaceImageModel({
    required this.id,
    required this.imageUrl,
    required this.cover,
    required this.sortOrder,
  });

  factory PlaceImageModel.fromJson(Map<String, dynamic> json) => PlaceImageModel(
        id: json['id']?.toString() ?? '',
        imageUrl: json['imageUrl']?.toString() ?? '',
        cover: json['cover'] == true,
        sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      );
}

class PlaceModel {
  final String id;
  final String? businessId;
  final String? businessName;
  final String name;
  final String slug;
  final PlaceCategory category;
  final String? subcategory;
  final String description;
  final double rating;
  final int reviewCount;
  final String priceRange;
  final int pricePerPerson;
  final double distanceKm;
  final String address;
  final String neighborhood;
  final String city;
  final String department;
  final String openingHours;
  final bool isOpenNow;
  final SafetyLevel safetyLevel;
  final BudgetLevel budgetLevel;
  final List<String> tags;
  final List<String> imageUrls;
  final List<PlaceImageModel> images;
  final double latitude;
  final double longitude;
  final String? safetyNote;
  final bool isFeatured;
  final bool isPopular;
  final bool isActive;

  const PlaceModel({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.name,
    required this.slug,
    required this.category,
    required this.subcategory,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.priceRange,
    required this.pricePerPerson,
    required this.distanceKm,
    required this.address,
    required this.neighborhood,
    required this.city,
    required this.department,
    required this.openingHours,
    required this.isOpenNow,
    required this.safetyLevel,
    required this.budgetLevel,
    required this.tags,
    required this.imageUrls,
    required this.images,
    required this.latitude,
    required this.longitude,
    this.safetyNote,
    this.isFeatured = false,
    this.isPopular = false,
    this.isActive = true,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    final images = ((json['images'] as List<dynamic>?) ?? const [])
        .map((item) => PlaceImageModel.fromJson(item as Map<String, dynamic>))
        .toList();
    final category = _mapCategory(json['category']?.toString());
    final budgetLevel = _mapBudget(json['estimatedPriceLevel']?.toString());
    final safe = json['safeZone'] == true;
    final description = json['description']?.toString() ?? '';
    final subcategory = json['subcategory']?.toString();
    final tags = <String>{
      if (subcategory != null && subcategory.isNotEmpty) subcategory,
      ...description
          .split(RegExp(r'[,\.]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .take(4),
    }.toList();

    return PlaceModel(
      id: json['id']?.toString() ?? '',
      businessId: json['businessId']?.toString(),
      businessName: json['businessName']?.toString(),
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      category: category,
      subcategory: subcategory,
      description: description,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: 0,
      priceRange: _priceRangeFromBudget(budgetLevel),
      pricePerPerson: ((json['averagePrice'] as num?)?.toDouble() ?? 0).round(),
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0,
      address: json['address']?.toString() ?? '',
      neighborhood: _extractNeighborhood(json['address']?.toString() ?? ''),
      city: json['city']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      openingHours: json['openingHoursJson']?.toString() ?? 'Horario por confirmar',
      isOpenNow: (json['openingHoursJson']?.toString() ?? '').isNotEmpty,
      safetyLevel: safe ? SafetyLevel.safe : SafetyLevel.caution,
      budgetLevel: budgetLevel,
      tags: tags,
      imageUrls: images.map((e) => e.imageUrl).toList(),
      images: images,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      safetyNote: safe ? 'Zona considerada segura para turistas.' : 'Manten precaucion con tus pertenencias.',
      isFeatured: json['featured'] == true,
      isPopular: json['featured'] == true || ((json['rating'] as num?)?.toDouble() ?? 0) >= 4.5,
      isActive: json['active'] != false,
    );
  }

  String get categoryLabel {
    switch (category) {
      case PlaceCategory.hotel:
        return 'Hotel';
      case PlaceCategory.restaurant:
        return 'Restaurante';
      case PlaceCategory.touristPlace:
        return 'Lugar Turistico';
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
        return 'Precaucion';
      case SafetyLevel.avoid:
        return 'Evitar';
    }
  }

  String get budgetLabel {
    switch (budgetLevel) {
      case BudgetLevel.budget:
        return 'Economico';
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

  static PlaceCategory _mapCategory(String? raw) {
    switch (raw) {
      case 'HOTEL':
        return PlaceCategory.hotel;
      case 'RESTAURANT':
        return PlaceCategory.restaurant;
      case 'EVENT':
        return PlaceCategory.event;
      case 'NIGHTLIFE':
        return PlaceCategory.nightlife;
      case 'TOWN':
        return PlaceCategory.town;
      case 'EXPERIENCE':
        return PlaceCategory.experience;
      case 'TRANSPORT':
        return PlaceCategory.transport;
      case 'TOURIST_PLACE':
      default:
        return PlaceCategory.touristPlace;
    }
  }

  static BudgetLevel _mapBudget(String? raw) {
    switch (raw) {
      case 'LOW':
        return BudgetLevel.budget;
      case 'MEDIUM':
        return BudgetLevel.moderate;
      case 'HIGH':
        return BudgetLevel.upscale;
      default:
        return BudgetLevel.moderate;
    }
  }

  static String _priceRangeFromBudget(BudgetLevel level) {
    switch (level) {
      case BudgetLevel.budget:
        return '\$';
      case BudgetLevel.moderate:
        return '\$\$';
      case BudgetLevel.upscale:
        return '\$\$\$';
      case BudgetLevel.luxury:
        return '\$\$\$\$';
    }
  }

  static String _extractNeighborhood(String address) {
    final parts = address.split(',');
    return parts.length > 1 ? parts.last.trim() : address;
  }
}
