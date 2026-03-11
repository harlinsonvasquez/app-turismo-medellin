import 'place_model.dart';

enum TravelStyle { adventure, cultural, relaxation, gastronomy, nightlife, budget, luxury }

enum TravelerType { solo, couple, family, friends, digitalNomad }

enum ItineraryPeriod { morning, afternoon, night }

enum ItineraryItemType { place, event, hotel, restaurant, transportNote, safetyNote }

class ItineraryBlock {
  final String id;
  final int dayNumber;
  final ItineraryPeriod period;
  final ItineraryItemType itemType;
  final String? referenceId;
  final String title;
  final String description;
  final String estimatedCost;
  final int sortOrder;

  const ItineraryBlock({
    required this.id,
    required this.dayNumber,
    required this.period,
    required this.itemType,
    this.referenceId,
    required this.title,
    required this.description,
    required this.estimatedCost,
    required this.sortOrder,
  });

  factory ItineraryBlock.fromJson(Map<String, dynamic> json) => ItineraryBlock(
        id: json['id']?.toString() ?? '',
        dayNumber: (json['dayNumber'] as num?)?.toInt() ?? 1,
        period: _mapPeriod(json['period']?.toString()),
        itemType: _mapItemType(json['itemType']?.toString()),
        referenceId: json['referenceId']?.toString(),
        title: json['title']?.toString() ?? '',
        description: json['title']?.toString() ?? '',
        estimatedCost: _formatMoney((json['estimatedCost'] as num?)?.toDouble()),
        sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'dayNumber': dayNumber,
        'period': _periodToApi(period),
        'itemType': _itemTypeToApi(itemType),
        'referenceId': referenceId,
        'title': title,
        'estimatedCost': _parseMoney(estimatedCost),
        'sortOrder': sortOrder,
      };

  static ItineraryPeriod _mapPeriod(String? raw) {
    switch (raw) {
      case 'AFTERNOON':
        return ItineraryPeriod.afternoon;
      case 'NIGHT':
        return ItineraryPeriod.night;
      case 'MORNING':
      default:
        return ItineraryPeriod.morning;
    }
  }

  static ItineraryItemType _mapItemType(String? raw) {
    switch (raw) {
      case 'EVENT':
        return ItineraryItemType.event;
      case 'HOTEL':
        return ItineraryItemType.hotel;
      case 'RESTAURANT':
        return ItineraryItemType.restaurant;
      case 'TRANSPORT_NOTE':
        return ItineraryItemType.transportNote;
      case 'SAFETY_NOTE':
        return ItineraryItemType.safetyNote;
      case 'PLACE':
      default:
        return ItineraryItemType.place;
    }
  }

  static String _periodToApi(ItineraryPeriod period) => switch (period) {
        ItineraryPeriod.morning => 'MORNING',
        ItineraryPeriod.afternoon => 'AFTERNOON',
        ItineraryPeriod.night => 'NIGHT',
      };

  static String _itemTypeToApi(ItineraryItemType type) => switch (type) {
        ItineraryItemType.place => 'PLACE',
        ItineraryItemType.event => 'EVENT',
        ItineraryItemType.hotel => 'HOTEL',
        ItineraryItemType.restaurant => 'RESTAURANT',
        ItineraryItemType.transportNote => 'TRANSPORT_NOTE',
        ItineraryItemType.safetyNote => 'SAFETY_NOTE',
      };

  static String _formatMoney(double? value) {
    if (value == null || value == 0) return 'Incluido';
    return '\$${value.round()} COP';
  }

  static num _parseMoney(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    return num.tryParse(cleaned) ?? 0;
  }
}

class DayPlan {
  final int dayNumber;
  final List<ItineraryBlock> morning;
  final List<ItineraryBlock> afternoon;
  final List<ItineraryBlock> night;

  const DayPlan({
    required this.dayNumber,
    required this.morning,
    required this.afternoon,
    required this.night,
  });

  String get theme {
    final all = [...morning, ...afternoon, ...night];
    return all.isEmpty ? 'Plan del dia' : all.first.title;
  }

  String get neighborhood => 'Medellin';

  String get dailyBudget {
    final total = [...morning, ...afternoon, ...night].fold<num>(0, (sum, item) {
      final cleaned = item.estimatedCost.replaceAll(RegExp(r'[^0-9]'), '');
      return sum + (num.tryParse(cleaned) ?? 0);
    });
    return total == 0 ? 'Incluido' : '\$${total.round()} COP';
  }

