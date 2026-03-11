import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:app_turismo/core/network/api_client.dart';
import 'package:app_turismo/core/storage/token_storage.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/data/services/auth_service.dart';
import 'package:app_turismo/data/services/event_service.dart';
import 'package:app_turismo/data/services/favorite_service.dart';
import 'package:app_turismo/data/services/itinerary_service.dart';
import 'package:app_turismo/data/services/membership_service.dart';
import 'package:app_turismo/data/services/place_service.dart';
import 'package:app_turismo/data/services/safety_service.dart';
import 'package:app_turismo/presentation/navigation/app_router.dart';
import 'package:app_turismo/presentation/providers/auth_provider.dart';
import 'package:app_turismo/presentation/providers/event_provider.dart';
import 'package:app_turismo/presentation/providers/favorites_provider.dart';
import 'package:app_turismo/presentation/providers/itinerary_provider.dart';
import 'package:app_turismo/presentation/providers/membership_provider.dart';
import 'package:app_turismo/presentation/providers/place_provider.dart';
import 'package:app_turismo/presentation/providers/safety_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final tokenStorage = TokenStorage();
  final apiClient = ApiClient(tokenStorage);

  runApp(AppTurismo(apiClient: apiClient, tokenStorage: tokenStorage));
}

class AppTurismo extends StatelessWidget {
  const AppTurismo({super.key, required this.apiClient, required this.tokenStorage});

  final ApiClient apiClient;
  final TokenStorage tokenStorage;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthService(apiClient), tokenStorage)..bootstrap(),
        ),
        ChangeNotifierProvider(create: (_) => PlaceProvider(PlaceService(apiClient))),
        ChangeNotifierProvider(create: (_) => EventProvider(EventService(apiClient))),
        ChangeNotifierProvider(create: (_) => SafetyProvider(SafetyService(apiClient))),
        ChangeNotifierProvider(create: (_) => MembershipProvider(MembershipService(apiClient))),
        ChangeNotifierProvider(create: (_) => FavoritesProvider(FavoriteService(apiClient))),
        ChangeNotifierProvider(create: (_) => ItineraryProvider(ItineraryService(apiClient))),
      ],
      child: MaterialApp.router(
        title: 'AppTurismo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
