// ============================================
// HOME_SCREEN_LOGIC.DART
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/semester_model.dart';
import '../../providers/app_provider.dart';
import '../../presentation/screens/add_semester_screen.dart';
import '../../presentation/screens/add_course_screen.dart';
import '../../presentation/screens/semester_detail_screen.dart';
import '../theme/app_theme.dart';
import '../../presentation/screens/university_selection_screen.dart';

class HomeScreenLogic {
  // Tüm dersleri birleştir ve hesaplama için hazırla
  List<Map<String, dynamic>> prepareAllCourses(AppProvider provider) {
    final List<Map<String, dynamic>> allCourses = [];

    for (var semester in provider.donemler) {
      for (var course in semester.dersler) {
        allCourses.add({
          'kredi': course.kredi,
          'harfNotu': course.harfNotu,
          'akts': course.akts,
        });
      }
    }

    return allCourses;
  }

  // Genel GANO hesapla
  double calculateOverallGano(AppProvider provider) {
    final allCourses = prepareAllCourses(provider);

    if (allCourses.isEmpty) return 0.0;
    return provider.calculateGano(allCourses);
  }

  // Dönem silme işlemi
  void deleteSemester(
    BuildContext context,
    AppProvider provider,
    Semester semester,
  ) {
    provider.deleteSemester(semester.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${semester.ad} silindi'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Silme onay diyaloğunu göster
  void showDeleteConfirmationDialog(
    BuildContext context,
    AppProvider provider,
    Semester semester,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Dönemi Sil'),
        content: Text(
          '"${semester.ad}" dönemini silmek istediğinize emin misiniz?\n\n'
          'Bu döneme ait tüm dersler de silinecektir.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              deleteSemester(context, provider, semester);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  // Yeni dönem ekleme sayfasına git
  void navigateToAddSemester(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddSemesterScreen(),
      ),
    );
  }

  // Dönem detay sayfasına git
  void navigateToSemesterDetail(
    BuildContext context,
    Semester semester,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SemesterDetailScreen(
          semester: semester,
        ),
      ),
    );
  }

  // Ayarlar sayfasına git (Üniversite seçimi)
  void navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UniversitySelectionScreen(
          isFirstSetup: false,
        ),
      ),
    );
  }

  // Hesaplama türüne göre açıklama metni
  String getCalculationTypeText(bool useAkts) {
    return useAkts ? 'AKTS ile Hesaplanıyor' : 'Kredi ile Hesaplanıyor';
  }

  // Dönem listesi boş mu kontrol et
  bool isSemesterListEmpty(AppProvider provider) {
    return provider.donemler.isEmpty;
  }

  // Dönem sayısını getir
  int getSemesterCount(AppProvider provider) {
    return provider.donemler.length;
  }
}
