// ============================================
// SEMESTER_MODEL.DART
// ============================================
// Bu dosya, bir dönem (yarıyıl) veri yapısını tanımlar.
// Her dönemin: id'si, adı ve içindeki derslerin listesi vardır.
// ============================================

import 'course_model.dart'; // Course sınıfını kullanmak için import

class Semester {
  // ============================================
  // ÖZELLİKLER (Properties)
  // ============================================
  final String id; // Benzersiz tanımlayıcı (örn: "2024-guz")
  final String ad; // Dönemin adı (örn: "2024-2025 Güz Dönemi")
  final List<Course> dersler; // Bu döneme ait derslerin listesi

  // ============================================
  // CONSTRUCTOR
  // ============================================
  Semester({
    required this.id,
    required this.ad,
    required this.dersler,
  });

  // ============================================
  // toJson: Semester nesnesini JSON formatına çevirir
  // Ders listesindeki her Course'u tek tek toJson() ile Map'e çevirir
  // ============================================
  Map<String, dynamic> toJson() {
    return {
      'id': id, // String olarak kaydet
      'ad': ad, // String olarak kaydet
      // ============================================
      // Ders listesini Map listesine çevir
      // map(): Listedeki her eleman için bir işlem yap
      // toList(): Sonucu tekrar listeye çevir
      // ============================================
      'dersler': dersler.map((ders) => ders.toJson()).toList(),
    };
  }

  // ============================================
  // fromJson: JSON (Map) yapısını Semester nesnesine çevirir
  // ============================================
  factory Semester.fromJson(Map<String, dynamic> json) {
    // ============================================
    // 'dersler' anahtarından liste al
    // List<dynamic> gelen veriyi List<Course>'a çevir
    // ============================================
    var derslerListesi = json['dersler'] as List<dynamic>;

    return Semester(
      id: json['id'] as String,
      ad: json['ad'] as String,
      // ============================================
      // Her Map elemanını Course.fromJson ile Course nesnesine çevir
      // map() ile dolaş, toList() ile listele
      // ============================================
      dersler: derslerListesi
          .map((dersMap) => Course.fromJson(dersMap as Map<String, dynamic>))
          .toList(),
    );
  }

  // ============================================
  // toString: Debug için okunabilir yazı
  // ============================================
  @override
  String toString() {
    return 'Semester(id: $id, ad: $ad, dersSayisi: ${dersler.length})';
  }
}
