import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/presentation/providers/auth_provider.dart';
import 'package:app_turismo/presentation/widgets/common_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Crear cuenta')),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tu perfil turistico', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      SizedBox(height: 8),
                      Text('Registrate para guardar favoritos, persistir itinerarios y sincronizar tu experiencia.', style: TextStyle(color: AppColors.textSecondary, height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nombre completo'),
                  validator: (value) => value == null || value.isEmpty ? 'Ingresa tu nombre' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Correo electronico'),
                  validator: (value) => value == null || value.isEmpty ? 'Ingresa tu correo' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Contrasena'),
                  obscureText: true,
                  validator: (value) => value == null || value.length < 8 ? 'Minimo 8 caracteres' : null,
                ),
                const SizedBox(height: 12),
                if (authProvider.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(authProvider.error!, style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
                  ),
                GradientButton(
                  label: 'Crear cuenta',
                  isLoading: authProvider.isLoading,
                  icon: Icons.person_add_alt_1_rounded,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final ok = await context.read<AuthProvider>().register(
                          _nameController.text.trim(),
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                    if (!mounted) return;
                    if (ok) context.go(AppConstants.routeHome);
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => context.go(AppConstants.routeLogin),
                    child: const Text('Ya tengo cuenta'),
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
