// ============================================
// GPA_CALCULATION_STRATEGY.DART
// ============================================

import 'package:flutter/material.dart';
import '../../core/constants/grade_values.dart';
import 'grade_calculation_strategy.dart';

class GpaCalculationStrategy implements GradeCalculationStrategy {
  @override
  String get name => 'Standart 4\'lük Sistem';

  @override
  String get description =>
      'Türkiye\'deki tüm üniversitelerin kullandığı sistem. '
      'Harf notu katsayısı ile ders ağırlığının çarpımı. '
      'Ağırlık olarak Kredi veya AKTS seçilebilir.';

  @override
  Map<String, double> get gradeValues => {
        for (var entry in harfNotuDegerleri.entries)
          if (entry.value != null) entry.key: entry.value!,
      };

  @override
  double calculateGANO(List<Map<String, dynamic>> dersler,
      {bool useAkts = false}) {
    double toplamPuan = 0.0;
    double toplamAgirlik = 0.0;

    for (var ders in dersler) {
      double kredi = (ders['kredi'] as num).toDouble();
      double? akts =
          ders['akts'] != null ? (ders['akts'] as num).toDouble() : null;
      String harfNotu = ders['harfNotu'] as String;

      double? katsayi = harfNotuDegerleri[harfNotu];
      if (katsayi == null) continue;

      double agirlik = useAkts ? (akts ?? kredi) : kredi;

      toplamPuan += katsayi * agirlik;
      toplamAgirlik += agirlik;
    }

    if (toplamAgirlik == 0) return 0.00;

    double gano = toplamPuan / toplamAgirlik;

    // ✅ AŞAĞI YUVARLAMA (floor to 2 decimals)
    // 3.295 -> 3.29, 3.77 -> 3.77
    return (gano * 100).floorToDouble() / 100;
  }

  @override
  Widget buildCourseForm({
    required BuildContext context,
    required TextEditingController nameController,
    required Function(double) onCreditChanged,
    required Function(String?) onGradeChanged,
    Function(double?)? onAktsChanged,
    double? initialCredit,
    String? initialGrade,
    double? initialAkts,
  }) {
    return _CourseForm(
      nameController: nameController,
      onCreditChanged: onCreditChanged,
      onGradeChanged: onGradeChanged,
      onAktsChanged: onAktsChanged,
      initialCredit: initialCredit,
      initialGrade: initialGrade,
      initialAkts: initialAkts,
    );
  }
}

class _CourseForm extends StatefulWidget {
  final TextEditingController nameController;
  final Function(double) onCreditChanged;
  final Function(String?) onGradeChanged;
  final Function(double?)? onAktsChanged;
  final double? initialCredit;
  final String? initialGrade;
  final double? initialAkts;

  const _CourseForm({
    required this.nameController,
    required this.onCreditChanged,
    required this.onGradeChanged,
    this.onAktsChanged,
    this.initialCredit,
    this.initialGrade,
    this.initialAkts,
  });

  @override
  State<_CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<_CourseForm> {
  late double _kredi;
  late String? _harfNotu;
  late double? _akts;

  final List<double> _krediSecenekleri = [
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
  void initState() {
    super.initState();
    _kredi = widget.initialCredit ?? 3.0;
    _harfNotu = widget.initialGrade;
    _akts = widget.initialAkts;

    widget.onCreditChanged(_kredi);
    if (_harfNotu != null) widget.onGradeChanged(_harfNotu);
    if (_akts != null) widget.onAktsChanged?.call(_akts);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.nameController,
          decoration: const InputDecoration(
            labelText: 'Ders Adı',
            prefixIcon: Icon(Icons.book),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<double>(
                value: _krediSecenekleri.contains(_kredi) ? _kredi : null,
                decoration: const InputDecoration(labelText: 'Kredi'),
                items: _krediSecenekleri.map((k) {
                  return DropdownMenuItem(
                    value: k,
                    child: Text(k == k.toInt() ? '${k.toInt()}' : '$k'),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _kredi = v);
                    widget.onCreditChanged(v);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String?>(
                value:
                    harfNotuDegerleri.containsKey(_harfNotu) ? _harfNotu : null,
                decoration: const InputDecoration(labelText: 'Harf Notu'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Seçilmedi')),
                  ...harfNotuDegerleri.keys.map((h) {
                    return DropdownMenuItem(value: h, child: Text(h));
                  }),
                ],
                onChanged: (v) {
                  setState(() => _harfNotu = v);
                  widget.onGradeChanged(v);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'AKTS (Opsiyonel)',
            hintText: 'Örn: 6.0',
            prefixIcon: Icon(Icons.public),
            helperText: 'Boş bırakırsanız Kredi kullanılır',
          ),
          controller: TextEditingController(text: _akts?.toString() ?? ''),
          onChanged: (v) {
            final akts = double.tryParse(v.replaceAll(',', '.'));
            setState(() => _akts = akts);
            widget.onAktsChanged?.call(akts);
          },
        ),
      ],
    );
  }
}
