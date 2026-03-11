import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/data/mock/mock_places.dart';
import 'package:app_turismo/data/mock/mock_data.dart';
import 'package:app_turismo/presentation/widgets/place_card.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final savedPlaces = MockPlaces.all
        .where((p) => MockUser.mockUser.savedPlaceIds.contains(p.id))
        .toList();
    final hasSavedPlaces = savedPlaces.isNotEmpty;
    final hasSavedPlans = MockUser.mockUser.savedPlanIds.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Guardados'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '🏨 Lugares'),
            Tab(text: '📅 Itinerarios'),
          ],
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textTertiary,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Saved Places
          hasSavedPlaces
              ? ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.paddingM),
                  itemCount: savedPlaces.length,
                  itemBuilder: (_, i) => PlaceCard(
                    place: savedPlaces[i],
                    isHorizontal: true,
                    onTap: () => context.go(
                        '${AppConstants.routePlaceDetail}?id=${savedPlaces[i].id}'),
                  ),
                )
              : _buildEmptyState(
                  '❤️',
                  'Sin lugares guardados',
                  'Guarda tus lugares favoritos para encontrarlos fácilmente.',
                ),
          // Saved Itineraries
          hasSavedPlans
              ? ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.paddingM),
                  itemCount: MockPlans.all.length,
                  itemBuilder: (_, i) {
                    final plan = MockPlans.all[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusL),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusM),
                          ),
                          child: const Center(
                            child: Text('📅',
                                style: TextStyle(fontSize: 26)),
                          ),
                        ),
                        title: Text(
                          plan.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '${plan.days} días • ${plan.estimatedTotal}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right,
                            color: AppColors.textTertiary),
                        onTap: () =>
                            context.go(AppConstants.routeGeneratedPlan),
                      ),
                    );
                  },
                )
              : _buildEmptyState(
                  '📅',
                  'Sin itinerarios guardados',
                  'Genera tu primer plan de viaje personalizado.',
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      String emoji, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textTertiary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.routeHome),
              child: const Text('Explorar lugares'),
            ),
          ],
        ),
      ),
    );
  }
}
