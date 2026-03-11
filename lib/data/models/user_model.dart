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
  });
}

class SafetyTipModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final SafetyTipCategory category;

  const SafetyTipModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
  });
}

enum SafetyTipCategory {
  transport,
  scam,
  zones,
  emergency,
  general,
  health,
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
