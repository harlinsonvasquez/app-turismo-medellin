import 'package:flutter/material.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/data/models/place_model.dart';
import 'package:app_turismo/presentation/widgets/tourism_image.dart';

/// Tarjeta reutilizable para listar lugares.
/// Consume la imagen principal calculada desde `PlaceModel` y muestra un
/// fallback visual cuando el backend no entrega una URL valida.
class PlaceCard extends StatelessWidget {
  final PlaceModel place;
  final VoidCallback? onTap;
  final bool isHorizontal;

  const PlaceCard({
    super.key,
    required this.place,
    this.onTap,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return isHorizontal
        ? _buildHorizontalCard(context)
        : _buildVerticalCard(context);
  }

  Widget _buildVerticalCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppConstants.placeCardWidth,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: ImagenTuristica(
                    imageUrl: place.imagenPrincipalUrl,
                    placeholderIcon: Icons.landscape_outlined,
                    placeholderLabel: 'Sin imagen',
                  ),
                ),
                // Safety badge
                if (place.safetyLevel == SafetyLevel.safe)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.safeZone,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusFull),
                      ),
                      child: const Text(
                        '✓ Seguro',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                // Category chip
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusFull),
                    ),
                    child: Text(
                      place.categoryLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 13, color: AppColors.accent),
                        const SizedBox(width: 2),
                        Text(
                          place.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            ' (${place.reviewCount})',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textTertiary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 11, color: AppColors.textTertiary),
                              const SizedBox(width: 2),
                              Flexible(
                                child: Text(
                                  '${place.distanceKm.toStringAsFixed(1)} km',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textTertiary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          place.pricePerPerson == 0
                              ? 'Gratis'
                              : place.formattedPrice,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
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
      ),
    );
  }

  Widget _buildHorizontalCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // Image
            SizedBox(
              width: 100,
              height: 100,
              child: ImagenTuristica(
                imageUrl: place.imagenPrincipalUrl,
                placeholderIcon: Icons.landscape_outlined,
                placeholderLabel: 'Sin imagen',
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusFull),
                          ),
                          child: Text(
                            place.categoryLabel,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        if (place.safetyLevel == SafetyLevel.safe)
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.safeZone.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusFull),
                              ),
                              child: const Text(
                                '✓ Seguro',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.safeZone,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      place.neighborhood,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 13, color: AppColors.accent),
                        Text(
                          ' ${place.rating}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: AppColors.textTertiary),
                        Text(
                          ' ${place.distanceKm.toStringAsFixed(1)} km',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          place.pricePerPerson == 0
                              ? 'Gratis'
                              : place.formattedPrice,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right,
                  color: AppColors.textTertiary, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
