// ============================================
// APP_THEME.DART
// ============================================
// Uygulamanın genel tema ayarları.
// Renkler, yazı boyutları, border radius'lar, gölgeler burada tanımlanır.
// Tüm uygulamada tutarlılık sağlar.
// ============================================

import 'package:flutter/material.dart';

// ============================================
// RENKLER
// ============================================
class AppColors {
  // Ana tema rengi
  static const Color primary = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF63A4FF);
  static const Color primaryDark = Color(0xFF004BA0);

  // Arka plan renkleri
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color card = Colors.white;

  // Metin renkleri
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);

  // Durum renkleri
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // Harf notu renkleri
  static const Color gradeAA = Color(0xFF4CAF50);
  static const Color gradeBA = Color(0xFF66BB6A);
  static const Color gradeBB = Color(0xFF1976D2);
  static const Color gradeCB = Color(0xFF42A5F5);
  static const Color gradeCC = Color(0xFFFFA726);
  static const Color gradeDC = Color(0xFFFF9800);
  static const Color gradeDD = Color(0xFFFF7043);
  static const Color gradeFD = Color(0xFFE53935);
  static const Color gradeFF = Color(0xFFC62828);
  static const Color gradeYOK = Color(0xFF9E9E9E);
}

// ============================================
// YAZI BOYUTLARI
// ============================================
class AppTextSizes {
  static const double headline = 48.0; // Büyük GANO sayısı
  static const double title = 24.0; // Başlık
  static const double subtitle = 18.0; // Alt başlık
  static const double body = 16.0; // Normal metin
  static const double caption = 14.0; // Açıklama
  static const double small = 12.0; // Küçük metin
}

// ============================================
// BOŞLUKLAR (Padding / Margin)
// ============================================
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

// ============================================
// BORDER RADIUS
// ============================================
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
}

// ============================================
// GÖLGELER
// ============================================
class AppShadows {
  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 16,
          offset: const Offset(0, 8),
          spreadRadius: 2,
        ),
      ];
}

// ============================================
// UYGULAMA TEMASI
// ============================================
class AppTheme {
  // ============================================
  // LIGHT TEMA
  // ============================================
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Renk şeması
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.primaryLight,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: Colors.white,
      ),

      // Scaffold arka planı
      scaffoldBackgroundColor: AppColors.background,

      // AppBar teması
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Kart teması — eski sürüm uyumlu
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ).data,

      // Buton temaları
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      // InputDecoration teması
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
      ),

      // SnackBar teması
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}
