import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/presentation/providers/auth_provider.dart';
import 'package:app_turismo/presentation/widgets/common_widgets.dart';

/// Pantalla de inicio de sesion.
/// Envia credenciales a `/api/auth/login` y sincroniza el usuario autenticado.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Iniciar sesion')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      AppColors.gradientStart,
                      AppColors.gradientEnd
                    ]),
                    borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bienvenido de vuelta',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800)),
                      SizedBox(height: 8),
                      Text(
                          'Guarda favoritos, sincroniza tus planes y usa el backend real de AppTurismo.',
                          style: TextStyle(color: Colors.white70, height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  decoration:
                      const InputDecoration(labelText: 'Correo electronico'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Ingresa tu correo'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Contrasena'),
                  obscureText: true,
                  validator: (value) => value == null || value.length < 8
                      ? 'Minimo 8 caracteres'
                      : null,
                ),
                const SizedBox(height: 12),
                if (authProvider.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(authProvider.error!,
                        style: const TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600)),
                  ),
                GradientButton(
                  label: 'Entrar',
                  isLoading: authProvider.isLoading,
                  icon: Icons.login_rounded,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final ok = await context.read<AuthProvider>().iniciarSesion(
                        _emailController.text.trim(),
                        _passwordController.text.trim());
                    if (!mounted) return;
                    if (ok) context.go(AppConstants.routeHome);
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => context.go(AppConstants.routeRegister),
                    child: const Text('Crear cuenta'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