  String get safetyNote {
    final safety = night.where((item) => item.itemType == ItineraryItemType.safetyNote);
    if (safety.isNotEmpty) return safety.first.title;
    return 'Mantente en zonas concurridas y usa transporte verificado.';
  }
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
  final DateTime? createdAt;
  final bool generated;

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
    required this.generated,
  });

  factory TripPlanModel.fromJson(Map<String, dynamic> json) {
    final items = ((json['items'] as List<dynamic>?) ?? const [])
        .map((item) => ItineraryBlock.fromJson(item as Map<String, dynamic>))
        .toList()
      ..sort((a, b) {
        final day = a.dayNumber.compareTo(b.dayNumber);
        if (day != 0) return day;
        return a.sortOrder.compareTo(b.sortOrder);
      });

    final groupedDays = <int, List<ItineraryBlock>>{};
    for (final item in items) {
      groupedDays.putIfAbsent(item.dayNumber, () => []).add(item);
    }

    final dayPlans = groupedDays.entries.map((entry) {
      final blocks = entry.value;
      return DayPlan(
        dayNumber: entry.key,
        morning: blocks.where((e) => e.period == ItineraryPeriod.morning).toList(),
        afternoon: blocks.where((e) => e.period == ItineraryPeriod.afternoon).toList(),
        night: blocks.where((e) => e.period == ItineraryPeriod.night).toList(),
      );
    }).toList()
      ..sort((a, b) => a.dayNumber.compareTo(b.dayNumber));

    final interests = ((json['interests'] as List<dynamic>?) ?? const []).map((e) => e.toString()).toList();

    return TripPlanModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Itinerario personalizado',
      days: (json['totalDays'] as num?)?.toInt() ?? dayPlans.length,
      totalBudget: ((json['totalBudget'] as num?)?.toDouble() ?? 0).round(),
      style: _mapStyle(json['travelStyle']?.toString()),
      travelerType: _mapTraveler(json['companionType']?.toString()),
      dayPlans: dayPlans,
      estimatedTotal: '\$${((json['totalBudget'] as num?)?.toDouble() ?? 0).round()} COP',
      transportSummary: 'Metro, apps de transporte y recorridos a pie',
      generalNotes: [
        if ((json['notes']?.toString() ?? '').isNotEmpty) json['notes'].toString(),
        ...interests.map((interest) => 'Interes: $interest'),
      ],
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      generated: json['generated'] == true,
    );
  }

  Map<String, dynamic> toSaveRequest() => {
        'title': title,
        'cityBase': 'Medellin',
        'totalDays': days,
        'totalBudget': totalBudget,
        'travelStyle': _styleToApi(style),
        'companionType': _travelerToApi(travelerType),
        'interests': generalNotes
            .where((note) => note.startsWith('Interes: '))
            .map((note) => note.replaceFirst('Interes: ', ''))
            .toList(),
        'notes': generalNotes.where((note) => !note.startsWith('Interes: ')).join('\n'),
        'items': dayPlans
            .expand((day) => [...day.morning, ...day.afternoon, ...day.night])
            .map((item) => item.toJson())
            .toList(),
      };

  static TravelStyle _mapStyle(String? raw) {
    switch (raw) {
      case 'ADVENTURE':
        return TravelStyle.adventure;
      case 'RELAXATION':
        return TravelStyle.relaxation;
      case 'GASTRONOMY':
        return TravelStyle.gastronomy;
      case 'NIGHTLIFE':
        return TravelStyle.nightlife;
      case 'BUDGET':
        return TravelStyle.budget;
      case 'LUXURY':
        return TravelStyle.luxury;
      case 'CULTURAL':
      default:
        return TravelStyle.cultural;
    }
  }

  static TravelerType _mapTraveler(String? raw) {
    switch (raw) {
      case 'SOLO':
        return TravelerType.solo;
      case 'FAMILY':
        return TravelerType.family;
      case 'FRIENDS':
        return TravelerType.friends;
      case 'DIGITAL_NOMAD':
        return TravelerType.digitalNomad;
      case 'COUPLE':
      default:
        return TravelerType.couple;
    }
  }

  static String _styleToApi(TravelStyle style) => switch (style) {
        TravelStyle.adventure => 'ADVENTURE',
        TravelStyle.cultural => 'CULTURAL',
        TravelStyle.relaxation => 'RELAXATION',
        TravelStyle.gastronomy => 'GASTRONOMY',
        TravelStyle.nightlife => 'NIGHTLIFE',
        TravelStyle.budget => 'BUDGET',
        TravelStyle.luxury => 'LUXURY',
      };

  static String _travelerToApi(TravelerType type) => switch (type) {
        TravelerType.solo => 'SOLO',
        TravelerType.couple => 'COUPLE',
        TravelerType.family => 'FAMILY',
        TravelerType.friends => 'FRIENDS',
        TravelerType.digitalNomad => 'DIGITAL_NOMAD',
      };
}

class PlanInputModel {
  final String city;
  final int days;
  final int totalBudget;
  final TravelStyle style;
  final TravelerType travelerType;
  final List<String> interests;
  final bool safeZoneOnly;

  const PlanInputModel({
    required this.city,
    required this.days,
    required this.totalBudget,
    required this.style,
    required this.travelerType,
    required this.interests,
    this.safeZoneOnly = true,
  });

  Map<String, dynamic> toJson() => {
        'city': city,
        'totalDays': days,
        'totalBudget': totalBudget,
        'travelStyle': TripPlanModel._styleToApi(style),
        'companionType': TripPlanModel._travelerToApi(travelerType),
        'interests': interests,
        'safeZoneOnly': safeZoneOnly,
      };
}

class SavedItemModel {
  final String id;
  final String type;
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
