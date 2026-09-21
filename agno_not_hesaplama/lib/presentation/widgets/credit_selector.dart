// ============================================
// CREDIT_SELECTOR.DART (GÜNCELLENMİŞ)
// ============================================
// Değişiklikler:
// - app_colors.dart yerine AppTheme kullanılıyor
// ============================================

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CreditSelector extends StatelessWidget {
  // ============================================
  // PARAMETRELER
  // ============================================
  final int value;
  final ValueChanged<int?> onChanged;
  final bool degisti;

  const CreditSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.degisti = false,
  });

  // Kredi seçenekleri
  static const List<int> _secenekler = [1, 2, 3, 4, 5, 6, 7, 8];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: degisti
            ? AppColors.primary.withOpacity(0.05)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: degisti
              ? AppColors.primary.withOpacity(0.3)
              : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kredi',
            style: TextStyle(
              fontSize: AppTextSizes.small,
              color: degisti ? AppColors.primary : AppColors.textSecondary,
              fontWeight: degisti ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              items: _secenekler.map((kredi) {
                return DropdownMenuItem<int>(
                  value: kredi,
                  child: Text('$kredi Kredi'),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}