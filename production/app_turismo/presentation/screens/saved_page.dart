import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/presentation/providers/auth_provider.dart';
import 'package:app_turismo/presentation/providers/favorites_provider.dart';
import 'package:app_turismo/presentation/providers/itinerary_provider.dart';
import 'package:app_turismo/presentation/widgets/tourism_image.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AuthProvider>().isAuthenticated) {
        context.read<FavoritesProvider>().cargarFavoritos();
        context.read<ItineraryProvider>().cargarPlanesGuardados();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();
    final itineraryProvider = context.watch<ItineraryProvider>();

    if (!auth.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Guardados')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingXL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('??', style: TextStyle(fontSize: 72)),
                const SizedBox(height: 20),
                const Text('Necesitas iniciar sesion',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                const Text(
                    'Tus favoritos e itinerarios guardados viven ahora en el backend.'),
                const SizedBox(height: 24),
                ElevatedButton(
                    onPressed: () => context.go(AppConstants.routeLogin),
                    child: const Text('Iniciar sesion')),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Guardados'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Lugares'), Tab(text: 'Itinerarios')],
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textTertiary,
          indicatorColor: AppColors.primary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          favoritesProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : favoritesProvider.favorites.isEmpty
                  ? _buildEmptyState('Sin lugares guardados',
                      'Tus favoritos se cargan desde /api/favorites')
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppConstants.paddingM),
                      itemCount: favoritesProvider.favorites.length,
                      itemBuilder: (_, index) {
                        final favorite = favoritesProvider.favorites[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radiusL)),
                          child: ListTile(
                            leading: ImagenTuristica(
                              imageUrl: favorite.imageUrl,
                              width: 56,
                              height: 56,
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radiusM),
                              placeholderIcon: favorite.itemType == 'EVENT'
                                  ? Icons.event_rounded
                                  : Icons.place_rounded,
                            ),
                            title: Text(favorite.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                            subtitle: Text(favorite.subtitle),
                            trailing: IconButton(
                              onPressed: () =>
                                  favoritesProvider.alternarFavorito(
                                      itemType: favorite.itemType,
                                      referenceId: favorite.referenceId),
                              icon: const Icon(Icons.delete_outline_rounded),
                            ),
                          ),
                        );
                      },
                    ),
          itineraryProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : itineraryProvider.savedPlans.isEmpty
                  ? _buildEmptyState('Sin itinerarios guardados',
                      'Genera un plan y guardalo en el backend.')
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppConstants.paddingM),
                      itemCount: itineraryProvider.savedPlans.length,
                      itemBuilder: (_, index) {
                        final plan = itineraryProvider.savedPlans[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radiusL)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusM)),
                              child: const Center(
                                  child: Text('???',
                                      style: TextStyle(fontSize: 26))),
                            ),
                            title: Text(plan.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 15)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                  '${plan.days} dias â€¢ ${plan.estimatedTotal}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textTertiary)),
                            ),
                            trailing: const Icon(Icons.chevron_right,
                                color: AppColors.textTertiary),
                            onTap: () async {
                              await context
                                  .read<ItineraryProvider>()
                                  .cargarPlan(plan.id);
                              if (mounted)
                                context.go(AppConstants.routeGeneratedPlan);
                            },
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('??', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 20),
            Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(subtitle,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textTertiary, height: 1.5),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
