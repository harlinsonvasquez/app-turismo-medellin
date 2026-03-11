import '../data/models/event_model.dart';
import '../data/models/place_model.dart';
import '../data/models/user_model.dart';

class AppCatalog {
  static const categories = [
    CategoryModel(id: 'c001', name: 'Hoteles', icon: '??', routeKey: 'hotel', colorHex: '1A5F7A'),
    CategoryModel(id: 'c002', name: 'Restaurantes', icon: '???', routeKey: 'restaurant', colorHex: '2ECC71'),
    CategoryModel(id: 'c003', name: 'Turismo', icon: '???', routeKey: 'tourist', colorHex: 'F39C12'),
    CategoryModel(id: 'c004', name: 'Eventos', icon: '??', routeKey: 'events', colorHex: '9B59B6'),
    CategoryModel(id: 'c005', name: 'Vida Nocturna', icon: '??', routeKey: 'nightlife', colorHex: '1A1D2E'),
    CategoryModel(id: 'c006', name: 'Pueblos', icon: '??', routeKey: 'towns', colorHex: 'E67E22'),
  ];

  static PlaceCategory? mapPlaceCategoryLabel(String label) {
    switch (label) {
      case 'Hoteles':
        return PlaceCategory.hotel;
      case 'Restaurantes':
        return PlaceCategory.restaurant;
      case 'Turismo':
        return PlaceCategory.touristPlace;
      case 'Vida Nocturna':
        return PlaceCategory.nightlife;
      case 'Pueblos':
        return PlaceCategory.town;
      case 'Experiencias':
        return PlaceCategory.experience;
      default:
        return null;
    }
  }

  static String? placeCategoryToApi(PlaceCategory? category) {
    switch (category) {
      case PlaceCategory.hotel:
        return 'HOTEL';
      case PlaceCategory.restaurant:
        return 'RESTAURANT';
      case PlaceCategory.touristPlace:
        return 'TOURIST_PLACE';
      case PlaceCategory.event:
        return 'EVENT';
      case PlaceCategory.nightlife:
        return 'NIGHTLIFE';
      case PlaceCategory.town:
        return 'TOWN';
      case PlaceCategory.experience:
        return 'EXPERIENCE';
      case PlaceCategory.transport:
        return 'TRANSPORT';
      case null:
        return null;
    }
  }

  static EventCategory? mapEventCategoryLabel(String label) {
    if (label == 'Eventos') return EventCategory.cultural;
    return null;
  }
}
