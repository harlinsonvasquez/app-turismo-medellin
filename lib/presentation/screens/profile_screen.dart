import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/data/mock/mock_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'Español';

  @override
  Widget build(BuildContext context) {
    final user = MockUser.mockUser;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text('👤', style: TextStyle(fontSize: 36)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            title: const Text(
              'Mi perfil',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      _StatBadge(
                        value: '${user.savedPlaceIds.length}',
                        label: 'Lugares\nguardados',
                      ),
                      const SizedBox(width: 10),
                      _StatBadge(
                        value: '${user.savedPlanIds.length}',
                        label: 'Itinerarios\ncreados',
                      ),
                      const SizedBox(width: 10),
                      _StatBadge(
                        value: '${user.interests.length}',
                        label: 'Intereses\nconfigurados',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Interests
                  _SectionTitle('❤️ Mis intereses'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: user.interests
                        .map((i) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusFull),
                                border: Border.all(
                                  color:
                                      AppColors.primary.withOpacity(0.2),
                                ),
                              ),
                              child: Text(i,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  )),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle('⚙️ Configuración'),
                  const SizedBox(height: 10),
                  _SettingsCard(children: [
                    _SettingsTile(
                      icon: '💰',
                      title: 'Estilo de presupuesto',
                      value: user.budgetStyle,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: '🌐',
                      title: 'Idioma',
                      value: _selectedLanguage,
                      onTap: () => _showLanguageSheet(context),
                    ),
                    _SwitchTile(
                      icon: '🔔',
                      title: 'Notificaciones',
                      value: _notificationsEnabled,
                      onChanged: (v) =>
                          setState(() => _notificationsEnabled = v),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _SectionTitle('📱 Cuenta'),
                  const SizedBox(height: 10),
                  _SettingsCard(children: [
                    _SettingsTile(
                      icon: '❓',
                      title: 'Ayuda y soporte',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: '📄',
                      title: 'Términos y privacidad',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: '⭐',
                      title: 'Calificar la app',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 16),
                  // Business CTA
                  GestureDetector(
                    onTap: () => context.go(AppConstants.routeBusinessPromo),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFB7500A),
                            AppColors.accent,
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusXL),
                      ),
                      child: Row(
                        children: const [
                          Text('🏢', style: TextStyle(fontSize: 32)),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '¿Tienes un negocio?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Promovemos tu hotel, restaurante o experiencia',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.white70, size: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    final langs = ['Español', 'English', 'Português', 'Français', 'Deutsch'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppConstants.radiusXXL)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Selecciona idioma',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ...langs.map((l) => ListTile(
                title: Text(l),
                trailing: _selectedLanguage == l
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _selectedLanguage = l);
                  Navigator.pop(context);
                },
              )),
          const SizedBox(height: 20),
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
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .headlineSmall
          ?.copyWith(fontWeight: FontWeight.w700),
    );
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
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textTertiary,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
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
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.04),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: children.asMap().entries.map((e) {
          return Column(
            children: [
              e.value,
              if (e.key < children.length - 1)
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
  final String? value;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(icon,
          style: const TextStyle(fontSize: 22)),
      title: Text(title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: value != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textTertiary,
                    )),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right,
                    color: AppColors.textTertiary, size: 18),
              ],
            )
          : const Icon(Icons.chevron_right,
              color: AppColors.textTertiary, size: 18),
      onTap: onTap,
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 22)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }
}
