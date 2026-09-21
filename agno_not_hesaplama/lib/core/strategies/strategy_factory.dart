// ============================================
// STRATEGY_FACTORY.DART
// ============================================
// Strategy fabrikası.
// String anahtar ile doğru stratejiyi oluşturur.
// SharedPreferences'tan okunan değere göre çalışır.
// ============================================

import 'grade_calculation_strategy.dart';
import 'gpa_calculation_statregy.dart';

// ============================================
// STRATEJİ ANAHTARLARI
// Tüm sistemlerin benzersiz kimlikleri
// ============================================
class StrategyKeys {
  static const String standard = 'standard';
  static const String akts = 'akts';
  static const String hundredToLetter = 'hundred_to_letter';
}

class StrategyFactory {
  static GradeCalculationStrategy create(String key) {
    // Artık tek strateji var, key ne olursa olsun aynısı
    return GpaCalculationStrategy();
  }

  static List<Map<String, dynamic>> getAllStrategies() {
    return [
      {
        'key': 'gpa',
        'strategy': GpaCalculationStrategy(),
      },
    ];
  }
}
