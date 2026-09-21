// ============================================
// AVERAGE_CARD.DART (GÜNCELLENMİŞ)
// ============================================
// Değişiklikler:
// - app_colors.dart yerine AppTheme kullanılıyor
// ============================================

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AverageCard extends StatelessWidget {
  // ============================================
  // PARAMETRELER
  // ============================================
  final String baslik;
  final double ortalama;
  final double? fontSize; // Opsiyonel

  const AverageCard({
    super.key,
    required this.baslik,
    required this.ortalama,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    // ============================================
    // ORTALAMAYA GÖRE RENK
    // ============================================
    Color renk;
    if (ortalama >= 3.0) {
      renk = AppColors.success;
    } else if (ortalama >= 2.0) {
      renk = AppColors.warning;
    } else if (ortalama > 0) {
      renk = AppColors.error;
    } else {
      renk = AppColors.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Text(
            baslik,
            style: const TextStyle(
              fontSize: AppTextSizes.body,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            ortalama > 0 ? ortalama.toStringAsFixed(2) : '--',
            style: TextStyle(
              fontSize: fontSize ?? AppTextSizes.headline,
              fontWeight: FontWeight.bold,
              color: renk,
            ),
          ),
        ],
      ),
    );
  }
}