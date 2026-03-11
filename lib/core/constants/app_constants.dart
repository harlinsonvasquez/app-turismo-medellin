class AppConstants {
  // App Info
  static const String appName = 'AppTurismo';
  static const String appSlogan = 'Discover Medellín your way';
  static const String appVersion = '1.0.0';

  // City names
  static const String mainCity = 'Medellín';
  static const String region = 'Antioquia, Colombia';

  // Budget ranges (COP)
  static const int budgetLow = 150000;
  static const int budgetMedium = 350000;
  static const int budgetHigh = 700000;
  static const int budgetLuxury = 1500000;

  // Currency
  static const String currency = 'COP';
  static const String currencySymbol = '\$';

  // Distance units
  static const String distanceUnit = 'km';

  // Default coordinates (Medellín)
  static const double defaultLat = 6.2442;
  static const double defaultLng = -75.5812;

  // Spacing
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 32.0;
  static const double radiusFull = 999.0;

  // Card dimensions
  static const double placeCardWidth = 220.0;
  static const double placeCardHeight = 280.0;
  static const double categoryCardSize = 80.0;
  static const double heroImageHeight = 300.0;

  // Animation durations
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 500);

  // Route names
  static const String routeSplash = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeLocationPermission = '/location-permission';
  static const String routeHome = '/home';
  static const String routeDiscover = '/discover';
  static const String routePlanner = '/planner';
  static const String routeGeneratedPlan = '/generated-plan';
  static const String routeNearby = '/nearby';
  static const String routeSafety = '/safety';
  static const String routeSaved = '/saved';
  static const String routeProfile = '/profile';
  static const String routeBusinessPromo = '/business-promo';
  static const String routePlaceDetail = '/place-detail';
}
