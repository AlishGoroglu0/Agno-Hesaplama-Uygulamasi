// ============================================
// LOCAL_STORAGE_TEST.DART
// ============================================
// LocalStorage class'ının kaydetme/okuma işlemlerini test eder.
// SharedPreferences mock'u kullanılarak test ortamında çalışır.
// ============================================

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Mock için gerekli

import '../models/course_model.dart';
import '../models/semester_model.dart';
import 'local_storage.dart';

void main() {
  // ============================================
  // TEST BAŞLAMADAN ÖNCE: SharedPreferences mock'unu başlat
  // Test ortamında gerçek telefon hafızası yoktur.
  // SharedPreferences.setMockInitialValues() ile sahte (mock) değerler oluştururuz.
  // ============================================
  setUpAll(() async {
    // Boş bir Map ile mock'u başlat (hiç kayıt yokmuş gibi)
    SharedPreferences.setMockInitialValues({});
  });

  // ============================================
  // LocalStorage örneği oluştur
  // ============================================
  final LocalStorage depo = LocalStorage();

  test('Kaydet ve Oku Testi', () async {
    print('========================================');
    print('TEST: saveSemesters + loadSemesters');
    print('========================================');

    // ============================================
    // 1. Test verisi oluştur
    // ============================================
    List<Semester> ornekDonemler = [
      Semester(
        id: '2024-guz',
        ad: '2024-2025 Güz Dönemi',
        dersler: [
          Course(ad: 'Matematik I', kredi: 4, harfNotu: 'BA'),
          Course(ad: 'Fizik I', kredi: 3, harfNotu: 'AA'),
        ],
      ),
      Semester(
        id: '2025-bahar',
        ad: '2025 Bahar Dönemi',
        dersler: [
          Course(ad: 'Programlama', kredi: 3, harfNotu: 'CC'),
          Course(ad: 'Veritabanı', kredi: 3, harfNotu: 'BB'),
          Course(ad: 'İngilizce', kredi: 2, harfNotu: 'FF'),
        ],
      ),
    ];

    print('Kaydedilecek dönem sayısı: ${ornekDonemler.length}');

    // ============================================
    // 2. Kaydet
    // ============================================
    await depo.saveSemesters(ornekDonemler);
    print('✅ Veriler kaydedildi.');

    // ============================================
    // 3. Oku
    // ============================================
    List<Semester> okunanDonemler = await depo.loadSemesters();
    print('✅ Veriler okundu.');
    print('Okunan dönem sayısı: ${okunanDonemler.length}');

    // ============================================
    // 4. Doğrulama
    // ============================================
    expect(okunanDonemler.length, 2);

    // İlk dönem kontrolü
    expect(okunanDonemler[0].id, '2024-guz');
    expect(okunanDonemler[0].ad, '2024-2025 Güz Dönemi');
    expect(okunanDonemler[0].dersler.length, 2);
    expect(okunanDonemler[0].dersler[0].ad, 'Matematik I');
    expect(okunanDonemler[0].dersler[0].kredi, 4);
    expect(okunanDonemler[0].dersler[0].harfNotu, 'BA');

    // İkinci dönem kontrolü
    expect(okunanDonemler[1].id, '2025-bahar');
    expect(okunanDonemler[1].dersler.length, 3);
    expect(okunanDonemler[1].dersler[2].harfNotu, 'FF');

    print('✅ Tüm doğrulamalar başarılı!');
  });

  test('Boş Liste Kaydetme Testi', () async {
    print('');
    print('========================================');
    print('TEST: Boş liste kaydetme');
    print('========================================');

    // ============================================
    // Boş liste kaydet
    // ============================================
    await depo.saveSemesters([]);

    // ============================================
    // Oku ve doğrula
    // ============================================
    List<Semester> sonuc = await depo.loadSemesters();
    expect(sonuc, isEmpty);
    print('✅ Boş liste doğru şekilde kaydedildi ve okundu.');
  });

  test('Hiç Kayıt Yoksa Boş Liste Dönmeli', () async {
    print('');
    print('========================================');
    print('TEST: Hiç kayıt yoksa boş liste');
    print('========================================');

    // ============================================
    // Önce tüm verileri sil
    // ============================================
    await depo.clearSemesters();

    // ============================================
    // Oku
    // ============================================
    List<Semester> sonuc = await depo.loadSemesters();
    expect(sonuc, isEmpty);
    print('✅ Hiç kayıt yoksa boş liste döndü.');
  });
}
