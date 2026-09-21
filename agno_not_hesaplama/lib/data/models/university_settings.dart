// ============================================
// UNIVERSITY_SETTINGS.DART (GÜNCELLENMİŞ)
// ============================================
// Değişiklikler:
// - useAkts alanı eklendi
// ============================================

class UniversitySettings {
  // ============================================
  // ÖZELLİKLER
  // ============================================
  final String strategyKey; // 'gpa' (tek strateji)
  final bool useAkts;        // true = AKTS ile hesapla, false = Kredi ile hesapla
  final String? universityName;
  final DateTime selectedAt;

  // ============================================
  // CONSTRUCTOR
  // ============================================
  UniversitySettings({
    required this.strategyKey,
    this.useAkts = false,  // Varsayılan: Kredi ile hesapla
    this.universityName,
    DateTime? selectedAt,
  }) : selectedAt = selectedAt ?? DateTime.now();

  // ============================================
  // TO JSON
  // ============================================
  Map<String, dynamic> toJson() {
    return {
      'strategyKey': strategyKey,
      'useAkts': useAkts,
      'universityName': universityName,
      'selectedAt': selectedAt.toIso8601String(),
    };
  }

  // ============================================
  // FROM JSON
  // ============================================
  factory UniversitySettings.fromJson(Map<String, dynamic> json) {
    return UniversitySettings(
      strategyKey: json['strategyKey'] as String,
      useAkts: json['useAkts'] as bool? ?? false,  // Eski kayıtlarda yoksa false
      universityName: json['universityName'] as String?,
      selectedAt: DateTime.parse(json['selectedAt'] as String),
    );
  }

  // ============================================
  // DEFAULT AYARLAR
  // ============================================
  factory UniversitySettings.defaultSettings() {
    return UniversitySettings(
      strategyKey: 'gpa',
      useAkts: false,
      universityName: null,
    );
  }
}