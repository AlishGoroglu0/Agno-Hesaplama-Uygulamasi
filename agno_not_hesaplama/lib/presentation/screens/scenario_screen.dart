// ============================================
// SCENARIO_SCREEN.DART (GÜNCELLENMİŞ)
// ============================================
// Değişiklikler:
// - provider.calculateGano() kullanılıyor
// - GradeCalculator import'u kaldırıldı
// - _SenaryoDers kredi double oldu
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/semester_model.dart';
import '../../providers/app_provider.dart';
import '../widgets/result_banner.dart';
import '../widgets/grade_selector.dart';

class ScenarioScreen extends StatefulWidget {
  final Semester donem;

  const ScenarioScreen({
    super.key,
    required this.donem,
  });

  @override
  State<ScenarioScreen> createState() => _ScenarioScreenState();
}

class _ScenarioScreenState extends State<ScenarioScreen> {
  late List<_SenaryoDers> _senaryoDersler;

  @override
  void initState() {
    super.initState();

    _senaryoDersler = widget.donem.dersler.map((ders) {
      return _SenaryoDers(
        ad: ders.ad,
        kredi: ders.kredi,
        harfNotu: ders.harfNotu == 'YOK' ? 'ETKİSİZ' : ders.harfNotu,
        akts: ders.akts,
      );
    }).toList();
  }

  void _tumunuSifirla() {
    setState(() {
      for (int i = 0; i < _senaryoDersler.length; i++) {
        _senaryoDersler[i] = _SenaryoDers(
          ad: widget.donem.dersler[i].ad,
          kredi: widget.donem.dersler[i].kredi,
          harfNotu: widget.donem.dersler[i].harfNotu,
          akts: widget.donem.dersler[i].akts,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        // Mevcut ortalamayı hesapla
        final mevcutMap = widget.donem.dersler
            .map((d) => {
                  'kredi': d.kredi,
                  'harfNotu': d.harfNotu,
                  'akts': d.akts,
                })
            .toList();
        final mevcutOrtalama =
            mevcutMap.isNotEmpty ? provider.calculateGano(mevcutMap) : 0.0;

        // Senaryo ortalamasını hesapla
        final senaryoMap = _senaryoDersler
            .map((d) => {
                  'kredi': d.kredi,
                  'harfNotu': d.harfNotu,
                  'akts': d.akts,
                })
            .toList();
        final senaryoOrtalama =
            senaryoMap.isNotEmpty ? provider.calculateGano(senaryoMap) : 0.0;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Senaryo'),
          ),
          body: Column(
            children: [
              // ============================================
              // RESULTBANNER: Mevcut vs Yeni GANO + Fark
              // ============================================
              ResultBanner(
                mevcutAgno: mevcutOrtalama,
                yeniAgno: senaryoOrtalama,
              ),

              // ============================================
              // DERS LİSTESİ BAŞLIĞI
              // ============================================
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    const Text(
                      'Dersleri Düzenle',
                      style: TextStyle(
                        fontSize: AppTextSizes.subtitle,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _tumunuSifirla,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Sıfırla'),
                    ),
                  ],
                ),
              ),

              // ============================================
              // DERS LİSTESİ
              // ============================================
              Expanded(
                child: _senaryoDersler.isEmpty
                    ? _bosListeMesaji()
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: _senaryoDersler.length,
                        itemBuilder: (context, index) {
                          return _senaryoDersKarti(index, provider);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================
  // SENARYO DERS KARTI
  // ============================================
  Widget _senaryoDersKarti(int index, AppProvider provider) {
    final ders = _senaryoDersler[index];

    // Değişiklik kontrolü
    final bool degistiAd = ders.ad != widget.donem.dersler[index].ad;
    final bool degistiKredi = ders.kredi != widget.donem.dersler[index].kredi;
    final bool degistiHarf =
        ders.harfNotu != widget.donem.dersler[index].harfNotu;
    final bool herhangiDegisti = degistiAd || degistiKredi || degistiHarf;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: herhangiDegisti ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: herhangiDegisti
            ? BorderSide(
                color: AppColors.primary.withOpacity(0.5),
                width: 1.5,
              )
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ders Adı
            TextField(
              controller: TextEditingController(text: ders.ad),
              onChanged: (yeniAd) {
                setState(() {
                  _senaryoDersler[index].ad = yeniAd;
                });
              },
              decoration: InputDecoration(
                labelText: 'Ders Adı',
                prefixIcon: const Icon(Icons.book),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                filled: true,
                fillColor: degistiAd
                    ? AppColors.primary.withOpacity(0.05)
                    : Colors.grey.shade50,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Kredi ve Harf Notu
            Row(
              children: [
                // Kredi (artık double, CreditSelector güncellenmeli)
                Expanded(
                  child: _DoubleCreditSelector(
                    value: ders.kredi,
                    degisti: degistiKredi,
                    onChanged: (yeniKredi) {
                      if (yeniKredi != null) {
                        setState(() {
                          _senaryoDersler[index].kredi = yeniKredi;
                        });
                      }
                    },
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                // Harf Notu
                Expanded(
                  child: GradeSelector(
                    value: ders.harfNotu,
                    degisti: degistiHarf,
                    onChanged: (yeniHarf) {
                      setState(() {
                        _senaryoDersler[index].harfNotu = yeniHarf ?? 'YOK';
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // BOŞ LİSTE MESAJI
  // ============================================
  Widget _bosListeMesaji() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.psychology_outlined,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Ders yok, senaryo yapılamaz',
            style: TextStyle(
              fontSize: AppTextSizes.body,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// YARDIMCI CLASS
// ============================================
class _SenaryoDers {
  String ad;
  double kredi; // int → double
  String harfNotu;
  double? akts; // int? → double?

  _SenaryoDers({
    required this.ad,
    required this.kredi,
    required this.harfNotu,
    this.akts,
  });
}

// ============================================
// DOUBLE CREDIT SELECTOR (Geçici - CreditSelector güncellenene kadar)
// ============================================
class _DoubleCreditSelector extends StatelessWidget {
  final double value;
  final ValueChanged<double?> onChanged;
  final bool degisti;

  const _DoubleCreditSelector({
    required this.value,
    required this.onChanged,
    this.degisti = false,
  });

  static const List<double> _secenekler = [
    1.0,
    1.5,
    2.0,
    2.5,
    3.0,
    3.5,
    4.0,
    4.5,
    5.0,
    6.0,
    7.0,
    8.0
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color:
            degisti ? AppColors.primary.withOpacity(0.05) : Colors.grey.shade50,
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
            child: DropdownButton<double>(
              value: _secenekler.contains(value) ? value : null,
              isExpanded: true,
              items: _secenekler.map((k) {
                return DropdownMenuItem(
                  value: k,
                  child: Text(k == k.toInt() ? '${k.toInt()}' : '$k'),
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
