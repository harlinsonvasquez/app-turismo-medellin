import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/presentation/widgets/common_widgets.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingL),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.gradientStart,
                              AppColors.gradientEnd
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.location_on_rounded,
                              color: Colors.white, size: 64),
                        ),
                      ),
                      const SizedBox(height: 36),
                      Text(
                        'Activar ubicacion',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Para mostrarte lugares cercanos, calcular distancias y generar itinerarios precisos, necesitamos acceso a tu ubicacion.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      const _BenefitItem(
                        icon: Icons.hotel_rounded,
                        text: 'Descubre hoteles y restaurantes cercanos',
                      ),
                      const SizedBox(height: 12),
                      const _BenefitItem(
                        icon: Icons.straighten_rounded,
                        text: 'Ve la distancia exacta desde donde estas',
                      ),
                      const SizedBox(height: 12),
                      const _BenefitItem(
                        icon: Icons.shield_outlined,
                        text: 'Alertas de seguridad en tu zona actual',
                      ),
                      const SizedBox(height: 12),
                      const _BenefitItem(
                        icon: Icons.route_rounded,
                        text: 'Rutas optimizadas en tus itinerarios',
                      ),
                      const SizedBox(height: 32),
                      GradientButton(
                        label: 'Permitir ubicacion',
                        icon: Icons.location_on_rounded,
                        onPressed: () => context.go(AppConstants.routeHome),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => context.go(AppConstants.routeHome),
                          child: const Text('Ahora no'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Puedes cambiar esto en cualquier momento en Ajustes',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textTertiary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BenefitItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
