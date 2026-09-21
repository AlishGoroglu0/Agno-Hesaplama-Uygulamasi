// ============================================
// SEMESTER_CARD.DART (GÜNCELLENMİŞ)
// ============================================
// Değişiklikler:
// - provider.calculateGano() kullanılıyor
// - GradeCalculator import'u kaldırıldı
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/semester_model.dart';
import '../../providers/app_provider.dart';

class SemesterCard extends StatelessWidget {
  final Semester donem;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const SemesterCard({
    super.key,
    required this.donem,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final List<Map<String, dynamic>> derslerMap = donem.dersler
            .map((ders) => {
                  'kredi': ders.kredi,
                  'harfNotu': ders.harfNotu,
                  'akts': ders.akts,
                })
            .toList();

        double donemOrtalamasi = 0.0;
        if (derslerMap.isNotEmpty) {
          donemOrtalamasi = provider.calculateGano(derslerMap);
        }

        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            onTap: onTap,
            onLongPress: onLongPress,
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: const Icon(Icons.calendar_today, color: AppColors.primary),
            ),
            title: Text(
              donem.ad,
              style: const TextStyle(
                fontSize: AppTextSizes.subtitle,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${donem.dersler.length} ders',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                if (donem.dersler.isNotEmpty)
                  Text(
                    'Ortalama: ${donemOrtalamasi.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ),
        );
      },
    );
  }
}