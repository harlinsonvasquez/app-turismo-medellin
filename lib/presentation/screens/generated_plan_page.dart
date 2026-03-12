import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/presentation/providers/auth_provider.dart';
import 'package:app_turismo/presentation/providers/itinerary_provider.dart';
import 'package:app_turismo/presentation/widgets/specialized_widgets.dart';

class GeneratedPlanPage extends StatefulWidget {
  const GeneratedPlanPage({super.key});

  @override
  State<GeneratedPlanPage> createState() => _GeneratedPlanPageState();
}

class _GeneratedPlanPageState extends State<GeneratedPlanPage> {
  int? _expandedDay;

  @override
  Widget build(BuildContext context) {
    final itineraryProvider = context.watch<ItineraryProvider>();
    final auth = context.watch<AuthProvider>();
    final plan = itineraryProvider.generatedPlan;

    if (plan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tu plan generado')),
        body: const Center(child: Text('Aun no hay un itinerario generado.')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Tu plan generado')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(plan.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        Text('${plan.days} dias • ${plan.estimatedTotal}', style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (plan.generalNotes.isNotEmpty) ...[
                    Text('Notas generales', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    ...plan.generalNotes.map((note) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text('• $note', style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
                        )),
                    const SizedBox(height: 24),
                  ],
                  Text('Itinerario dia a dia', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  ...plan.dayPlans.map((dayPlan) {
                    final isExpanded = _expandedDay == dayPlan.dayNumber;
                    final totalActivities = dayPlan.morning.length + dayPlan.afternoon.length + dayPlan.night.length;
                    return Column(
                      children: [
                        ItineraryDayCard(
                          dayNumber: dayPlan.dayNumber,
                          theme: dayPlan.theme,
                          neighborhood: dayPlan.neighborhood,
                          dailyBudget: dayPlan.dailyBudget,
                          activitiesCount: totalActivities,
                          isExpanded: isExpanded,
                          onTap: () => setState(() => _expandedDay = isExpanded ? null : dayPlan.dayNumber),
                        ),
                        if (isExpanded)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(top: 8, bottom: 12),
                            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(AppConstants.radiusL)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...dayPlan.morning.map((item) => Text('Manana: ${item.title} - ${item.estimatedCost}')),
                                ...dayPlan.afternoon.map((item) => Padding(padding: const EdgeInsets.only(top: 8), child: Text('Tarde: ${item.title} - ${item.estimatedCost}'))),
                                ...dayPlan.night.map((item) => Padding(padding: const EdgeInsets.only(top: 8), child: Text('Noche: ${item.title} - ${item.estimatedCost}'))),
                              ],
                            ),
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        decoration: const BoxDecoration(color: AppColors.surface),
        child: Row(
          children: [
            Expanded(child: OutlinedButton.icon(onPressed: () => context.go(AppConstants.routePlanner), icon: const Icon(Icons.refresh_rounded, size: 18), label: const Text('Regenerar'))),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (!auth.isAuthenticated) {
                    context.go(AppConstants.routeLogin);
                    return;
                  }
                  final saved = await context.read<ItineraryProvider>().saveCurrentPlan();
                  if (!mounted) return;
                  if (saved != null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Itinerario guardado con exito')));
                  }
                },
                icon: const Icon(Icons.bookmark_add_rounded, size: 18),
                label: const Text('Guardar itinerario'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
