// ============================================
// SEMESTER_DETAIL_SCREEN_LOGIC.DART
// ============================================

import 'package:agno_not_hesaplama/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/course_model.dart';
import '../../data/models/semester_model.dart';
import '../../providers/app_provider.dart';
import '../../presentation/screens/add_course_screen.dart';
import '../../presentation/screens/scenario_screen.dart';

class SemesterDetailScreenLogic {
  final Semester semester;

  SemesterDetailScreenLogic({required this.semester});

  // Provider'dan güncel dönemi al
  Semester getCurrentSemester(AppProvider provider) {
    return provider.donemler.firstWhere(
      (d) => d.id == semester.id,
      orElse: () => semester,
    );
  }

  // Dönem ortalamasını hesapla
  double calculateSemesterAverage(AppProvider provider, Semester semester) {
    final List<Map<String, dynamic>> coursesMap = semester.dersler
        .map((course) => {
              'kredi': course.kredi,
              'harfNotu': course.harfNotu,
              'akts': course.akts,
            })
        .toList();

    if (coursesMap.isEmpty) return 0.0;
    return provider.calculateGano(coursesMap);
  }

  // Ders silme işlemi
  void deleteCourse(
    BuildContext context,
    AppProvider provider,
    String semesterId,
    Course course,
  ) {
    provider.deleteCourse(semesterId, course.ad);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${course.ad} silindi'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Silme onay diyaloğunu göster
  void showDeleteConfirmationDialog(
    BuildContext context,
    AppProvider provider,
    Semester semester,
    Course course,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Dersi Sil'),
        content:
            Text('"${course.ad}" dersini silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              deleteCourse(context, provider, semester.id, course);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  // Ders ekleme/düzenleme sayfasına git
  void navigateToAddCourse(
    BuildContext context,
    Semester semester, {
    Course? existingCourse,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCourseScreen(
          semester: semester,
          existingCourse: existingCourse,
        ),
      ),
    );
  }

  // Senaryo sayfasına git
  void navigateToScenario(
    BuildContext context,
    Semester semester,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScenarioScreen(donem: semester),
      ),
    );
  }
}
