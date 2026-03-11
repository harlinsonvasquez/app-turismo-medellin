import 'place_model.dart';

enum TravelStyle {
  adventure,
  cultural,
  relaxation,
  gastronomy,
  nightlife,
  budget,
  luxury,
}

enum TravelerType {
  solo,
  couple,
  family,
  friends,
  digitalNomad,
}

class ItineraryBlock {
  final String time;
  final String title;
  final String description;
  final String placeId;
  final String placeName;
  final String estimatedCost;
  final String transport;
  final String duration;

  const ItineraryBlock({
    required this.time,
    required this.title,
    required this.description,
    required this.placeId,
    required this.placeName,
    required this.estimatedCost,
    required this.transport,
    required this.duration,
  });
}

class DayPlan {
  final int dayNumber;
  final String theme;
  final String neighborhood;
  final List<ItineraryBlock> morning;
  final List<ItineraryBlock> afternoon;
  final List<ItineraryBlock> night;
  final String dailyBudget;
  final String safetyNote;

  const DayPlan({
    required this.dayNumber,
    required this.theme,
    required this.neighborhood,
    required this.morning,
    required this.afternoon,
    required this.night,
    required this.dailyBudget,
    required this.safetyNote,
  });
}

class TripPlanModel {
  final String id;
  final String title;
  final int days;
  final int totalBudget;
  final TravelStyle style;
  final TravelerType travelerType;
  final List<DayPlan> dayPlans;
  final String estimatedTotal;
  final String transportSummary;
  final List<String> generalNotes;
  final DateTime createdAt;

  const TripPlanModel({
    required this.id,
    required this.title,
    required this.days,
    required this.totalBudget,
    required this.style,
    required this.travelerType,
    required this.dayPlans,
    required this.estimatedTotal,
    required this.transportSummary,
    required this.generalNotes,
    required this.createdAt,
  });
}

class PlanInputModel {
  final int days;
  final int totalBudget;
  final TravelStyle style;
  final TravelerType travelerType;
  final List<String> interests;

  const PlanInputModel({
    required this.days,
    required this.totalBudget,
    required this.style,
    required this.travelerType,
    required this.interests,
  });
}

class SavedItemModel {
  final String id;
  final String type; // 'place' or 'plan'
  final String title;
  final String subtitle;
  final String? imageUrl;
  final DateTime savedAt;
  final PlaceModel? place;
  final TripPlanModel? plan;

  const SavedItemModel({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    required this.savedAt,
    this.place,
    this.plan,
  });
}
