import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/data/mock/mock_data.dart';
import 'package:app_turismo/presentation/widgets/specialized_widgets.dart';

class BusinessPromoScreen extends StatelessWidget {
  const BusinessPromoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.accent,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Colors.black26, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFB7500A), AppColors.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -40,
                      right: -40,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.07),
                        ),
                      ),
                    ),
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 40),
                          Text('🏢', style: TextStyle(fontSize: 48)),
                          SizedBox(height: 8),
                          Text(
                            'Promueve tu negocio',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Llega a miles de turistas en Medellín',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Benefits
                  Text(
                    '¿Por qué estar en AppTurismo?',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _BenefitCard(
                          emoji: '👁️',
                          title: '+50K',
                          subtitle: 'Turistas\nal mes'),
                      const SizedBox(width: 10),
                      _BenefitCard(
                          emoji: '🗺️',
                          title: '100%',
                          subtitle: 'En\nitinerarios'),
                      const SizedBox(width: 10),
                      _BenefitCard(
                          emoji: '⭐',
                          title: '4.8★',
                          subtitle: 'Satisfacción\nturistas'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // How it works
                  Text(
                    '¿Cómo funciona?',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  const _Step(
                    number: '1',
                    title: 'Registra tu negocio',
                    desc:
                        'Crea tu perfil con fotos, descripción, precios y horarios.',
                  ),
                  const _Step(
                    number: '2',
                    title: 'Elige tu plan',
                    desc:
                        'Selecciona el plan que mejor se adapte a tu negocio y presupuesto.',
                  ),
                  const _Step(
                    number: '3',
                    title: 'Aparece en itinerarios',
                    desc:
                        'Nuestro algoritmo incluirá tu negocio en los planes generados para turistas.',
                  ),
                  const SizedBox(height: 24),
                  // Plans
                  Text(
                    'Planes de membresía',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  ...MockMembershipPlans.all.map((plan) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: MembershipPlanCard(
                          plan: plan,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '¡Elegiste el plan ${plan.name}! Redirigiendo...'),
                              ),
                            );
                          },
                        ),
                      )),
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

class _BenefitCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const _BenefitCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.accent.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          border: Border.all(
              color: AppColors.accent.withOpacity(0.2), width: 1.5),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textTertiary,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String number;
  final String title;
  final String desc;

  const _Step({
    required this.number,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
