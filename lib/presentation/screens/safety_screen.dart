import 'package:flutter/material.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/data/mock/mock_data.dart';
import 'package:app_turismo/data/models/user_model.dart';
import 'package:app_turismo/presentation/widgets/common_widgets.dart';
import 'package:app_turismo/presentation/widgets/specialized_widgets.dart';

class SafetyScreen extends StatefulWidget {
  const SafetyScreen({super.key});

  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  SafetyTipCategory? _selectedCategory;

  List<SafetyTipModel> get _filteredTips {
    if (_selectedCategory == null) return MockSafetyTips.all;
    return MockSafetyTips.all
        .where((t) => t.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Seguridad para turistas')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero banner
                Container(
                  margin: const EdgeInsets.all(AppConstants.paddingM),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF1A5F7A),
                        AppColors.primary.withOpacity(0.7),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusXL),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '🛡️ Viaja seguro por\nMedellín y Antioquia',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Consejos reales de turistas y locales para que tu visita sea 100% segura.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text('🏔️', style: TextStyle(fontSize: 56)),
                    ],
                  ),
                ),
                // Zone awareness
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingM),
                  child: Text(
                    'Zonas de la ciudad',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingM),
                  child: Row(
                    children: [
                      _ZoneCard(
                        emoji: '✅',
                        label: 'Zonas\nSeguras',
                        subtitle: 'El Poblado\nLaureles',
                        color: AppColors.safeZone,
                      ),
                      const SizedBox(width: 10),
                      _ZoneCard(
                        emoji: '⚠️',
                        label: 'Con\nPrecaución',
                        subtitle: 'Centro\nAranjuez',
                        color: AppColors.cautionZone,
                      ),
                      const SizedBox(width: 10),
                      _ZoneCard(
                        emoji: '🚫',
                        label: 'Evitar\nde Noche',
                        subtitle: 'El Bronx\nPeriferias',
                        color: AppColors.dangerZone,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Emergency info
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingM),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.07),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusL),
                      border: Border.all(
                          color: AppColors.error.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Text('🚨',
                            style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Emergencias en Colombia',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: AppColors.error,
                              ),
                            ),
                            SizedBox(height: 6),
                            _EmergencyRow(label: 'Emergencias unificadas', number: '123'),
                            _EmergencyRow(label: 'Policía Nacional', number: '112'),
                            _EmergencyRow(label: 'Cruz Roja', number: '132'),
                            _EmergencyRow(label: 'Bomberos de Medellín', number: '119'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Filter chips
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingM),
                  child: Text(
                    'Consejos de seguridad',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingM),
                    children: [
                      AppChip(
                        label: 'Todos',
                        isSelected: _selectedCategory == null,
                        onTap: () =>
                            setState(() => _selectedCategory = null),
                      ),
                      const SizedBox(width: 8),
                      ...SafetyTipCategory.values.map((c) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: AppChip(
                              label: _categoryName(c),
                              isSelected: _selectedCategory == c,
                              onTap: () =>
                                  setState(() => _selectedCategory = c),
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Tips list
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingM),
                  child: Column(
                    children: _filteredTips
                        .map((t) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: SafetyTipBanner(tip: t),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _categoryName(SafetyTipCategory c) {
    switch (c) {
      case SafetyTipCategory.transport: return '🚕 Transporte';
      case SafetyTipCategory.scam: return '⚠️ Estafas';
      case SafetyTipCategory.zones: return '📍 Zonas';
      case SafetyTipCategory.emergency: return '🚨 Emergencias';
      case SafetyTipCategory.general: return '💡 General';
      case SafetyTipCategory.health: return '💊 Salud';
    }
  }
}

class _ZoneCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String subtitle;
  final Color color;

  const _ZoneCard({
    required this.emoji,
    required this.label,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          border: Border.all(color: color.withOpacity(0.25), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textTertiary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyRow extends StatelessWidget {
  final String label;
  final String number;
  const _EmergencyRow({required this.label, required this.number});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          children: [
            TextSpan(text: '$label: '),
            TextSpan(
              text: number,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
