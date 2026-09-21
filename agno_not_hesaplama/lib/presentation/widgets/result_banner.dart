// ============================================
// RESULT_BANNER.DART
// ============================================
// GANO sonucunu gösteren banner kart widget'ı.
// Mevcut GANO, Yeni GANO ve fark gösterir.
// ============================================

import 'package:agno_not_hesaplama/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ResultBanner extends StatelessWidget {
  // ============================================
  // PARAMETRELER
  // ============================================
  final double mevcutAgno;
  final double yeniAgno;

  const ResultBanner({
    super.key,
    required this.mevcutAgno,
    required this.yeniAgno,
  });

  @override
  Widget build(BuildContext context) {
    // ============================================
    // FARK HESAPLA
    // ============================================
    final fark = yeniAgno - mevcutAgno;

    // Fark rengi
    Color farkRengi;
    String farkIsareti;
    if (fark > 0) {
      farkRengi = AppColors.success;
      farkIsareti = '+';
    } else if (fark < 0) {
      farkRengi = AppColors.error;
      farkIsareti = '';
    } else {
      farkRengi = AppColors.textSecondary;
      farkIsareti = '';
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Mevcut vs Yeni
          Row(
            children: [
              Expanded(
                child: _ozetKutu(
                  baslik: 'Mevcut AGNO',
                  deger: mevcutAgno.toStringAsFixed(2),
                  renk: AppColors.textSecondary,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child:
                    Icon(Icons.arrow_forward, color: AppColors.textSecondary),
              ),
              Expanded(
                child: _ozetKutu(
                  baslik: 'Yeni AGNO',
                  deger: yeniAgno.toStringAsFixed(2),
                  renk: AppColors.primary,
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          // Fark
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Fark: ',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '$farkIsareti${fark.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: farkRengi,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================
  // ÖZET KUTU
  // ============================================
  Widget _ozetKutu({
    required String baslik,
    required String deger,
    required Color renk,
  }) {
    return Column(
      children: [
        Text(
          baslik,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          deger,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: renk,
          ),
        ),
      ],
    );
  }
}
