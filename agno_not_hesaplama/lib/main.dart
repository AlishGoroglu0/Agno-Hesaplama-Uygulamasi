// ============================================
// MAIN.DART (GÜNCELLENMİŞ)
// ============================================
// Değişiklik: Theme kullanımı eklendi
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'presentation/screens/splash_screen.dart';
import 'providers/app_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        title: 'AGNO Not Hesaplama',
        debugShowCheckedModeBanner: false,
        // ============================================
        // TEMA: AppTheme kullanılıyor
        // ============================================
        theme: AppTheme.light,
        home: const SplashScreen(),
      ),
    );
  }
}
