// ============================================
// SPLASH_SCREEN.DART (STRATEGY SEÇİMİ EKLENDİ)
// ============================================
// Değişiklikler:
// - Önce university_settings kontrol edilir
// - Ayar yoksa → UniversitySelectionScreen
// - Ayar varsa → HomeScreen
// ============================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/university_settings.dart';
import 'home_screen.dart';
import 'university_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();

    // ============================================
    // 2.5 SANİYE SONRA KONTROL ET
    // ============================================
    Future.delayed(const Duration(milliseconds: 6000), () {
      _kontrolEtVeYonlendir();
    });
  }

  // ============================================
  // AYAR KONTROLÜ VE YÖNLENDİRME
  // ============================================
  Future<void> _kontrolEtVeYonlendir() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString('university_settings');

    if (!mounted) return;

    if (settingsJson == null) {
      // ============================================
      // AYAR YOK → SEÇİM EKRANINA GİT
      // ============================================
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const UniversitySelectionScreen(
            isFirstSetup: true,
          ),
        ),
      );
    } else {
      // ============================================
      // AYAR VAR → ANA EKRANA GİT
      // ============================================
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LOGO
                    Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                  Icons.error); // fallback olarak ikon
                            },
                          ),
                        )),

                    const SizedBox(height: AppSpacing.xl),

                    const Text(
                      'AGNO Not Hesaplama',
                      style: TextStyle(
                        fontSize: AppTextSizes.title,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    const Text(
                      'Akademik ortalamanızı kolayca hesaplayın',
                      style: TextStyle(
                        fontSize: AppTextSizes.caption,
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    const SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
