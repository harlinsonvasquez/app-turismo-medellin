import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String preferredLanguage;
  final List<String> interests;
  final String budgetStyle;
  final bool notificationsEnabled;
  final List<String> savedPlaceIds;
  final List<String> savedPlanIds;
  final String role;
  final bool active;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.preferredLanguage,
    required this.interests,
    required this.budgetStyle,
    required this.notificationsEnabled,
    required this.savedPlaceIds,
    required this.savedPlanIds,
    required this.role,
    required this.active,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id']?.toString() ?? '',
        name: json['fullName']?.toString() ?? json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        avatarUrl: null,
        preferredLanguage: 'Espanol',
        interests: const [],
        budgetStyle: 'Moderado',
        notificationsEnabled: true,
        savedPlaceIds: const [],
        savedPlanIds: const [],
        role: json['role']?.toString() ?? 'TOURIST',
        active: json['active'] != false,
      );
}

enum SafetyTipCategory { transport, scam, zones, emergency, general, health }

class SafetyTipModel {
  final String id;
  final String city;
  final String? zone;
  final String title;
  final String description;
  final String icon;
  final SafetyTipCategory category;
  final String riskLevel;

  const SafetyTipModel({
    required this.id,
    required this.city,
    required this.zone,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.riskLevel,
  });

  factory SafetyTipModel.fromJson(Map<String, dynamic> json) {
    final category = _categoryFromText(json['title']?.toString() ?? '', json['description']?.toString() ?? '');
    return SafetyTipModel(
      id: json['id']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      zone: json['zone']?.toString(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      icon: _iconForCategory(category),
      category: category,
      riskLevel: json['riskLevel']?.toString() ?? 'LOW',
    );
  }

  static SafetyTipCategory _categoryFromText(String title, String description) {
    final text = '$title $description'.toLowerCase();
    if (text.contains('emergency') || text.contains('123')) return SafetyTipCategory.emergency;
    if (text.contains('taxi') || text.contains('transport')) return SafetyTipCategory.transport;
    if (text.contains('zone') || text.contains('poblado') || text.contains('centro')) return SafetyTipCategory.zones;
    if (text.contains('scam') || text.contains('estafa')) return SafetyTipCategory.scam;
    return SafetyTipCategory.general;
  }

  static String _iconForCategory(SafetyTipCategory category) => switch (category) {
        SafetyTipCategory.transport => '??',
        SafetyTipCategory.scam => '??',
        SafetyTipCategory.zones => '??',
        SafetyTipCategory.emergency => '??',
        SafetyTipCategory.general => '??',
        SafetyTipCategory.health => '??',
      };
}

class MembershipPlanModel {
  final String id;
  final String name;
  final String price;
  final String billingPeriod;
  final List<String> features;
  final bool isPopular;
  final String badgeColor;

  const MembershipPlanModel({
    required this.id,
    required this.name,
    required this.price,
    required this.billingPeriod,
    required this.features,
    required this.isPopular,
    required this.badgeColor,
  });

  factory MembershipPlanModel.fromJson(Map<String, dynamic> json) {
    final featuresJson = json['featuresJson']?.toString() ?? '[]';
    List<String> features;
    try {
      features = (jsonDecode(featuresJson) as List<dynamic>).map((item) => item.toString()).toList();
    } catch (_) {
      features = const [];
    }
    final name = json['name']?.toString() ?? '';
    return MembershipPlanModel(
      id: json['id']?.toString() ?? '',
      name: name,
      price: '\$${((json['monthlyPrice'] as num?)?.toDouble() ?? 0).round()} COP',
      billingPeriod: 'por mes',
      features: features,
      isPopular: name.toLowerCase() == 'pro',
      badgeColor: name.toLowerCase() == 'premium' ? 'F39C12' : name.toLowerCase() == 'pro' ? '1A5F7A' : '6B7280',
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String routeKey;
  final String colorHex;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.routeKey,
    required this.colorHex,
  });
}

class AuthResponseModel {
  final String accessToken;
  final UserModel user;

  const AuthResponseModel({required this.accessToken, required this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) => AuthResponseModel(
        accessToken: json['accessToken']?.toString() ?? '',
        user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? const {}),
      );
}

class FavoriteModel {
  final String id;
  final String itemType;
  final String referenceId;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final DateTime savedAt;

  const FavoriteModel({
    required this.id,
    required this.itemType,
    required this.referenceId,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    required this.savedAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
        id: json['id']?.toString() ?? '',
        itemType: json['itemType']?.toString() ?? 'PLACE',
        referenceId: json['referenceId']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        subtitle: json['subtitle']?.toString() ?? '',
        imageUrl: json['imageUrl']?.toString(),
        savedAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      );
}
