import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/presentation/providers/auth_provider.dart';
import 'package:app_turismo/presentation/providers/favorites_provider.dart';
import 'package:app_turismo/presentation/providers/itinerary_provider.dart';

/// Resume el estado del usuario autenticado y los accesos a flujos
/// personales como guardados, seguridad y cierre de sesion.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [AppColors.primaryDark, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3)),
                        child: const Center(
                            child: Text('??', style: TextStyle(fontSize: 36))),
                      ),
                      const SizedBox(height: 12),
                      Text(user?.name ?? 'Invitado',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(
                          user?.email ??
                              'Inicia sesion para sincronizar tu viaje',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
            title:
                const Text('Mi perfil', style: TextStyle(color: Colors.white)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!auth.isAuthenticated) ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusL)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Activa tu cuenta',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          const Text(
                              'Necesitas iniciar sesion para guardar favoritos y persistir tus itinerarios.'),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                  child: ElevatedButton(
                                      onPressed: () =>
                                          context.go(AppConstants.routeLogin),
                                      child: const Text('Iniciar sesion'))),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: OutlinedButton(
                                      onPressed: () => context
                                          .go(AppConstants.routeRegister),
                                      child: const Text('Crear cuenta'))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Row(
                      children: [
                        _StatBadge(value: user!.role, label: 'Rol actual'),
                        const SizedBox(width: 10),
                        _StatBadge(
                            value: user.active ? 'Activo' : 'Inactivo',
                            label: 'Estado'),
                        const SizedBox(width: 10),
                        const _StatBadge(value: 'JWT', label: 'Sesion real'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const _SectionTitle('Cuenta'),
                    const SizedBox(height: 10),
                    _SettingsCard(children: [
                      _SettingsTile(
                          icon: '??',
                          title: 'Mis guardados',
                          onTap: () => context.go(AppConstants.routeSaved)),
                      _SettingsTile(
                          icon: '???',
                          title: 'Consejos de seguridad',
                          onTap: () => context.go(AppConstants.routeSafety)),
                      _SettingsTile(
                          icon: '??',
                          title: 'Promover mi negocio',
                          onTap: () =>
                              context.go(AppConstants.routeBusinessPromo)),
                      _SettingsTile(
                        icon: '??',
                        title: 'Cerrar sesion',
                        onTap: () async {
                          await context.read<AuthProvider>().cerrarSesion();
                          await context
                              .read<FavoritesProvider>()
                              .limpiarSesion();
                          context.read<ItineraryProvider>().clearSessionData();
                          if (context.mounted) {
                            context.go(AppConstants.routeHome);
                          }
                        },
                      ),
                    ]),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(fontWeight: FontWeight.w700));
  }
}

class _StatBadge extends StatelessWidget {
  final String value;
  final String label;
  const _StatBadge({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusL)),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary),
                textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textTertiary, height: 1.3),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusL)),
      child: Column(
        children: children.asMap().entries.map((entry) {
          return Column(
            children: [
              entry.value,
              if (entry.key < children.length - 1)
                const Divider(height: 1, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback? onTap;

  const _SettingsTile({required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 22)),
      title: Text(title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right,
          color: AppColors.textTertiary, size: 18),
      onTap: onTap,
    );
  }
}
