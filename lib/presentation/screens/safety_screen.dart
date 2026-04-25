import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/data/models/user_model.dart';
import 'package:app_turismo/presentation/providers/safety_provider.dart';
import 'package:app_turismo/presentation/widgets/common_widgets.dart';
import 'package:app_turismo/presentation/widgets/specialized_widgets.dart';

/// Pantalla dedicada a recomendaciones de seguridad para turistas.
/// Consume `/api/safety-tips` y permite filtrar la informacion por categoria.
class SafetyScreen extends StatefulWidget {
  const SafetyScreen({super.key});

  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  SafetyTipCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<SafetyProvider>().cargarConsejos(city: 'Medellin'));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SafetyProvider>();
    final tips = _selectedCategory == null
        ? provider.tips
        : provider.tips
            .where((tip) => tip.category == _selectedCategory)
            .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Seguridad para turistas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(AppConstants.paddingM),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      const Color(0xFF1A5F7A),
                      AppColors.primary.withOpacity(0.7)
                    ]),
                    borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text('Viaja seguro por Medellin y Antioquia',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2)),
                            SizedBox(height: 8),
                            Text(
                                'Consejos cargados desde el backend para que tu visita sea mas segura.',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    height: 1.4)),
                          ])),
                      Text('???', style: TextStyle(fontSize: 56)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingM),
                  child: Text('Consejos de seguridad',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700)),
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
                              setState(() => _selectedCategory = null)),
                      const SizedBox(width: 8),
                      ...SafetyTipCategory.values.map((category) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: AppChip(
                                label: _categoryName(category),
                                isSelected: _selectedCategory == category,
                                onTap: () => setState(
                                    () => _selectedCategory = category)),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (provider.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingM),
                    child: Column(
                        children: tips
                            .map((tip) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: SafetyTipBanner(tip: tip)))
                            .toList()),
                  ),
                if (provider.error != null)
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingM),
                    child: Text(provider.error!,
                        style: const TextStyle(color: AppColors.error)),
                  ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _categoryName(SafetyTipCategory category) {
    switch (category) {
      case SafetyTipCategory.transport:
        return 'Transporte';
      case SafetyTipCategory.scam:
        return 'Estafas';
      case SafetyTipCategory.zones:
        return 'Zonas';
      case SafetyTipCategory.emergency:
        return 'Emergencias';
      case SafetyTipCategory.general:
        return 'General';
      case SafetyTipCategory.health:
        return 'Salud';
    }
  }
}
