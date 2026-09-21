// ============================================
// UNIVERSITY_SELECTION_SCREEN.DART (GÜNCELLENMİŞ)
// ============================================
// Değişiklikler:
// - Strateji seçimi kaldırıldı
// - "Kredi ile hesapla" / "AKTS ile hesapla" seçimi eklendi
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../core/theme/app_theme.dart';
import '../../data/models/university_settings.dart';
import '../../providers/app_provider.dart';
import 'home_screen.dart';

class UniversitySelectionScreen extends StatefulWidget {
  final bool isFirstSetup;

  const UniversitySelectionScreen({
    super.key,
    this.isFirstSetup = true,
  });

  @override
  State<UniversitySelectionScreen> createState() =>
      _UniversitySelectionScreenState();
}

class _UniversitySelectionScreenState extends State<UniversitySelectionScreen> {
  bool? _useAkts; // null = seçilmedi, false = Kredi, true = AKTS

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesaplama Sistemi'),
        automaticallyImplyLeading: !widget.isFirstSetup,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Açıklama
            const Text(
              'Ortalamanızı hangi değere göre hesaplayalım?',
              style: TextStyle(
                fontSize: AppTextSizes.subtitle,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Üniversitenizin kullandığı sistemi seçin. '
              'Kredi ve AKTS değerlerini ders eklerken ayrı ayrı girebilirsiniz.',
              style: TextStyle(
                fontSize: AppTextSizes.caption,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Kredi seçeneği
            _secenekKarti(
              baslik: 'Kredi ile Hesapla',
              aciklama:
                  'Türkiye\'deki çoğu üniversite (ODTÜ, İTÜ, Boğaziçi, vs.)',
              secili: _useAkts == false,
              onTap: () => setState(() => _useAkts = false),
            ),

            const SizedBox(height: AppSpacing.md),

            // AKTS seçeneği
            _secenekKarti(
              baslik: 'AKTS ile Hesapla',
              aciklama:
                  'Avrupa standartı, bazı üniversiteler (İstanbul Üni., vs.)',
              secili: _useAkts == true,
              onTap: () => setState(() => _useAkts = true),
            ),

            const Spacer(),

            // Devam butonu
            if (_useAkts != null)
              ElevatedButton(
                onPressed: _kaydetVeDevam,
                child: const Text('Devam Et'),
              ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // SEÇENEK KARTI
  // ============================================
  Widget _secenekKarti({
    required String baslik,
    required String aciklama,
    required bool secili,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: secili ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: secili ? AppColors.primary : Colors.grey.shade300,
          width: secili ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Seçim dairesi
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: secili ? AppColors.primary : AppColors.textHint,
                    width: 2,
                  ),
                  color: secili ? AppColors.primary : Colors.transparent,
                ),
                child: secili
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.md),
              // Bilgiler
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      baslik,
                      style: const TextStyle(
                        fontSize: AppTextSizes.body,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      aciklama,
                      style: const TextStyle(
                        fontSize: AppTextSizes.caption,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================
  // KAYDET VE DEVAM ET
  // ============================================
  Future<void> _kaydetVeDevam() async {
    if (_useAkts == null) return;

    // Ayarları oluştur
    final settings = UniversitySettings(
      strategyKey: 'gpa',
      useAkts: _useAkts!,
    );

    // SharedPreferences'a kaydet
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'university_settings',
      jsonEncode(settings.toJson()),
    );

    // Provider'ı güncelle
    if (mounted) {
      await Provider.of<AppProvider>(context, listen: false)
          .setUseAkts(_useAkts!);
    }

    if (mounted) {
      if (widget.isFirstSetup) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        Navigator.pop(context);
      }
    }
  }
}
