// ============================================
// VALIDATORS.DART
// ============================================
// Form doğrulama kuralları.
// Tüm input alanları için merkezi doğrulama.
// ============================================

class Validators {
  // ============================================
  // BOŞ ALAN KONTROLÜ
  // ============================================
  static String? required(String? value, {String fieldName = 'Bu alan'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName boş bırakılamaz';
    }
    return null;
  }

  // ============================================
  // MİNİMUM UZUNLUK KONTROLÜ
  // ============================================
  static String? minLength(
    String? value, {
    required int length,
    String fieldName = 'Bu alan',
  }) {
    if (value != null && value.trim().length < length) {
      return '$fieldName en az $length karakter olmalıdır';
    }
    return null;
  }

  // ============================================
  // MAKSİMUM UZUNLUK KONTROLÜ
  // ============================================
  static String? maxLength(
    String? value, {
    required int length,
    String fieldName = 'Bu alan',
  }) {
    if (value != null && value.trim().length > length) {
      return '$fieldName en fazla $length karakter olmalıdır';
    }
    return null;
  }

  // ============================================
  // DERS ADI DOĞRULAMA
  // ============================================
  static String? courseName(String? value) {
    final emptyError = required(value, fieldName: 'Ders adı');
    if (emptyError != null) return emptyError;

    final minError = minLength(value, length: 2, fieldName: 'Ders adı');
    if (minError != null) return minError;

    final maxError = maxLength(value, length: 50, fieldName: 'Ders adı');
    if (maxError != null) return maxError;

    return null;
  }

  // ============================================
  // DÖNEM ADI DOĞRULAMA
  // ============================================
  static String? semesterName(String? value) {
    final emptyError = required(value, fieldName: 'Dönem adı');
    if (emptyError != null) return emptyError;

    final minError = minLength(value, length: 2, fieldName: 'Dönem adı');
    if (minError != null) return minError;

    final maxError = maxLength(value, length: 50, fieldName: 'Dönem adı');
    if (maxError != null) return maxError;

    return null;
  }
}
