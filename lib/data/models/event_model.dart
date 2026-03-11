enum EventCategory {
  concert,
  festival,
  cultural,
  gastronomic,
  nightlife,
  sports,
  business,
  other,
}

class EventModel {
  final String id;
  final String? businessId;
  final String? businessName;
  final String title;
  final String slug;
  final String description;
  final EventCategory category;
  final String city;
  final String department;
  final String address;
  final double latitude;
  final double longitude;
  final DateTime startDate;
  final DateTime? endDate;
  final int averagePrice;
  final bool featured;
  final bool active;

  const EventModel({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.title,
    required this.slug,
    required this.description,
    required this.category,
    required this.city,
    required this.department,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.startDate,
    this.endDate,
    required this.averagePrice,
    required this.featured,
    required this.active,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json['id']?.toString() ?? '',
        businessId: json['businessId']?.toString(),
        businessName: json['businessName']?.toString(),
        title: json['title']?.toString() ?? '',
        slug: json['slug']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        category: _mapCategory(json['category']?.toString()),
        city: json['city']?.toString() ?? '',
        department: json['department']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
        startDate: DateTime.tryParse(json['startDate']?.toString() ?? '') ?? DateTime.now(),
        endDate: DateTime.tryParse(json['endDate']?.toString() ?? ''),
        averagePrice: ((json['averagePrice'] as num?)?.toDouble() ?? 0).round(),
        featured: json['featured'] == true,
        active: json['active'] != false,
      );

  String get categoryLabel => switch (category) {
        EventCategory.concert => 'Concierto',
        EventCategory.festival => 'Festival',
        EventCategory.cultural => 'Cultural',
        EventCategory.gastronomic => 'Gastronomico',
        EventCategory.nightlife => 'Nocturno',
        EventCategory.sports => 'Deportes',
        EventCategory.business => 'Negocios',
        EventCategory.other => 'Otro',
      };

  static EventCategory _mapCategory(String? raw) {
    switch (raw) {
      case 'CONCERT':
        return EventCategory.concert;
      case 'FESTIVAL':
        return EventCategory.festival;
      case 'GASTRONOMIC':
        return EventCategory.gastronomic;
      case 'NIGHTLIFE':
        return EventCategory.nightlife;
      case 'SPORTS':
        return EventCategory.sports;
      case 'BUSINESS':
        return EventCategory.business;
      case 'CULTURAL':
      default:
        return EventCategory.cultural;
    }
  }
}
