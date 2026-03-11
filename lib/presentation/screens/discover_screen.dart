import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/data/mock/mock_places.dart';
import 'package:app_turismo/data/models/place_model.dart';
import 'package:app_turismo/presentation/widgets/place_card.dart';
import 'package:app_turismo/presentation/widgets/common_widgets.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String _selectedCategory = 'Todos';
  String _selectedBudget = 'Cualquier presupuesto';
  bool _onlyOpen = false;
  bool _safeZoneOnly = false;
  bool _isGridView = false;

  final List<String> _categories = [
    'Todos',
    'Hoteles',
    'Restaurantes',
    'Turismo',
    'Vida Nocturna',
    'Pueblos',
    'Experiencias',
  ];

  final List<String> _budgets = [
    'Cualquier presupuesto',
    'Económico',
    'Moderado',
    'Premium',
    'Lujo',
  ];

  List<PlaceModel> get _filteredPlaces {
    return MockPlaces.all.where((p) {
      if (_selectedCategory != 'Todos') {
        final catMap = {
          'Hoteles': PlaceCategory.hotel,
          'Restaurantes': PlaceCategory.restaurant,
          'Turismo': PlaceCategory.touristPlace,
          'Vida Nocturna': PlaceCategory.nightlife,
          'Pueblos': PlaceCategory.town,
          'Experiencias': PlaceCategory.experience,
        };
        if (catMap[_selectedCategory] != p.category) return false;
      }
      if (_onlyOpen && !p.isOpenNow) return false;
      if (_safeZoneOnly && p.safetyLevel != SafetyLevel.safe) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Explorar'),
        actions: [
          IconButton(
            icon: Icon(
                _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.paddingM,
                vertical: AppConstants.paddingS),
            child: AppSearchBar(hint: 'Buscar en Medellín y Antioquia...'),
          ),
          // Category chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingM),
              itemCount: _categories.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AppChip(
                  label: _categories[i],
                  isSelected: _selectedCategory == _categories[i],
                  onTap: () =>
                      setState(() => _selectedCategory = _categories[i]),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Filter row
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingM),
              children: [
                _FilterChip(
                  label: _selectedBudget == 'Cualquier presupuesto'
                      ? '💰 Presupuesto'
                      : '💰 $_selectedBudget',
                  isActive: _selectedBudget != 'Cualquier presupuesto',
                  onTap: () => _showBudgetSheet(context),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '📏 Distancia',
                  isActive: false,
                  onTap: () {},
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '⏰ Abierto ahora',
                  isActive: _onlyOpen,
                  onTap: () => setState(() => _onlyOpen = !_onlyOpen),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '🛡️ Zona segura',
                  isActive: _safeZoneOnly,
                  onTap: () =>
                      setState(() => _safeZoneOnly = !_safeZoneOnly),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingM, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${_filteredPlaces.length} resultados',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.sort_rounded, size: 16),
                  label: const Text('Ordenar'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          // Results
          Expanded(
            child: _isGridView
                ? _buildGrid(context)
                : _buildList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    final places = _filteredPlaces;
    if (places.isEmpty) return _buildEmpty();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      itemCount: places.length,
      itemBuilder: (_, i) => PlaceCard(
        place: places[i],
        isHorizontal: true,
        onTap: () => context.go(
            '${AppConstants.routePlaceDetail}?id=${places[i].id}'),
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    final places = _filteredPlaces;
    if (places.isEmpty) return _buildEmpty();
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemCount: places.length,
      itemBuilder: (_, i) => PlaceCard(
        place: places[i],
        onTap: () => context.go(
            '${AppConstants.routePlaceDetail}?id=${places[i].id}'),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🔍', style: TextStyle(fontSize: 64)),
          SizedBox(height: 16),
          Text(
            'Sin resultados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Intenta con otros filtros',
            style: TextStyle(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  void _showBudgetSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusXXL)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Filtrar por presupuesto',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ..._budgets.map((b) => ListTile(
                title: Text(b),
                trailing: _selectedBudget == b
                    ? const Icon(Icons.check_circle,
                        color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _selectedBudget = b);
                  Navigator.pop(context);
                },
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.divider,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
