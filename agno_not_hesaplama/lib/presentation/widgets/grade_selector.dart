// ============================================
// GRADE_SELECTOR.DART
// ============================================

import 'package:flutter/material.dart';
import '../../core/constants/grade_values.dart';
import '../../core/theme/app_theme.dart';

class GradeSelector extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool degisti;

  const GradeSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.degisti = false,
  });

  @override
  Widget build(BuildContext context) {
    final String? dropdownValue =
        harfNotuDegerleri.containsKey(value) ? value : null;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: degisti ? AppColors.success.withAlpha(13) : Colors.grey.shade50,
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
            'Harf Notu',
            style: TextStyle(
              fontSize: AppTextSizes.small,
              color: degisti ? AppColors.primary : AppColors.textSecondary,
              fontWeight: degisti ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: dropdownValue,
              isExpanded: true,
              items: [
                const DropdownMenuItem(value: null, child: Text('Seçilmedi')),
                ...harfNotuDegerleri.keys.map((harf) {
                  final deger = harfNotuDegerleri[harf];
                  return DropdownMenuItem<String?>(
                    value: harf,
                    child: Text(
                      deger != null
                          ? '$harf (${deger.toStringAsFixed(2)})'
                          : harf,
                      style: TextStyle(
                        color: deger == null
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        fontStyle:
                            deger == null ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  );
                }),
              ],
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
