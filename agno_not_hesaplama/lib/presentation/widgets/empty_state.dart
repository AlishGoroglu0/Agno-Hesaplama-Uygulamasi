// ============================================
// EMPTY_STATE.DART
// ============================================
// Boş liste durumunda gösterilen illüstrasyon widget'ı.
// Büyük animasyonlu ikon, başlık, açıklama ve opsiyonel buton içerir.
// ============================================

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  // ============================================
  // PARAMETRELER
  // ============================================
  final IconData icon; // Gösterilecek ikon
  final String title; // Başlık metni
  final String? description; // Açıklama metni (opsiyonel)
  final String? buttonLabel; // Buton metni (opsiyonel)
  final VoidCallback? onPressed; // Buton tıklama (opsiyonel)

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.buttonLabel,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ============================================
            // BÜYÜK İKON (Animasyonlu)
            // ============================================
            TweenAnimationBuilder<double>(
              // 0'dan 1'e scale animasyonu
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 60,
                      color: AppColors.primary.withOpacity(0.6),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: AppSpacing.lg),

            // ============================================
            // BAŞLIK
            // ============================================
            Text(
              title,
              style: const TextStyle(
                fontSize: AppTextSizes.subtitle,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            // ============================================
            // AÇIKLAMA (Varsa)
            // ============================================
            if (description != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                description!,
                style: const TextStyle(
                  fontSize: AppTextSizes.caption,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // ============================================
            // BUTON (Varsa)
            // ============================================
            if (buttonLabel != null && onPressed != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.add),
                label: Text(buttonLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
