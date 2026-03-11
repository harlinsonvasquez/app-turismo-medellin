import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/data/models/plan_model.dart';
import 'package:app_turismo/presentation/widgets/common_widgets.dart';

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  int _days = 3;
  double _budget = 500000;
  TravelStyle _style = TravelStyle.cultural;
  TravelerType _travelerType = TravelerType.couple;
  final List<String> _selectedInterests = ['Arte', 'Gastronomía'];

  final List<String> _availableInterests = [
    'Arte',
    'Gastronomía',
    'Aventura',
    'Naturaleza',
    'Historia',
    'Fotografía',
    'Vida Nocturna',
    'Compras',
    'Café',
    'Música',
    'Deportes',
    'Bienestar',
  ];

  String get _budgetLabel {
    if (_budget <= 200000) return 'Económico';
    if (_budget <= 500000) return 'Moderado';
    if (_budget <= 900000) return 'Premium';
    return 'Todo incluido';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Planear mi viaje')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.gradientStart, AppColors.gradientEnd],
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
                                '🗺️ Crea tu plan perfecto',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Cuéntanos cómo eres y generamos tu itinerario ideal.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Days selector
                  _SectionLabel(label: '📅 ¿Cuántos días?', value: '$_days días'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [1, 2, 3, 4, 5, 7].map((d) {
                      final sel = _days == d;
                      return GestureDetector(
                        onTap: () => setState(() => _days = d),
                        child: AnimatedContainer(
                          duration: AppConstants.animFast,
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: sel
                                ? AppColors.primary
                                : AppColors.surfaceVariant,
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusM),
                            border: Border.all(
                              color: sel
                                  ? AppColors.primary
                                  : AppColors.divider,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$d',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: sel
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  // Budget slider
                  _SectionLabel(
                    label: '💰 Presupuesto total',
                    value:
                        '\$${(_budget / 1000).toStringAsFixed(0)}K COP – $_budgetLabel',
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.divider,
                      thumbColor: AppColors.primary,
                      overlayColor: AppColors.primary.withOpacity(0.15),
                    ),
                    child: Slider(
                      min: 100000,
                      max: 2000000,
                      divisions: 38,
                      value: _budget,
                      onChanged: (v) => setState(() => _budget = v),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('\$100K', style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                      Text('\$2M', style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Travel style
                  _SectionLabel(
                    label: '🎯 Estilo de viaje',
                    value: _styleName(_style),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: TravelStyle.values.map((s) {
                      final sel = _style == s;
                      return GestureDetector(
                        onTap: () => setState(() => _style = s),
                        child: AnimatedContainer(
                          duration: AppConstants.animFast,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(
                            color: sel
                                ? AppColors.primary
                                : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusFull),
                            border: Border.all(
                              color: sel
                                  ? AppColors.primary
                                  : AppColors.divider,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            '${_styleEmoji(s)} ${_styleName(s)}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: sel
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  // Traveler type
                  _SectionLabel(
                    label: '👥 ¿Con quién viajas?',
                    value: _travelerName(_travelerType),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: TravelerType.values.map((t) {
                      final sel = _travelerType == t;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _travelerType = t),
                            child: AnimatedContainer(
                              duration: AppConstants.animFast,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                              decoration: BoxDecoration(
                                color: sel
                                    ? AppColors.primary
                                    : AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusM),
                                border: Border.all(
                                  color: sel
                                      ? AppColors.primary
                                      : AppColors.divider,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    _travelerEmoji(t),
                                    style:
                                        const TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _travelerName(t),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: sel
                                          ? Colors.white
                                          : AppColors.textPrimary,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  // Interests
                  _SectionLabel(
                    label: '❤️ Intereses (selecciona varios)',
                    value: '${_selectedInterests.length} elegidos',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableInterests.map((i) {
                      final sel = _selectedInterests.contains(i);
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (sel) {
                            _selectedInterests.remove(i);
                          } else {
                            _selectedInterests.add(i);
                          }
                        }),
                        child: AnimatedContainer(
                          duration: AppConstants.animFast,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: sel
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusFull),
                            border: Border.all(
                              color: sel
                                  ? AppColors.primary
                                  : AppColors.divider,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            i,
                            style: TextStyle(
                              fontSize: 13,
                              color: sel
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
          // Generate button
          Container(
            padding: const EdgeInsets.fromLTRB(
                AppConstants.paddingM,
                AppConstants.paddingM,
                AppConstants.paddingM,
                32),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 16,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: GradientButton(
              label: '✨ Generar mi plan',
              icon: Icons.auto_awesome_rounded,
              onPressed: () => context.go(AppConstants.routeGeneratedPlan),
            ),
          ),
        ],
      ),
    );
  }

  String _styleName(TravelStyle s) {
    switch (s) {
      case TravelStyle.adventure: return 'Aventura';
      case TravelStyle.cultural: return 'Cultural';
      case TravelStyle.relaxation: return 'Relax';
      case TravelStyle.gastronomy: return 'Gastronomía';
      case TravelStyle.nightlife: return 'Nocturno';
      case TravelStyle.budget: return 'Económico';
      case TravelStyle.luxury: return 'Lujo';
    }
  }

  String _styleEmoji(TravelStyle s) {
    switch (s) {
      case TravelStyle.adventure: return '🏔️';
      case TravelStyle.cultural: return '🎨';
      case TravelStyle.relaxation: return '🧘';
      case TravelStyle.gastronomy: return '🍽️';
      case TravelStyle.nightlife: return '🌃';
      case TravelStyle.budget: return '💸';
      case TravelStyle.luxury: return '✨';
    }
  }

  String _travelerName(TravelerType t) {
    switch (t) {
      case TravelerType.solo: return 'Solo';
      case TravelerType.couple: return 'Pareja';
      case TravelerType.family: return 'Familia';
      case TravelerType.friends: return 'Amigos';
      case TravelerType.digitalNomad: return 'Nómada';
    }
  }

  String _travelerEmoji(TravelerType t) {
    switch (t) {
      case TravelerType.solo: return '🧍';
      case TravelerType.couple: return '💑';
      case TravelerType.family: return '👨‍👩‍👧‍👦';
      case TravelerType.friends: return '👥';
      case TravelerType.digitalNomad: return '💻';
    }
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final String value;
  const _SectionLabel({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700)),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius:
                BorderRadius.circular(AppConstants.radiusFull),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
