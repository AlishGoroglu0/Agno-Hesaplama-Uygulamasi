// ============================================
// MODELS_TEST.DART
// ============================================
// Course ve Semester modellerinin JSON çevrimini test eder.
// Nesne → JSON → Nesne döngüsünü kontrol eder.
// ============================================

import 'course_model.dart';
import 'semester_model.dart';

void main() {
  print('========================================');
  print('TEST 1: Course Modeli - toJson / fromJson');
  print('========================================');

  // ============================================
  // 1. Course nesnesi oluştur
  // ============================================
  Course matematik = Course(
    ad: 'Matematik I',
    kredi: 4,
    harfNotu: 'BA',
  );
  print('Orijinal Course: $matematik');

  // ============================================
  // 2. Course'u JSON'a çevir (toJson)
  // ============================================
  Map<String, dynamic> matematikJson = matematik.toJson();
  print('JSON: $matematikJson');

  // ============================================
  // 3. JSON'u tekrar Course'a çevir (fromJson)
  // ============================================
  Course matematikYeniden = Course.fromJson(matematikJson);
  print('JSON\'dan dönen Course: $matematikYeniden');

  // ============================================
  // 4. Doğrulama
  // ============================================
  bool dogruMu = matematik.ad == matematikYeniden.ad &&
      matematik.kredi == matematikYeniden.kredi &&
      matematik.harfNotu == matematikYeniden.harfNotu;
  print('Eşleşme: $dogruMu  |  Beklenen: true');

  print('');
  print('========================================');
  print('TEST 2: Semester Modeli - toJson / fromJson');
  print('========================================');

  // ============================================
  // 1. Ders listesi oluştur
  // ============================================
  List<Course> dersler = [
    Course(ad: 'Matematik I', kredi: 4, harfNotu: 'BA'),
    Course(ad: 'Fizik I', kredi: 3, harfNotu: 'AA'),
    Course(ad: 'Programlama', kredi: 3, harfNotu: 'CC'),
  ];

  // ============================================
  // 2. Semester nesnesi oluştur
  // ============================================
  Semester guzDonemi = Semester(
    id: '2024-guz',
    ad: '2024-2025 Güz Dönemi',
    dersler: dersler,
  );
  print('Orijinal Semester: $guzDonemi');

  // ============================================
  // 3. Semester'ı JSON'a çevir (toJson)
  // ============================================
  Map<String, dynamic> guzJson = guzDonemi.toJson();
  print('JSON:');
  print(guzJson);

  // ============================================
  // 4. JSON'u tekrar Semester'a çevir (fromJson)
  // ============================================
  Semester guzYeniden = Semester.fromJson(guzJson);
  print('JSON\'dan dönen Semester: $guzYeniden');

  // ============================================
  // 5. İç içe doğrulama (dersler de eşleşiyor mu?)
  // ============================================
  bool semesterDogru = guzDonemi.id == guzYeniden.id &&
      guzDonemi.ad == guzYeniden.ad &&
      guzDonemi.dersler.length == guzYeniden.dersler.length;

  bool derslerDogru = true;
  for (int i = 0; i < guzDonemi.dersler.length; i++) {
    if (guzDonemi.dersler[i].ad != guzYeniden.dersler[i].ad ||
        guzDonemi.dersler[i].kredi != guzYeniden.dersler[i].kredi ||
        guzDonemi.dersler[i].harfNotu != guzYeniden.dersler[i].harfNotu) {
      derslerDogru = false;
    }
  }

  print('Semester eşleşme: $semesterDogru  |  Beklenen: true');
  print('Dersler eşleşme: $derslerDogru  |  Beklenen: true');

  print('');
  print('========================================');
  print('TEST 3: Boş Ders Listesi Senaryosu');
  print('========================================');

  Semester bosDonem = Semester(
    id: '2025-bahar',
    ad: '2025 Bahar Dönemi',
    dersler: [], // Boş liste
  );

  Map<String, dynamic> bosJson = bosDonem.toJson();
  Semester bosYeniden = Semester.fromJson(bosJson);

  print('Boş dönem JSON: $bosJson');
  print('Ders sayısı: ${bosYeniden.dersler.length}  |  Beklenen: 0');

  print('');
  print('========================================');
  print('TÜM TESTLER TAMAMLANDI');
  print('========================================');
}
