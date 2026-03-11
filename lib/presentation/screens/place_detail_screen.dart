import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/data/mock/mock_places.dart';
import 'package:app_turismo/data/mock/mock_data.dart';
import 'package:app_turismo/data/models/place_model.dart';
import 'package:app_turismo/presentation/widgets/place_card.dart';
import 'package:app_turismo/presentation/widgets/common_widgets.dart';
import 'package:app_turismo/presentation/widgets/specialized_widgets.dart';

class PlaceDetailScreen extends StatefulWidget {
  final String placeId;
  const PlaceDetailScreen({super.key, required this.placeId});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    final place = MockPlaces.getById(widget.placeId) ?? MockPlaces.featured.first;
    final relatedPlaces = MockPlaces.all
        .where((p) => p.category == place.category && p.id != place.id)
        .take(3)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero image sliver app bar
          SliverAppBar(
            expandedHeight: AppConstants.heroImageHeight,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => setState(() => _isSaved = !_isSaved),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    _isSaved
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: _isSaved ? Colors.red : Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero image
                  place.imageUrls.isNotEmpty
                      ? Image.network(
                          place.imageUrls.first,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.surfaceVariant,
                            child: const Center(
                              child: Text('🏔️',
                                  style: TextStyle(fontSize: 80)),
                            ),
                          ),
                        )
                      : Container(color: AppColors.surfaceVariant),
                  // Gradient overlay
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black45,
                        ],
                      ),
                    ),
                  ),
                  // Category + safety badges
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Row(
                      children: [
                        _Badge(
                            text: place.categoryLabel,
                            color: AppColors.primary),
                        const SizedBox(width: 8),
                        if (place.safetyLevel == SafetyLevel.safe)
                          _Badge(
                              text: '✓ Zona Segura',
                              color: AppColors.safeZone),
                        if (place.safetyLevel == SafetyLevel.caution)
                          _Badge(
                              text: '⚠️ Precaución',
                              color: AppColors.cautionZone),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          place.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      RatingBadge(rating: place.rating, large: true),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        '${place.neighborhood}, ${place.city}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Stats row
                  Row(
                    children: [
                      _StatCard(
                          icon: '⏰',
                          label: 'Horario',
                          value: place.openingHours,
                          flex: 2),
                      const SizedBox(width: 10),
                      _StatCard(
                          icon: '💰',
                          label: 'Desde',
                          value: place.pricePerPerson == 0
                              ? 'Gratis'
                              : place.formattedPrice,
                          flex: 1),
                      const SizedBox(width: 10),
                      _StatCard(
                          icon: '📏',
                          label: 'Distancia',
                          value:
                              '${place.distanceKm.toStringAsFixed(1)} km',
                          flex: 1),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Reviews
                  Row(
                    children: [
                      ...List.generate(
                          5,
                          (i) => Icon(
                                Icons.star_rounded,
                                size: 18,
                                color: i < place.rating.floor()
                                    ? AppColors.accent
                                    : AppColors.divider,
                              )),
                      const SizedBox(width: 8),
                      Text(
                        '${place.rating} de 5.0 (${place.reviewCount} reseñas)',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Description
                  Text(
                    'Descripción',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    place.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: place.tags
                        .map((t) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusFull),
                              ),
                              child: Text(
                                '# $t',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  // Safety
                  if (place.safetyNote != null) ...[
                    Text(
                      '🛡️ Recomendaciones de seguridad',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cautionZone.withOpacity(0.08),
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusL),
                        border: Border.all(
                          color: AppColors.cautionZone.withOpacity(0.25),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('⚠️',
                              style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              place.safetyNote!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  // Related places
                  if (relatedPlaces.isNotEmpty) ...[
                    Text(
                      'Lugares relacionados',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
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
                              '${AppConstants.routePlaceDetail}?id=${relatedPlaces[i].id}',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  // CTA Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.route_rounded, size: 18),
                          label: const Text('Ver ruta'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context.go(AppConstants.routePlanner),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Agregar a plan'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final int flex;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.flex,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
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

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
