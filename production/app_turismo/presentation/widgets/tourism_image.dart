import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:app_turismo/core/theme/app_theme.dart';

/// Renderiza imagenes obtenidas del backend y aplica un fallback consistente
/// cuando la URL no existe, llega vacia o falla la descarga.
class ImagenTuristica extends StatelessWidget {
  const ImagenTuristica({
    super.key,
    required this.imageUrl,
    required this.placeholderIcon,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.placeholderLabel,
  });

  final String? imageUrl;
  final IconData placeholderIcon;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final String? placeholderLabel;

  bool get _tieneUrlValida => imageUrl != null && imageUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: _tieneUrlValida
            ? CachedNetworkImage(
                imageUrl: imageUrl!.trim(),
                fit: fit,
                placeholder: (_, __) => _PlaceholderImagenTuristica(
                  icono: placeholderIcon,
                  etiqueta: placeholderLabel,
                  mostrarCarga: true,
                ),
                errorWidget: (_, __, ___) => _PlaceholderImagenTuristica(
                  icono: placeholderIcon,
                  etiqueta: placeholderLabel,
                ),
              )
            : _PlaceholderImagenTuristica(
                icono: placeholderIcon,
                etiqueta: placeholderLabel,
              ),
      ),
    );
  }
}

class _PlaceholderImagenTuristica extends StatelessWidget {
  const _PlaceholderImagenTuristica({
    required this.icono,
    this.etiqueta,
    this.mostrarCarga = false,
  });

  final IconData icono;
  final String? etiqueta;
  final bool mostrarCarga;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (mostrarCarga) ...[
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
          ] else ...[
            Icon(icono, size: 30, color: AppColors.textTertiary),
            if (etiqueta != null) ...[
              const SizedBox(height: 8),
              Text(
                etiqueta!,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ],
      ),
    );
  }
}
