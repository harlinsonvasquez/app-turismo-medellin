import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/data/models/place_model.dart';
import 'package:app_turismo/presentation/providers/auth_provider.dart';
import 'package:app_turismo/presentation/providers/favorites_provider.dart';
import 'package:app_turismo/presentation/providers/place_provider.dart';
import 'package:app_turismo/presentation/widgets/common_widgets.dart';
import 'package:app_turismo/presentation/widgets/place_card.dart';
import 'package:app_turismo/presentation/widgets/tourism_image.dart';

/// Muestra el detalle completo de un lugar, consulta `/api/places/{id}` y
/// coordina favoritos y sugerencias relacionadas desde el catalogo ya cargado.
class PlaceDetailScreen extends StatefulWidget {
  final String placeId;
  const PlaceDetailScreen({super.key, required this.placeId});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  late Future<PlaceModel?> _detalleLugarFuture;

  @override
  void initState() {
    super.initState();
    _detalleLugarFuture =
        context.read<PlaceProvider>().cargarDetalleLugar(widget.placeId);
  }

  @override
  void didUpdateWidget(covariant PlaceDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.placeId != widget.placeId) {
      _detalleLugarFuture =
          context.read<PlaceProvider>().cargarDetalleLugar(widget.placeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _detalleLugarFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final place = snapshot.data!;
        final relatedPlaces = context
            .watch<PlaceProvider>()
            .places
            .where((item) =>
                item.category == place.category && item.id != place.id)
            .take(3)
            .toList();
        final favoritesProvider = context.watch<FavoritesProvider>();
        final authProvider = context.watch<AuthProvider>();
        final isSaved = favoritesProvider.isFavoriteReference(place.id);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: AppConstants.heroImageHeight,
                pinned: true,
                backgroundColor: AppColors.primary,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          color: Colors.black45, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white)),
                ),
                actions: [
                  GestureDetector(
                    onTap: () async {
                      if (!authProvider.isAuthenticated) {
                        context.go(AppConstants.routeLogin);
                        return;
                      }
                      await favoritesProvider.alternarFavorito(
                          itemType: 'PLACE', referenceId: place.id);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          color: Colors.black45, shape: BoxShape.circle),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                          isSaved
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isSaved ? Colors.red : Colors.white,
                          size: 22),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      const ColoredBox(color: AppColors.surfaceVariant),
                      ImagenTuristica(
                        imageUrl: place.imagenPrincipalUrl,
                        placeholderIcon: Icons.photo_outlined,
                        placeholderLabel: 'Imagen no disponible',
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black45])),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(place.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(fontWeight: FontWeight.w800))),
                          const SizedBox(width: 12),
                          RatingBadge(rating: place.rating, large: true),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('${place.neighborhood}, ${place.city}',
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.textTertiary)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _StatCard(
                              icon: '?',
                              label: 'Horario',
                              value: place.openingHours,
                              flex: 2),
                          const SizedBox(width: 10),
                          _StatCard(
                              icon: '??',
                              label: 'Desde',
                              value: place.pricePerPerson == 0
                                  ? 'Gratis'
                                  : place.formattedPrice,
                              flex: 1),
                          const SizedBox(width: 10),
                          _StatCard(
                              icon: '??',
                              label: 'Distancia',
                              value:
                                  '${place.distanceKm.toStringAsFixed(1)} km',
                              flex: 1),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text('Descripcion',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(place.description,
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              height: 1.6)),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: place.tags
                            .map((tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                      color: AppColors.surfaceVariant,
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radiusFull)),
                                  child: Text('# $tag',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w500)),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                      if (place.safetyNote != null) ...[
                        Text('Recomendaciones de seguridad',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              color: AppColors.cautionZone.withOpacity(0.08),
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radiusL)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('??', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Text(place.safetyNote!,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                          height: 1.5))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      if (relatedPlaces.isNotEmpty) ...[
                        Text('Lugares relacionados',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: AppConstants.placeCardHeight,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: relatedPlaces.length,
                            itemBuilder: (_, i) => Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: PlaceCard(
                                  place: relatedPlaces[i],
                                  onTap: () => context.go(
                                      '${AppConstants.routePlaceDetail}?id=${relatedPlaces[i].id}')),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.go(AppConstants.routeNearby),
                              icon: const Icon(Icons.route_rounded, size: 18),
                              label: const Text('Ver ruta'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: () => context.go(AppConstants.routePlanner),
                              icon: const Icon(Icons.add_rounded, size: 18),
                              label: const Text('Agregar a plan'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                elevation: 4,
                                shadowColor: AppColors.primary.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final int flex;

  const _StatCard(
      {required this.icon,
      required this.label,
      required this.value,
      required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppConstants.radiusM)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
