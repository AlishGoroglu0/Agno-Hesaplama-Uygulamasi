// ============================================
// COURSE_MODEL.DART (GÜNCELLENMİŞ)
// ============================================
// Değişiklikler:
// - kredi: int → double
// - akts: int? → double?
// ============================================

class Course {
  // ============================================
  // ÖZELLİKLER
  // ============================================
  final String ad; // Dersin adı
  final double kredi; // Yerel kredi (1.5, 3.0, 3.5, 4.0...)
  final String harfNotu; // Dersin harf notu
  final double? akts; // AKTS değeri (4.5, 6.0, 7.5...) - opsiyonel

  // ============================================
  // CONSTRUCTOR
  // ============================================
  Course({
    required this.ad,
    required this.kredi,
    required this.harfNotu,
    this.akts,
  });

  // ============================================
  // TO JSON
  // ============================================
  Map<String, dynamic> toJson() {
    return {
      'ad': ad,
      'kredi': kredi,
      'harfNotu': harfNotu,
      'akts': akts,
    };
  }

  // ============================================
  // FROM JSON
  // ============================================
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      ad: json['ad'] as String,
      kredi: (json['kredi'] as num).toDouble(),
      harfNotu: json['harfNotu'] as String,
      akts: json['akts'] != null ? (json['akts'] as num).toDouble() : null,
    );
  }

  // ============================================
  // TO STRING
  // ============================================
  @override
  String toString() {
    return 'Course(ad: $ad, kredi: $kredi, harfNotu: $harfNotu, akts: $akts)';
  }
}
