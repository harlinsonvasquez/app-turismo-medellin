import 'package:flutter/material.dart';

import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/data/models/event_model.dart';

/// Tarjeta visual para eventos obtenidos desde `/api/events`.
/// Hoy el backend no expone imagen, por eso la tarjeta prioriza metadata clave.
class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event, this.onTap});

  final EventModel event;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppConstants.radiusFull),
              ),
              child: Text(
                event.categoryLabel,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            Text(
              event.address,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.event_rounded,
                    size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${event.startDate.day}/${event.startDate.month} - ${event.city}',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              event.averagePrice == 0
                  ? 'Gratis'
                  : '\$${event.averagePrice} COP',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
