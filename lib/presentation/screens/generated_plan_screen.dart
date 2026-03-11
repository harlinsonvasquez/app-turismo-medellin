import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/data/mock/mock_data.dart';
import 'package:app_turismo/data/models/plan_model.dart';
import 'package:app_turismo/presentation/widgets/common_widgets.dart';
import 'package:app_turismo/presentation/widgets/specialized_widgets.dart';

class GeneratedPlanScreen extends StatefulWidget {
  const GeneratedPlanScreen({super.key});

  @override
  State<GeneratedPlanScreen> createState() => _GeneratedPlanScreenState();
}

class _GeneratedPlanScreenState extends State<GeneratedPlanScreen> {
  final plan = MockPlans.all.first;
  bool _isSaved = false;
  int? _expandedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tu plan generado'),
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _isSaved ? AppColors.primary : null,
            ),
            onPressed: () {
              setState(() => _isSaved = !_isSaved);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isSaved
                      ? '✅ Plan guardado en tus favoritos'
                      : 'Plan eliminado de favoritos'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plan summary card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.gradientStart, AppColors.gradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusXL),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('✨', style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                plan.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _StatPill('📅 ${plan.days} días'),
                            const SizedBox(width: 8),
                            _StatPill('💰 ${plan.estimatedTotal.split(' ').first}'),
                            const SizedBox(width: 8),
                            _StatPill('🚇 Metro + Taxi'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: 12),
                        Text(
                          '💰 Total estimado: ${plan.estimatedTotal}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '🚌 ${plan.transportSummary}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // General notes
                  Text(
                    '📝 Notas generales',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  ...plan.generalNotes.map((n) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ',
                                style: TextStyle(
                                    fontSize: 18, color: AppColors.primary)),
                            Expanded(
                              child: Text(n,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  )),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 24),
                  // Itinerary days
                  Text(
                    '📅 Itinerario día a día',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  ...plan.dayPlans.asMap().entries.map((entry) {
                    final dayPlan = entry.value;
                    final isExpanded = _expandedDay == dayPlan.dayNumber;
                    final totalActivities = dayPlan.morning.length +
                        dayPlan.afternoon.length +
                        dayPlan.night.length;
                    return Column(
                      children: [
                        ItineraryDayCard(
                          dayNumber: dayPlan.dayNumber,
                          theme: dayPlan.theme,
                          neighborhood: dayPlan.neighborhood,
                          dailyBudget: dayPlan.dailyBudget,
                          activitiesCount: totalActivities,
                          isExpanded: isExpanded,
                          onTap: () => setState(() =>
                              _expandedDay = isExpanded ? null : dayPlan.dayNumber),
                        ),
                        if (isExpanded) ...[
                          const SizedBox(height: 8),
                          _buildDayDetail(context, dayPlan),
                        ],
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
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
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.go(AppConstants.routePlanner),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Regenerar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() => _isSaved = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('✅ Itinerario guardado con éxito!')),
                  );
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

  Widget _buildDayDetail(BuildContext context, DayPlan day) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Column(
        children: [
          if (day.morning.isNotEmpty)
            _TimeSection(icon: '🌅', label: 'Mañana', blocks: day.morning),
          if (day.afternoon.isNotEmpty)
            _TimeSection(icon: '☀️', label: 'Tarde', blocks: day.afternoon),
          if (day.night.isNotEmpty)
            _TimeSection(icon: '🌙', label: 'Noche', blocks: day.night),
          // Safety note
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              border: Border.all(
                  color: AppColors.warning.withOpacity(0.25), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🛡️', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    day.safetyNote,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
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

class _TimeSection extends StatelessWidget {
  final String icon;
  final String label;
  final List<ItineraryBlock> blocks;

  const _TimeSection({
    required this.icon,
    required this.label,
    required this.blocks,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '$icon $label',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        ...blocks.map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 1.5,
                        height: 60,
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.time,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          b.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          b.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _Pill(b.estimatedCost, AppColors.secondary),
                            const SizedBox(width: 6),
                            _Pill(b.transport, AppColors.primary),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        const Divider(),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  const _Pill(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String text;
  const _StatPill(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
