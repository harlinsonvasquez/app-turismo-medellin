import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/presentation/providers/auth_provider.dart';
import 'package:app_turismo/presentation/providers/event_provider.dart';
import 'package:app_turismo/presentation/providers/place_provider.dart';
import 'package:app_turismo/presentation/providers/safety_provider.dart';
import 'package:app_turismo/presentation/widgets/common_widgets.dart';
import 'package:app_turismo/presentation/widgets/event_card.dart';
import 'package:app_turismo/presentation/widgets/place_card.dart';
import 'package:app_turismo/presentation/widgets/specialized_widgets.dart';
import 'package:app_turismo/shared/app_catalog.dart';

/// Pantalla principal del turista.
/// Combina lugares, eventos y consejos de seguridad consumidos desde el
/// backend para construir el inicio de la experiencia.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<PlaceProvider>()
          .cargarLugares(filtros: {'city': 'Medellin'});
      context
          .read<EventProvider>()
          .cargarEventos(filtros: {'city': 'Medellin', 'featured': true});
      context.read<SafetyProvider>().cargarConsejos(city: 'Medellin');
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final placeProvider = context.watch<PlaceProvider>();
    final eventProvider = context.watch<EventProvider>();
    final safetyProvider = context.watch<SafetyProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await context
              .read<PlaceProvider>()
              .cargarLugares(filtros: {'city': 'Medellin'});
          await context
              .read<EventProvider>()
              .cargarEventos(filtros: {'city': 'Medellin', 'featured': true});
          await context.read<SafetyProvider>().cargarConsejos(city: 'Medellin');
        },
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context, auth),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  AppSearchBar(
                      onTap: () => context.go(AppConstants.routeDiscover)),
                  const SizedBox(height: 20),
                  _buildLocationCard(),
                  const SizedBox(height: 24),
                  const SectionHeader(
                      title: 'Explorar por categoria',
                      subtitle: 'Medellin y Antioquia'),
                  const SizedBox(height: 12),
                  _buildCategories(context),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'Experiencias destacadas',
                    actionLabel: 'Ver todo',
                    onAction: () => context.go(AppConstants.routeDiscover),
                  ),
                  const SizedBox(height: 12),
                  if (placeProvider.isLoading)
                    const SizedBox(
                        height: 260,
                        child: Center(child: CircularProgressIndicator()))
                  else
                    _buildFeaturedCarousel(context, placeProvider),
                  const SizedBox(height: 24),
                  if (safetyProvider.tips.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingM),
                      child: SafetyTipBanner(
                          tip: safetyProvider.tips.first, compact: false),
                    ),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'Eventos destacados',
                    subtitle: 'Agenda local real',
                    actionLabel: 'Explorar',
                    onAction: () => context.go(AppConstants.routeDiscover),
                  ),
                  const SizedBox(height: 12),
                  _buildEvents(eventProvider),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'Planes por presupuesto',
                    subtitle: 'Escoge tu viaje ideal',
                    actionLabel: 'Crear plan',
                    onAction: () => context.go(AppConstants.routePlanner),
                  ),
                  const SizedBox(height: 12),
                  _buildBudgetPlans(context),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'Popular esta semana',
                    actionLabel: 'Ver todo',
                    onAction: () => context.go(AppConstants.routeDiscover),
                  ),
                  const SizedBox(height: 12),
                  _buildPopularList(context, placeProvider),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'Cerca de ti',
                    subtitle: 'El Poblado, Medellin',
                    actionLabel: 'Ver mapa',
                    onAction: () => context.go(AppConstants.routeNearby),
                  ),
                  const SizedBox(height: 12),
                  _buildNearby(context, placeProvider),
                  if (placeProvider.error != null)
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingM),
                      child: Text(placeProvider.error!,
                          style: const TextStyle(color: AppColors.error)),
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, AuthProvider auth) {
    final userName = auth.user?.name.split(' ').first ?? 'viajero';
    return SliverAppBar(
      expandedHeight: 140, // Incrementado para evitar el overflow del encabezado
      floating: true,
      snap: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () => context.go(AppConstants.routeSaved),
          icon: const Icon(Icons.bookmark_outline_rounded, color: Colors.white),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 12),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.background],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Hola, $userName',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      auth.isAuthenticated
                          ? 'Tu viaje ahora usa datos reales'
                          : 'Explora Medellin con backend en vivo',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => context.go(AppConstants.routeProfile),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Center(
                      child: Text('??', style: TextStyle(fontSize: 22))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child:
                const Center(child: Text('??', style: TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Base local configurada',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w500)),
                SizedBox(height: 2),
                Text('Medellin, Antioquia',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.safeZone.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            ),
            child: const Text('Backend activo',
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.safeZone,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
        itemCount: AppCatalog.categories.length,
        itemBuilder: (_, i) {
          final cat = AppCatalog.categories[i];
          return GestureDetector(
            onTap: () => context.go(AppConstants.routeDiscover),
            child: SizedBox(
              width: 76,
              child: Column(
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Color(int.parse('FF${cat.colorHex}', radix: 16))
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    ),
                    child: Center(
                        child: Text(cat.icon,
                            style: const TextStyle(fontSize: 28))),
                  ),
                  const SizedBox(height: 6),
                  Text(cat.name,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedCarousel(
      BuildContext context, PlaceProvider placeProvider) {
    final places = placeProvider.featuredPlaces.isNotEmpty
        ? placeProvider.featuredPlaces
        : placeProvider.places.take(5).toList();
    return SizedBox(
      height: AppConstants.placeCardHeight + 10, // Se añade un ligero offset contra overflows
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
        itemCount: places.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.only(right: 14),
          child: PlaceCard(
              place: places[i],
              onTap: () => context
                  .go('${AppConstants.routePlaceDetail}?id=${places[i].id}')),
        ),
      ),
    );
  }

  Widget _buildEvents(EventProvider eventProvider) {
    if (eventProvider.isLoading) {
      return const SizedBox(
          height: 180, child: Center(child: CircularProgressIndicator()));
    }
    if (eventProvider.events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
        child: Text('No hay eventos cargados por ahora.',
            style: TextStyle(color: AppColors.textTertiary)),
      );
    }
    return SizedBox(
      height: 200, // Altura base incrementada para compensar flex logs
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
        itemCount: eventProvider.events.length,
        itemBuilder: (_, index) => Padding(
          padding: const EdgeInsets.only(right: 14),
          child: EventCard(event: eventProvider.events[index]),
        ),
      ),
    );
  }

  Widget _buildBudgetPlans(BuildContext context) {
    return SizedBox(
      height: 180, // Incrementado vs 170 original para evitar escapes
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
        children: [
          SizedBox(
              width: 280,
              child: BudgetPlanCard(
                  emoji: '??',
                  title: 'Mochilero Paisa',
                  budget: '\$250.000',
                  days: '3',
                  description: 'Lo mejor de Medellin con presupuesto viajero.',
                  onTap: () => context.go(AppConstants.routePlanner))),
          const SizedBox(width: 14),
          SizedBox(
              width: 280,
              child: BudgetPlanCard(
                  emoji: '??',
                  title: 'Escapada Romantica',
                  budget: '\$800.000',
                  days: '2',
                  description: 'Experiencias premium para pareja.',
                  onTap: () => context.go(AppConstants.routePlanner))),
          const SizedBox(width: 14),
          SizedBox(
              width: 280,
              child: BudgetPlanCard(
                  emoji: '???????????',
                  title: 'Plan Familiar',
                  budget: '\$600.000',
                  days: '4',
                  description: 'Actividades para toda la familia.',
                  onTap: () => context.go(AppConstants.routePlanner))),
        ],
      ),
    );
  }

  Widget _buildPopularList(BuildContext context, PlaceProvider placeProvider) {
    final places = placeProvider.places.take(3).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      child: Column(
        children: places
            .map((place) => PlaceCard(
                place: place,
                isHorizontal: true,
                onTap: () => context
                    .go('${AppConstants.routePlaceDetail}?id=${place.id}')))
            .toList(),
      ),
    );
  }

  Widget _buildNearby(BuildContext context, PlaceProvider placeProvider) {
    final places = placeProvider.nearbyPlaces.isNotEmpty
        ? placeProvider.nearbyPlaces
        : placeProvider.places.take(3).toList();
    return SizedBox(
      height: AppConstants.placeCardHeight + 10, // Más amplio
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
        itemCount: places.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.only(right: 14),
          child: PlaceCard(
              place: places[i],
              onTap: () => context
                  .go('${AppConstants.routePlaceDetail}?id=${places[i].id}')),
        ),
      ),
    );
  }
}
