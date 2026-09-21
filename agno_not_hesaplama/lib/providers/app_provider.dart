// ============================================
// APP_PROVIDER.DART (GÜNCELLENMİŞ)
// ============================================
// Değişiklikler:
// - strategy yerine useAkts (bool) saklanıyor
// - calculator getter kaldırıldı (strategy artık tek)
// - strategyDegistir yerine setUseAkts
// ============================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/strategies/grade_calculation_strategy.dart';
import '../core/strategies/gpa_calculation_statregy.dart';
import '../core/strategies/strategy_factory.dart';
import '../data/models/course_model.dart';
import '../data/models/semester_model.dart';
import '../data/models/university_settings.dart';
import '../data/repositories/local_storage.dart';

class AppProvider extends ChangeNotifier {
  // ============================================
  // ÖZELLİKLER
  // ============================================
  List<Semester> _donemler = [];
  List<Semester> get donemler => List.unmodifiable(_donemler);

  final LocalStorage _depo = LocalStorage();

  // ============================================
  // STRATEGY (YENİ - Tek strateji)
  // ============================================
  final GradeCalculationStrategy _strategy = GpaCalculationStrategy();
  GradeCalculationStrategy get strategy => _strategy;

  // ============================================
  // HESAPLAMA TÜRÜ (YENİ)
  // false = Kredi ile hesapla (varsayılan)
  // true = AKTS ile hesapla
  // ============================================
  bool _useAkts = false;
  bool get useAkts => _useAkts;

  // ============================================
  // LOADING DURUMU
  // ============================================
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ============================================
  // CONSTRUCTOR
  // ============================================
  AppProvider() {
    _baslat();
  }

  // ============================================
  // BAŞLATMA
  // ============================================
  Future<void> _baslat() async {
    await _ayarlariYukle();
    await _verileriYukle();
  }

  // ============================================
  // AYARLARI YÜKLE (YENİ)
  // useAkts değerini SharedPreferences'tan oku
  // ============================================
  Future<void> _ayarlariYukle() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString('university_settings');

    if (settingsJson != null) {
      final settings = UniversitySettings.fromJson(
        jsonDecode(settingsJson),
      );
      _useAkts = settings.useAkts;
    }
  }

  // ============================================
  // HESAPLAMA TÜRÜNÜ DEĞİŞTİR (YENİ)
  // ============================================
  Future<void> setUseAkts(bool value) async {
    _useAkts = value;
    notifyListeners();

    // SharedPreferences'a kaydet
    final prefs = await SharedPreferences.getInstance();
    final settings = UniversitySettings(
      strategyKey: 'gpa',
      useAkts: value,
    );
    await prefs.setString(
      'university_settings',
      jsonEncode(settings.toJson()),
    );
  }

  // ============================================
  // GANO HESAPLA (YENİ)
  // ============================================
  double calculateGano(List<Map<String, dynamic>> dersler) {
    return _strategy.calculateGANO(dersler, useAkts: _useAkts);
  }

  // ============================================
  // YARDIMCI METODLAR
  // ============================================
  Future<void> _verileriYukle() async {
    _donemler = await _depo.loadSemesters();
    notifyListeners();
  }

  Future<void> _verileriKaydet() async {
    await _depo.saveSemesters(_donemler);
  }

  // ============================================
  // DÖNEM İŞLEMLERİ
  // ============================================
  Future<void> addSemester(Semester yeniDonem) async {
    setLoading(true);
    _donemler.add(yeniDonem);
    await _verileriKaydet();
    setLoading(false);
    notifyListeners();
  }

  Future<void> deleteSemester(String id) async {
    setLoading(true);
    _donemler = _donemler.where((donem) => donem.id != id).toList();
    await _verileriKaydet();
    setLoading(false);
    notifyListeners();
  }

  Future<void> updateSemester(String id, Semester guncelDonem) async {
    setLoading(true);
    final indeks = _donemler.indexWhere((donem) => donem.id == id);
    if (indeks != -1) {
      _donemler[indeks] = guncelDonem;
      await _verileriKaydet();
    }
    setLoading(false);
    notifyListeners();
  }

  // ============================================
  // DERS İŞLEMLERİ
  // ============================================
  Future<void> addCourse(String donemId, Course yeniDers) async {
    setLoading(true);
    final indeks = _donemler.indexWhere((donem) => donem.id == donemId);
    if (indeks != -1) {
      final mevcutDersler = List<Course>.from(_donemler[indeks].dersler);
      mevcutDersler.add(yeniDers);
      _donemler[indeks] = Semester(
        id: _donemler[indeks].id,
        ad: _donemler[indeks].ad,
        dersler: mevcutDersler,
      );
      await _verileriKaydet();
    }
    setLoading(false);
    notifyListeners();
  }

  Future<void> deleteCourse(String donemId, String dersAdi) async {
    setLoading(true);
    final indeks = _donemler.indexWhere((donem) => donem.id == donemId);
    if (indeks != -1) {
      final guncelDersler = _donemler[indeks]
          .dersler
          .where((ders) => ders.ad != dersAdi)
          .toList();
      _donemler[indeks] = Semester(
        id: _donemler[indeks].id,
        ad: _donemler[indeks].ad,
        dersler: guncelDersler,
      );
      await _verileriKaydet();
    }
    setLoading(false);
    notifyListeners();
  }

  Future<void> updateCourse(
    String donemId,
    String eskiDersAdi,
    Course guncelDers,
  ) async {
    setLoading(true);
    final indeks = _donemler.indexWhere((donem) => donem.id == donemId);
    if (indeks != -1) {
      final guncelDersler = _donemler[indeks].dersler.map((ders) {
        if (ders.ad == eskiDersAdi) {
          return guncelDers;
        }
        return ders;
      }).toList();
      _donemler[indeks] = Semester(
        id: _donemler[indeks].id,
        ad: _donemler[indeks].ad,
        dersler: guncelDersler,
      );
      await _verileriKaydet();
    }
    setLoading(false);
    notifyListeners();
  }
}
