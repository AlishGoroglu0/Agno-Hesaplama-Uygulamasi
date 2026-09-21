// ============================================
// GRADE_CALCULATION_STRATEGY.DART (GÜNCELLENMİŞ)
// ============================================
// Değişiklikler:
// - calculateATKS, calculateCredit, convertHundredToLetter KALDIRILDI
// - Sadece calculateGANO ve buildCourseForm kaldı
// - gradeValues sabit (tüm stratejiler aynı harf notlarını kullanır)
// ============================================

import 'package:flutter/material.dart';

// ============================================
// HARF NOTU DEĞERLERİ (Global - Tüm stratejiler aynı)
// ============================================
const Map<String, double> globalGradeValues = {
  'AA': 4.00,
  'BA': 3.50,
  'BB': 3.00,
  'CB': 2.50,
  'CC': 2.00,
  'DC': 1.50,
  'DD': 1.00,
  'FD': 0.50,
  'FF': 0.00,
};

// ============================================
// ABSTRACT STRATEGY INTERFACE
// ============================================
abstract class GradeCalculationStrategy {
  // ============================================
  // STRATEJİ BİLGİLERİ
  // ============================================
  String get name;
  String get description;

  // ============================================
  // HARF NOTLARI (Global sabit)
  // ============================================
  Map<String, double> get gradeValues => globalGradeValues;

  // ============================================
  // GANO HESAPLA
  // ============================================
  // Parametreler:
  //   dersler: Her dersin kredi, harfNotu, akts bilgileri
  //   useAkts: true = AKTS ile hesapla, false = Kredi ile hesapla
  // ============================================
  double calculateGANO(List<Map<String, dynamic>> dersler,
      {bool useAkts = false});

  // ============================================
  // FORM WIDGET'I OLUŞTUR
  // ============================================
  Widget buildCourseForm({
    required BuildContext context,
    required TextEditingController nameController,
    required Function(double) onCreditChanged,
    required Function(String?) onGradeChanged,
    Function(double?)? onAktsChanged,
    double? initialCredit,
    String? initialGrade,
    double? initialAkts,
  });
}
