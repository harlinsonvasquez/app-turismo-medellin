import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/data/models/place_model.dart';
import 'package:app_turismo/presentation/providers/event_provider.dart';
import 'package:app_turismo/presentation/providers/place_provider.dart';
import 'package:app_turismo/presentation/widgets/common_widgets.dart';
import 'package:app_turismo/presentation/widgets/event_card.dart';
import 'package:app_turismo/presentation/widgets/place_card.dart';
import 'package:app_turismo/shared/app_catalog.dart';

/// Pantalla de exploracion del catalogo turistico.
/// Permite filtrar lugares y eventos usando `/api/places` y `/api/events`.
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String _selectedCategory = 'Todos';
  String _selectedBudget = 'Cualquier presupuesto';
  bool _safeZoneOnly = false;
  bool _isGridView = false;
  final _searchController = TextEditingController();

  final List<String> _categories = [
    'Todos',
    'Hoteles',
    'Restaurantes',
    'Turismo',
    'Eventos',
    'Vida Nocturna',
    'Pueblos',
    'Experiencias'
  ];
  final List<String> _budgets = [
    'Cualquier presupuesto',
    'Economico',
    'Moderado',
    'Premium'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _showEvents => _selectedCategory == 'Eventos';

  Future<void> _reload() async {
    if (_showEvents) {
      await context
          .read<EventProvider>()
          .cargarEventos(filtros: {'city': 'Medellin', 'featured': true});
      return;
    }

    final query = <String, dynamic>{'city': 'Medellin'};
    final category = AppCatalog.mapPlaceCategoryLabel(_selectedCategory);
    if (category != null)
      query['category'] = AppCatalog.placeCategoryToApi(category);
    if (_safeZoneOnly) query['safeZone'] = true;
    if (_searchController.text.trim().isNotEmpty)
      query['search'] = _searchController.text.trim();

    switch (_selectedBudget) {
      case 'Economico':
        query['maxPrice'] = 50000;
        break;
      case 'Moderado':
        query['maxPrice'] = 120000;
        break;
      case 'Premium':
        query['minPrice'] = 120000;
        break;
      case 'Cualquier presupuesto':
        break;
    }

    await context.read<PlaceProvider>().cargarLugares(filtros: query);
  }

  @override
  Widget build(BuildContext context) {
    final placeProvider = context.watch<PlaceProvider>();
    final eventProvider = context.watch<EventProvider>();
    final places = placeProvider.places;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Explorar'),
        actions: [
          if (!_showEvents)
            IconButton(
              icon: Icon(_isGridView
                  ? Icons.view_list_rounded
                  : Icons.grid_view_rounded),
              onPressed: () => setState(() => _isGridView = !_isGridView),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingM,
                vertical: AppConstants.paddingS),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar en Medellin y Antioquia...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: IconButton(
                    icon: const Icon(Icons.tune_rounded), onPressed: _reload),
              ),
              onSubmitted: (_) => _reload(),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
              itemCount: _categories.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AppChip(
                  label: _categories[i],
                  isSelected: _selectedCategory == _categories[i],
                  onTap: () {
                    setState(() => _selectedCategory = _categories[i]);
                    _reload();
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
              children: [
                _FilterChip(
                  label: _selectedBudget == 'Cualquier presupuesto'
                      ? 'Presupuesto'
                      : _selectedBudget,
                  isActive: _selectedBudget != 'Cualquier presupuesto',
                  onTap: () => _showBudgetSheet(context),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Zona segura',
                  isActive: _safeZoneOnly,
                  onTap: () {
                    setState(() => _safeZoneOnly = !_safeZoneOnly);
                    _reload();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingM, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _showEvents
                      ? '${eventProvider.events.length} eventos'
                      : '${places.length} resultados',
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500),
                ),
                if (placeProvider.error != null || eventProvider.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      placeProvider.error ?? eventProvider.error ?? '',
                      style:
                          const TextStyle(fontSize: 12, color: AppColors.error),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
              child: _showEvents
                  ? _buildEvents(eventProvider)
                  : (_isGridView
                      ? _buildGrid(context, places)
                      : _buildList(context, places))),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<PlaceModel> places) {
    if (context.watch<PlaceProvider>().isLoading)
      return const Center(child: CircularProgressIndicator());
    if (places.isEmpty) return _buildEmpty();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      itemCount: places.length,
      itemBuilder: (_, i) => PlaceCard(
          place: places[i],
          isHorizontal: true,
          onTap: () => context
              .go('${AppConstants.routePlaceDetail}?id=${places[i].id}')),
    );
  }

  Widget _buildGrid(BuildContext context, List<PlaceModel> places) {
    if (context.watch<PlaceProvider>().isLoading)
      return const Center(child: CircularProgressIndicator());
    if (places.isEmpty) return _buildEmpty();
    
    // Se calcula el aspect ratio de forma dinámica para evitar desbordes en terminales pequeñas
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - (AppConstants.paddingM * 2) - 14) / 2;
    final double aspectRatio = cardWidth / AppConstants.placeCardHeight;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: aspectRatio,
      ),
      itemCount: places.length,
      itemBuilder: (_, i) => PlaceCard(
          place: places[i],
          onTap: () => context
              .go('${AppConstants.routePlaceDetail}?id=${places[i].id}')),
    );
  }

  Widget _buildEvents(EventProvider provider) {
    if (provider.isLoading)
      return const Center(child: CircularProgressIndicator());
    if (provider.events.isEmpty) return _buildEmpty();
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      itemCount: provider.events.length,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: SizedBox(
            height: 190, child: EventCard(event: provider.events[index])),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 64, color: AppColors.textTertiary),
          SizedBox(height: 16),
          Text('Sin resultados',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          SizedBox(height: 8),
          Text('Intenta con otros filtros',
              style: TextStyle(color: AppColors.textTertiary)),
        ],
      ),
    );
  }

  void _showBudgetSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppConstants.radiusXXL))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Filtrar por presupuesto',
                style: Theme.of(context).textTheme.headlineSmall),
          ),
          ..._budgets.map((budget) => ListTile(
                title: Text(budget),
                trailing: _selectedBudget == budget
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _selectedBudget = budget);
                  Navigator.pop(context);
                  _reload();
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

  const _FilterChip(
      {required this.label, required this.isActive, required this.onTap});

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
              width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : AppColors.textPrimary),
        ),
      ),
    );
  }
}
