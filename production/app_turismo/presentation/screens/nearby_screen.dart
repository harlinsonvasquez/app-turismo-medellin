import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/presentation/providers/place_provider.dart';
import 'package:app_turismo/presentation/widgets/place_card.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  String _sortBy = 'Distancia';
  final List<String> _sortOptions = ['Distancia', 'Calificacion', 'Precio'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaceProvider>().loadPlaces(query: {
        'city': 'Medellin',
        'latitude': AppConstants.defaultLat,
        'longitude': AppConstants.defaultLng,
        'radiusKm': 8,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlaceProvider>();
    final places = [...provider.places];
    if (_sortBy == 'Calificacion') {
      places.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == 'Precio') {
      places.sort((a, b) => a.pricePerPerson.compareTo(b.pricePerPerson));
    } else {
      places.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Cerca de mi')),
      body: Column(
        children: [
          Container(
            height: 200,
            margin: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: const Color(0xFFD4E8C0),
              borderRadius: BorderRadius.circular(AppConstants.radiusXL),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                    child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusXL),
                        child: CustomPaint(painter: _FakeMapPainter()))),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 16,
                                  spreadRadius: 4)
                            ]),
                        child: const Icon(Icons.my_location_rounded,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusFull)),
                        child: const Text('?? Medellin centro',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: AppColors.textPrimary)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 540;
                final chips = SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _sortOptions.map((option) {
                      final selected = _sortBy == option;
                      return Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: GestureDetector(
                          onTap: () => setState(() => _sortBy = option),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusFull)),
                            child: Text(option,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: selected
                                        ? Colors.white
                                        : AppColors.textPrimary)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );

                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${places.length} lugares cercanos',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      chips,
                    ],
                  );
                }

                return Row(
                  children: [
                    Text('${places.length} lugares cercanos',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    const Spacer(),
                    SizedBox(width: constraints.maxWidth * 0.45, child: chips),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingM),
                    itemCount: places.length,
                    itemBuilder: (_, i) => PlaceCard(
                        place: places[i],
                        isHorizontal: true,
                        onTap: () => context.go(
                            '${AppConstants.routePlaceDetail}?id=${places[i].id}')),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FakeMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBCE0A0)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    for (int i = 1; i < 5; i++) {
      canvas.drawLine(Offset(0, size.height * i / 5),
          Offset(size.width, size.height * i / 5), paint);
    }
    for (int i = 1; i < 6; i++) {
      canvas.drawLine(Offset(size.width * i / 6, 0),
          Offset(size.width * i / 6, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
