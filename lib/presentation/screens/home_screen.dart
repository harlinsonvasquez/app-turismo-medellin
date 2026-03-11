import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/data/mock/mock_places.dart';
import 'package:app_turismo/data/mock/mock_data.dart';
import 'package:app_turismo/data/models/place_model.dart';
import 'package:app_turismo/data/models/user_model.dart';
import 'package:app_turismo/presentation/widgets/place_card.dart';
import 'package:app_turismo/presentation/widgets/common_widgets.dart';
import 'package:app_turismo/presentation/widgets/specialized_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Search bar
                const AppSearchBar(),
                const SizedBox(height: 20),
                // Location card
                _buildLocationCard(context),
                const SizedBox(height: 24),
                // Categories
                SectionHeader(
                  title: 'Explorar por categoría',
                  subtitle: 'Medellín y Antioquia',
                ),
                const SizedBox(height: 12),
                _buildCategories(context),
                const SizedBox(height: 24),
                // Featured experiences
                SectionHeader(
                  title: 'Experiencias destacadas',
                  actionLabel: 'Ver todo',
                  onAction: () {},
                ),
                const SizedBox(height: 12),
                _buildFeaturedCarousel(context),
                const SizedBox(height: 24),
                // Safety tip banner
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingM),
                  child: SafetyTipBanner(
                    tip: MockSafetyTips.all.first,
                    compact: false,
                  ),
                ),
                const SizedBox(height: 24),
                // Plans by budget
                SectionHeader(
                  title: 'Planes por presupuesto',
                  subtitle: 'Escoge tu viaje ideal',
                  actionLabel: 'Crear plan',
                  onAction: () => context.go(AppConstants.routePlanner),
                ),
                const SizedBox(height: 12),
                _buildBudgetPlans(context),
                const SizedBox(height: 24),
                // Popular this week
                SectionHeader(
                  title: '🔥 Popular esta semana',
                  actionLabel: 'Ver todo',
                  onAction: () {},
                ),
                const SizedBox(height: 12),
                _buildPopularList(context),
                const SizedBox(height: 24),
                // Near you
                SectionHeader(
                  title: '📍 Cerca de ti',
                  subtitle: 'El Poblado, Medellín',
                  actionLabel: 'Ver mapa',
                  onAction: () => context.go(AppConstants.routeNearby),
                ),
                const SizedBox(height: 12),
                _buildNearby(context),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    final user = MockUser.mockUser;
    return SliverAppBar(
      expandedHeight: 130,
      floating: true,
      snap: true,
      backgroundColor: AppColors.background,
      elevation: 0,
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
                      '¡Hola, ${user.name.split(' ').first}! 👋',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      '¿A dónde vamos hoy?',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Profile avatar
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
                    child: Text('👤', style: TextStyle(fontSize: 22)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context) {
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
            offset: const Offset(0, 4),
          ),
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
            child: const Center(
                child: Text('📍', style: TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tu ubicación actual',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'El Poblado, Medellín',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.safeZone.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            ),
            child: const Text(
              '✓ Zona segura',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.safeZone,
                fontWeight: FontWeight.w600,
              ),
            ),
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
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingM),
        itemCount: MockCategories.all.length,
        itemBuilder: (_, i) {
          final cat = MockCategories.all[i];
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 76,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: Color(int.parse('FF${cat.colorHex}', radix: 16))
                          .withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusL),
                      border: Border.all(
                        color:
                            Color(int.parse('FF${cat.colorHex}', radix: 16))
                                .withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(cat.icon,
                          style: const TextStyle(fontSize: 28)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat.name,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedCarousel(BuildContext context) {
    final places = MockPlaces.featured;
    return SizedBox(
      height: AppConstants.placeCardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
        itemCount: places.length,
        itemBuilder: (_, i) {
          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: PlaceCard(
              place: places[i],
              onTap: () => context.go(
                '${AppConstants.routePlaceDetail}?id=${places[i].id}',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBudgetPlans(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
        children: [
          SizedBox(
            width: 280,
            child: BudgetPlanCard(
              emoji: '🎒',
              title: 'Mochilero Paisa',
              budget: '\$250.000',
              days: '3',
              description: 'Lo mejor de Medellín con presupuesto viajero.',
              onTap: () => context.go(AppConstants.routePlanner),
            ),
          ),
          const SizedBox(width: 14),
          SizedBox(
            width: 280,
            child: BudgetPlanCard(
              emoji: '💑',
              title: 'Escapada Romántica',
              budget: '\$800.000',
              days: '2',
              description: 'Experiencias premium para pareja.',
              onTap: () => context.go(AppConstants.routePlanner),
            ),
          ),
          const SizedBox(width: 14),
          SizedBox(
            width: 280,
            child: BudgetPlanCard(
              emoji: '👨‍👩‍👧‍👦',
              title: 'Plan Familiar',
              budget: '\$600.000',
              days: '4',
              description: 'Actividades para toda la familia.',
              onTap: () => context.go(AppConstants.routePlanner),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularList(BuildContext context) {
    final places = MockPlaces.popular.take(3).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      child: Column(
        children: places
            .map((p) => PlaceCard(
                  place: p,
                  isHorizontal: true,
                  onTap: () => context.go(
                      '${AppConstants.routePlaceDetail}?id=${p.id}'),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildNearby(BuildContext context) {
    final places = MockPlaces.nearbyPlaces.take(3).toList();
    return SizedBox(
      height: AppConstants.placeCardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
        itemCount: places.length,
        itemBuilder: (_, i) {
          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: PlaceCard(
              place: places[i],
              onTap: () => context
                  .go('${AppConstants.routePlaceDetail}?id=${places[i].id}'),
            ),
          );
        },
      ),
    );
  }
}
