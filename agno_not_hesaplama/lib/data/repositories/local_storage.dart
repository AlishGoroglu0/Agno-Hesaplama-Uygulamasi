// ============================================
// LOCAL_STORAGE.DART
// ============================================
// Bu dosya, dönem verilerini telefonun yerel hafızasına kaydeder ve okur.
// shared_preferences paketi kullanılır.
// Veriler JSON string olarak saklanır.
// ============================================

import 'dart:convert'; // jsonEncode ve jsonDecode için
import 'package:shared_preferences/shared_preferences.dart'; // Yerel depolama paketi

import '../models/semester_model.dart'; // Semester modelini kullanmak için

class LocalStorage {
  // ============================================
  // ANAHTAR (Key) SABİTİ
  // ============================================
  // Telefon hafızasında veriyi saklamak için kullanılan benzersiz isim.
  // Tüm dönemler bu anahtar altında tek bir JSON string olarak saklanır.
  // ============================================
  static const String _anahtarDonemler = 'donemler_listesi';

  // ============================================
  // saveSemesters: Dönem listesini telefona kaydeder
  // ============================================
  // Parametre: List<Semester> → kaydedilecek dönemler
  // İşlem:
  //   1. Her Semester'ı JSON Map'e çevir (toJson)
  //   2. Tüm Map'leri bir listeye koy
  //   3. Listeyi JSON string'e çevir (jsonEncode)
  //   4. String'i shared_preferences ile telefona kaydet
  // ============================================
  Future<void> saveSemesters(List<Semester> donemler) async {
    // ============================================
    // SharedPreferences örneğini al
    // await: Asenkron işlem, tamamlanana kadar bekle
    // ============================================
    final prefs = await SharedPreferences.getInstance();

    // ============================================
    // Her Semester'ı Map'e çevir ve listele
    // ============================================
    List<Map<String, dynamic>> jsonListesi =
        donemler.map((donem) => donem.toJson()).toList();

    // ============================================
    // Listeyi JSON string'e çevir
    // jsonEncode: Dart Map/List yapısını String'e dönüştürür
    // ============================================
    String jsonString = jsonEncode(jsonListesi);

    // ============================================
    // String'i telefona kaydet
    // setString: Anahtar-değer çifti olarak saklar
    // ============================================
    await prefs.setString(_anahtarDonemler, jsonString);
  }

  // ============================================
  // loadSemesters: Telefondan dönem listesini okur
  // ============================================
  // Dönüş: List<Semester> → okunan dönemler
  // İşlem:
  //   1. SharedPreferences'tan string'i oku
  //   2. Eğer null ise (hiç kayıt yoksa) boş liste döndür
  //   3. String'i JSON listesine çevir (jsonDecode)
  //   4. Her Map'i Semester nesnesine çevir (fromJson)
  // ============================================
  Future<List<Semester>> loadSemesters() async {
    // ============================================
    // SharedPreferences örneğini al
    // ============================================
    final prefs = await SharedPreferences.getInstance();

    // ============================================
    // Kaydedilmiş string'i oku
    // getString: Anahtarla eşleşen değeri döndürür, yoksa null
    // ============================================
    String? jsonString = prefs.getString(_anahtarDonemler);

    // ============================================
    // Eğer hiç kayıt yoksa (ilk açılış) boş liste döndür
    // ============================================
    if (jsonString == null) {
      return [];
    }

    // ============================================
    // JSON string'i Dart listesine çevir
    // jsonDecode: String'i List<Map> yapısına dönüştürür
    // as List<dynamic>: Gelen verinin liste olduğunu doğrula
    // ============================================
    List<dynamic> jsonListesi = jsonDecode(jsonString) as List<dynamic>;

    // ============================================
    // Her Map elemanını Semester nesnesine çevir
    // ============================================
    List<Semester> donemler = jsonListesi
        .map(
            (jsonDonem) => Semester.fromJson(jsonDonem as Map<String, dynamic>))
        .toList();

    return donemler;
  }

  // ============================================
  // clearSemesters: Tüm kayıtlı verileri sil
  // ============================================
  // Kullanıcı tüm verileri sıfırlamak isterse kullanılır.
  // ============================================
  Future<void> clearSemesters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_anahtarDonemler);
  }
}
