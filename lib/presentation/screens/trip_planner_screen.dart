import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/data/models/plan_model.dart';
import 'package:app_turismo/presentation/providers/auth_provider.dart';
import 'package:app_turismo/presentation/providers/itinerary_provider.dart';
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
  final List<String> _selectedInterests = ['Arte', 'Gastronomia'];
  final List<String> _availableInterests = ['Arte', 'Gastronomia', 'Aventura', 'Naturaleza', 'Historia', 'Fotografia', 'Vida Nocturna', 'Compras', 'Cafe'];

  @override
  Widget build(BuildContext context) {
    final itineraryProvider = context.watch<ItineraryProvider>();
    final auth = context.watch<AuthProvider>();

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
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]),
                      borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                    ),
                    child: const Text('Cuenta como viajas y el backend genera un itinerario real con datos persistidos.', style: TextStyle(color: Colors.white, height: 1.4)),
                  ),
                  const SizedBox(height: 24),
                  _SectionLabel(label: 'Cuantos dias', value: '$_days dias'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [1, 2, 3, 4, 5, 7].map((d) {
                      final selected = _days == d;
                      return GestureDetector(
                        onTap: () => setState(() => _days = d),
                        child: AnimatedContainer(
                          duration: AppConstants.animFast,
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(color: selected ? AppColors.primary : AppColors.surfaceVariant, borderRadius: BorderRadius.circular(AppConstants.radiusM)),
                          child: Center(child: Text('$d', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: selected ? Colors.white : AppColors.textPrimary))),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  _SectionLabel(label: 'Presupuesto total', value: '\$${(_budget / 1000).toStringAsFixed(0)}K COP'),
                  Slider(value: _budget, min: 100000, max: 2000000, divisions: 38, onChanged: (value) => setState(() => _budget = value)),
                  const SizedBox(height: 24),
                  _SectionLabel(label: 'Estilo de viaje', value: _style.name),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: TravelStyle.values.map((style) {
                      final selected = _style == style;
                      return AppChip(label: style.name, isSelected: selected, onTap: () => setState(() => _style = style));
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  _SectionLabel(label: 'Con quien viajas', value: _travelerType.name),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: TravelerType.values.map((traveler) {
                      final selected = _travelerType == traveler;
                      return AppChip(label: traveler.name, isSelected: selected, onTap: () => setState(() => _travelerType = traveler));
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  _SectionLabel(label: 'Intereses', value: '${_selectedInterests.length} elegidos'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableInterests.map((interest) {
                      final selected = _selectedInterests.contains(interest);
                      return AppChip(
                        label: interest,
                        isSelected: selected,
                        onTap: () => setState(() {
                          if (selected) {
                            _selectedInterests.remove(interest);
                          } else {
                            _selectedInterests.add(interest);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                  if (!auth.isAuthenticated)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Text('Puedes generar sin login, pero para guardar el plan necesitas iniciar sesion.', style: TextStyle(color: AppColors.textSecondary.withOpacity(0.9))),
                    ),
                  if (itineraryProvider.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Text(itineraryProvider.error!, style: const TextStyle(color: AppColors.error)),
                    ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(AppConstants.paddingM, AppConstants.paddingM, AppConstants.paddingM, 32),
            decoration: const BoxDecoration(color: AppColors.surface),
            child: GradientButton(
              label: 'Generar mi plan',
              icon: Icons.auto_awesome_rounded,
              isLoading: itineraryProvider.isLoading,
              onPressed: () async {
                final plan = await context.read<ItineraryProvider>().generatePlan(
                      PlanInputModel(
                        city: 'Medellin',
                        days: _days,
                        totalBudget: _budget.round(),
                        style: _style,
                        travelerType: _travelerType,
                        interests: _selectedInterests,
                      ),
                    );
                if (!mounted) return;
                if (plan != null) context.go(AppConstants.routeGeneratedPlan);
              },
            ),
          ),
        ],
      ),
    );
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
        Text(label, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(AppConstants.radiusFull)),
          child: Text(value, style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
