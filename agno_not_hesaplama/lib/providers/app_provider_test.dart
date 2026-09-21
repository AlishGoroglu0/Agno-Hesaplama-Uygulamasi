// ============================================
// APP_PROVIDER_TEST.DART (DÜZELTİLMİŞ)
// ============================================
// Hata nedenleri ve çözümleri:
// 1. Testler birbirini etkiliyordu → setUp'ta veriyi temizle
// 2. Veri kalıcılık testi önceki testlerin verisini okuyordu → her test öncesi sıfırla
// 3. Ders silme/güncelleme testleri önceki testlerden kalan veriyi gördü → setUp'ta yeni provider + temiz veri
// ============================================

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/course_model.dart';
import '../data/models/semester_model.dart';
import 'app_provider.dart';

void main() {
  // ============================================
  // HER TEST ÖNCESİ ÇALIŞACAK KOD
  // setUpAll yerine setUp kullanıyoruz ki her test bağımsız olsun
  // ============================================
  late AppProvider provider;

  setUp(() async {
    // ============================================
    // Her test öncesi SharedPreferences'ı sıfırla (boş değerlerle başlat)
    // Böylece testler birbirini etkilemez
    // ============================================
    SharedPreferences.setMockInitialValues({});

    // ============================================
    // Yeni provider oluştur
    // Constructor içinde _verileriYukle() çağrılır ama veri boş olduğu için liste boş kalır
    // ============================================
    provider = AppProvider();

    // Kısa bekle: constructor'daki async _verileriYukle'in tamamlanması için
    await Future.delayed(Duration(milliseconds: 50));
  });

  group('Dönem İşlemleri', () {
    test('Dönem ekleme', () async {
      print('========================================');
      print('TEST: addSemester');
      print('========================================');

      // Başlangıçta liste boş olmalı
      expect(provider.donemler.length, 0);

      // Yeni dönem ekle
      await provider.addSemester(Semester(
        id: '2024-guz',
        ad: '2024 Güz',
        dersler: [],
      ));

      // Liste güncellendi mi?
      expect(provider.donemler.length, 1);
      expect(provider.donemler[0].id, '2024-guz');
      expect(provider.donemler[0].ad, '2024 Güz');

      print('✅ Dönem eklendi, liste güncellendi.');
    });

    test('Dönem silme', () async {
      print('');
      print('========================================');
      print('TEST: deleteSemester');
      print('========================================');

      // ============================================
      // Bu test bağımsız: kendi verisini kendisi oluşturur
      // Önceki testlerden kalan "2024-guz" artık yok (setUp her seferinde sıfırlıyor)
      // ============================================

      // Önce dönem ekle
      await provider.addSemester(Semester(
        id: '2024-bahar',
        ad: '2024 Bahar',
        dersler: [],
      ));

      // Eklendi mi kontrol et
      expect(provider.donemler.length, 1);

      // Dönem sil
      await provider.deleteSemester('2024-bahar');

      // Liste boşaldı mı?
      expect(provider.donemler.length, 0);

      print('✅ Dönem silindi, liste güncellendi.');
    });

    test('Dönem güncelleme', () async {
      print('');
      print('========================================');
      print('TEST: updateSemester');
      print('========================================');

      // Önce dönem ekle
      await provider.addSemester(Semester(
        id: '2025-guz',
        ad: 'Eski Ad',
        dersler: [],
      ));

      // Dönem güncelle
      await provider.updateSemester(
        '2025-guz',
        Semester(id: '2025-guz', ad: 'Yeni Ad', dersler: []),
      );

      // Ad değişti mi?
      expect(provider.donemler[0].ad, 'Yeni Ad');

      print('✅ Dönem güncellendi, liste güncellendi.');
    });
  });

  group('Ders İşlemleri', () {
    test('Derse ekleme', () async {
      print('');
      print('========================================');
      print('TEST: addCourse');
      print('========================================');

      // Önce dönem ekle
      await provider.addSemester(Semester(
        id: '2024-guz',
        ad: '2024 Güz',
        dersler: [],
      ));

      // Ders ekle
      await provider.addCourse(
        '2024-guz',
        Course(ad: 'Matematik', kredi: 4, harfNotu: 'AA'),
      );

      // Ders eklendi mi?
      expect(provider.donemler[0].dersler.length, 1);
      expect(provider.donemler[0].dersler[0].ad, 'Matematik');

      print('✅ Ders eklendi, liste güncellendi.');
    });

    test('Ders silme', () async {
      print('');
      print('========================================');
      print('TEST: deleteCourse');
      print('========================================');

      // ============================================
      // Bu test bağımsız: kendi dönemini ve dersini kendisi oluşturur
      // ============================================

      // Dönem ekle (içinde 2 ders var)
      await provider.addSemester(Semester(
        id: '2024-guz',
        ad: '2024 Güz',
        dersler: [
          Course(ad: 'Matematik', kredi: 4, harfNotu: 'AA'),
          Course(ad: 'Fizik', kredi: 3, harfNotu: 'BA'),
        ],
      ));

      // Başlangıçta 2 ders var
      expect(provider.donemler[0].dersler.length, 2);

      // Matematik dersini sil
      await provider.deleteCourse('2024-guz', 'Matematik');

      // Matematik çıktı mı?
      expect(provider.donemler[0].dersler.length, 1);
      expect(provider.donemler[0].dersler[0].ad, 'Fizik');

      print('✅ Ders silindi, liste güncellendi.');
    });

    test('Ders güncelleme', () async {
      print('');
      print('========================================');
      print('TEST: updateCourse');
      print('========================================');

      // ============================================
      // Bu test bağımsız: kendi dönemini ve dersini kendisi oluşturur
      // ============================================

      // Dönem ekle (içinde 1 ders var)
      await provider.addSemester(Semester(
        id: '2024-guz',
        ad: '2024 Güz',
        dersler: [
          Course(ad: 'Matematik', kredi: 4, harfNotu: 'AA'),
        ],
      ));

      // Başlangıçta 1 ders var
      expect(provider.donemler[0].dersler.length, 1);

      // Ders güncelle (notu değiştir)
      await provider.updateCourse(
        '2024-guz',
        'Matematik',
        Course(ad: 'Matematik', kredi: 4, harfNotu: 'FF'),
      );

      // Not değişti mi?
      expect(provider.donemler[0].dersler.length, 1);
      expect(provider.donemler[0].dersler[0].harfNotu, 'FF');

      print('✅ Ders güncellendi, liste güncellendi.');
    });
  });

  group('Veri Kalıcılığı', () {
    test('Uygulama yeniden açılınca veriler gelmeli', () async {
      print('');
      print('========================================');
      print('TEST: Veri kalıcılığı');
      print('========================================');

      // ============================================
      // Bu test bağımsız: kendi verisini kendisi oluşturur
      // ============================================

      // Veri ekle
      await provider.addSemester(Semester(
        id: '2024-guz',
        ad: '2024 Güz',
        dersler: [
          Course(ad: 'Matematik', kredi: 4, harfNotu: 'AA'),
        ],
      ));

      // Eklendi mi?
      expect(provider.donemler.length, 1);

      // ============================================
      // Yeni provider oluştur (uygulama yeniden açılmış gibi)
      // Aynı SharedPreferences mock'unu kullanır (veri hâlâ orada)
      // ============================================
      final yeniProvider = AppProvider();
      await Future.delayed(Duration(milliseconds: 50));

      // Veriler yüklendi mi?
      expect(yeniProvider.donemler.length, 1);
      expect(yeniProvider.donemler[0].ad, '2024 Güz');
      expect(yeniProvider.donemler[0].dersler[0].ad, 'Matematik');

      print('✅ Veri kalıcılığı çalışıyor.');
    });
  });
}
