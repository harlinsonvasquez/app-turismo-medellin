import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/data/mock/mock_places.dart';
import 'package:app_turismo/presentation/widgets/place_card.dart';
import 'package:app_turismo/presentation/widgets/common_widgets.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  String _sortBy = 'Distancia';
  final List<String> _sortOptions = ['Distancia', 'Calificación', 'Precio'];

  @override
  Widget build(BuildContext context) {
    var places = [...MockPlaces.nearbyPlaces];
    if (_sortBy == 'Calificación') {
      places.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == 'Precio') {
      places.sort((a, b) => a.pricePerPerson.compareTo(b.pricePerPerson));
    } else {
      places.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Cerca de mí')),
      body: Column(
        children: [
          // Map placeholder
          Container(
            height: 200,
            margin: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: const Color(0xFFD4E8C0),
              borderRadius: BorderRadius.circular(AppConstants.radiusXL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Fake map grid
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusXL),
                    child: CustomPaint(painter: _FakeMapPainter()),
                  ),
                ),
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
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.my_location_rounded,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(
                              AppConstants.radiusFull),
                        ),
                        child: const Text(
                          '📍 El Poblado, Medellín',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Place markers
                Positioned(
                  top: 50,
                  left: 60,
                  child: _MapMarker('🍽️'),
                ),
                Positioned(
                  top: 80,
                  right: 70,
                  child: _MapMarker('🏨'),
                ),
                Positioned(
                  bottom: 50,
                  left: 100,
                  child: _MapMarker('🗺️'),
                ),
              ],
            ),
          ),
          // Sort row
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingM),
            child: Row(
              children: [
                Text(
                  '${places.length} lugares cercanos',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Row(
                  children: _sortOptions.map((s) {
                    final sel = _sortBy == s;
                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: GestureDetector(
                        onTap: () => setState(() => _sortBy = s),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: sel
                                ? AppColors.primary
                                : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusFull),
                          ),
                          child: Text(
                            s,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
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
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Places list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingM),
              itemCount: places.length,
              itemBuilder: (_, i) => PlaceCard(
                place: places[i],
                isHorizontal: true,
                onTap: () => context.go(
                    '${AppConstants.routePlaceDetail}?id=${places[i].id}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  final String emoji;
  const _MapMarker(this.emoji);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
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
    // Horizontal streets
    for (int i = 1; i < 5; i++) {
      canvas.drawLine(
        Offset(0, size.height * i / 5),
        Offset(size.width, size.height * i / 5),
        paint,
      );
    }
    // Vertical streets
    for (int i = 1; i < 6; i++) {
      canvas.drawLine(
        Offset(size.width * i / 6, 0),
        Offset(size.width * i / 6, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
