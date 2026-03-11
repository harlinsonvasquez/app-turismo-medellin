import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/core/theme/app_theme.dart';
import 'package:app_turismo/presentation/providers/membership_provider.dart';
import 'package:app_turismo/presentation/widgets/specialized_widgets.dart';

class BusinessPromoScreen extends StatefulWidget {
  const BusinessPromoScreen({super.key});

  @override
  State<BusinessPromoScreen> createState() => _BusinessPromoScreenState();
}

class _BusinessPromoScreenState extends State<BusinessPromoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<MembershipProvider>().loadPlans());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MembershipProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Promueve tu negocio')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFB7500A), AppColors.accent]),
                borderRadius: BorderRadius.circular(AppConstants.radiusXL),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Llega a mas turistas en Medellin', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                  SizedBox(height: 8),
                  Text('Los planes y beneficios ahora vienen directamente del backend y quedan listos para un panel web futuro.', style: TextStyle(color: Colors.white70, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Planes de membresia', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ...provider.plans.map((plan) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: MembershipPlanCard(
                      plan: plan,
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Seleccionaste ${plan.name}. Integracion comercial lista para el siguiente paso.'))),
                    ),
                  )),
            if (provider.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(provider.error!, style: const TextStyle(color: AppColors.error)),
              ),
          ],
        ),
      ),
    );
  }
}
