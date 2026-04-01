import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:app_turismo/core/constants/app_constants.dart';
import 'package:app_turismo/core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      label: 'MAP',
      title: 'Descubre lugares\ncercanos a ti',
      subtitle:
          'Explora hoteles, restaurantes, sitios turisticos y experiencias unicas en Medellin y Antioquia.',
      bgColor: AppColors.primary,
      accentColor: AppColors.primaryLight,
    ),
    _OnboardingPage(
      label: 'PLAN',
      title: 'Planes segun tu\npresupuesto y dias',
      subtitle:
          'Genera itinerarios personalizados en segundos. Viaja a tu medida, sin complicaciones.',
      bgColor: Color(0xFF1A9E50),
      accentColor: Color(0xFF2ECC71),
    ),
    _OnboardingPage(
      label: 'SAFE',
      title: 'Viaja mas seguro\ncon recomendaciones locales',
      subtitle:
          'Accede a tips de seguridad, zonas recomendadas y alertas de turistas que ya recorrieron la ciudad.',
      bgColor: Color(0xFFB7500A),
      accentColor: AppColors.accent,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.animMedium,
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppConstants.routeLocationPermission);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = _pages[_currentPage];

    return Scaffold(
      body: AnimatedContainer(
        duration: AppConstants.animMedium,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [currentPage.bgColor, currentPage.accentColor],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingL,
                    vertical: AppConstants.paddingS),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'AppTurismo',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                    if (_currentPage < _pages.length - 1)
                      TextButton(
                        onPressed: () =>
                            context.go(AppConstants.routeLocationPermission),
                        child: const Text(
                          'Omitir',
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (_, index) => _buildPage(_pages[index]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _pages.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: Colors.white,
                        dotColor: Colors.white.withOpacity(0.3),
                        dotHeight: 8,
                        dotWidth: 8,
                        expansionFactor: 3,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: currentPage.bgColor,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusL),
                          ),
                        ),
                        child: Text(
                          _currentPage < _pages.length - 1
                              ? 'Siguiente'
                              : 'Comenzar ahora',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final illustrationSize = constraints.maxWidth * 0.55;

        return Stack(
          children: [
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
            ),
            Positioned(
              top: constraints.maxHeight * 0.1,
              left: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                  AppConstants.paddingXL, 24, AppConstants.paddingXL, 24),
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: constraints.maxHeight - 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: illustrationSize,
                      height: illustrationSize,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          page.label,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: illustrationSize * 0.18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      page.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      page.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OnboardingPage {
  final String label;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color accentColor;

  const _OnboardingPage({
    required this.label,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.accentColor,
  });
}
