// ============================================
// COURSE_ROW.DART (GÜNCELLENMİŞ)
// ============================================
// Değişiklikler:
// - strategy parametresi kaldırıldı
// - useAkts parametresi eklendi
// - calculateATKS kaldırıldı, GANO hesabı provider'dan geliyor
// ============================================

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/course_model.dart';

class CourseRow extends StatelessWidget {
  // ============================================
  // PARAMETRELER
  // ============================================
  final Course ders;
  final VoidCallback onTap;
  final bool useAkts; // YENİ

  const CourseRow({
    super.key,
    required this.ders,
    required this.onTap,
    this.useAkts = false, // Varsayılan: Kredi
  });

  @override
  Widget build(BuildContext context) {
    // Ağırlık değerini belirle
    final double agirlik = useAkts ? (ders.akts ?? ders.kredi) : ders.kredi;

    // Harf notu "YOK" mu kontrolü
    final bool etkisiz = ders.harfNotu == 'ETKİSİZ' ||
        ['G', 'K', 'M', 'B', 'Y', 'D'].contains(ders.harfNotu);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // ============================================
            // SOL: HARF NOTU ROZETİ
            // ============================================
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: etkisiz
                    ? Colors.grey.shade200
                    : _harfNotuRengi(ders.harfNotu).withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Center(
                child: Text(
                  etkisiz ? '--' : ders.harfNotu,
                  style: TextStyle(
                    fontSize: AppTextSizes.body,
                    fontWeight: FontWeight.bold,
                    color: etkisiz
                        ? AppColors.textSecondary
                        : _harfNotuRengi(ders.harfNotu),
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // ============================================
            // ORTA: DERS ADI + AĞIRLIK + AKTS
            // ============================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ders adı
                  Text(
                    ders.ad,
                    style: const TextStyle(
                      fontSize: AppTextSizes.body,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Ağırlık bilgisi
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      // Kredi rozeti
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          '${ders.kredi} Kredi',
                          style: const TextStyle(
                            fontSize: AppTextSizes.small,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // AKTS rozeti (eğer varsa ve farklıysa)
                      if (ders.akts != null && ders.akts != ders.kredi)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            '${ders.akts} AKTS',
                            style: const TextStyle(
                              fontSize: AppTextSizes.small,
                              color: AppColors.info,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      // Kullanılan ağırlık
                    ],
                  ),
                ],
              ),
            ),

            // ============================================
            // SAĞ: OK SİMGESİ
            // ============================================
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // HARF NOTUNA GÖRE RENK
  // ============================================
  Color _harfNotuRengi(String harfNotu) {
    switch (harfNotu) {
      case 'AA':
        return AppColors.gradeAA;
      case 'BA':
        return AppColors.gradeBA;
      case 'BB':
        return AppColors.gradeBB;
      case 'CB':
        return AppColors.gradeCB;
      case 'CC':
        return AppColors.gradeCC;
      case 'DC':
        return AppColors.gradeDC;
      case 'DD':
        return AppColors.gradeDD;
      case 'FD':
        return AppColors.gradeFD;
      case 'FF':
        return AppColors.gradeFF;
      default:
        return AppColors.gradeYOK;
    }
  }
}
