// ============================================
// ADD_COURSE_SCREEN_LOGIC.DART
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/grade_values.dart';
import '../../data/models/course_model.dart';
import '../../data/models/semester_model.dart';
import '../../providers/app_provider.dart';

class AddCourseScreenLogic {
  final Semester semester;
  final Course? existingCourse;
  final TextEditingController nameController;
  final TextEditingController aktsController;
  final GlobalKey<FormState> formKey;

  double credit = 3.0;
  String? letterGrade;
  double? akts;

  AddCourseScreenLogic({
    required this.semester,
    this.existingCourse,
    required this.nameController,
    required this.aktsController,
    required this.formKey,
  });

  bool get isEditingMode => existingCourse != null;

  static const List<double> creditOptions = [
    1.0,
    1.5,
    2.0,
    2.5,
    3.0,
    3.5,
    4.0,
    4.5,
    5.0,
    6.0,
    7.0,
    8.0
  ];

  void initData() {
    if (isEditingMode) {
      nameController.text = existingCourse!.ad;
      credit = existingCourse!.kredi;
      letterGrade = existingCourse!.harfNotu;
      akts = existingCourse!.akts;
      if (akts != null) {
        aktsController.text = akts.toString();
      }
    }
  }

  void updateAkts(String value) {
    final parsedAkts = double.tryParse(value.replaceAll(',', '.'));
    akts = parsedAkts;
  }

  void updateCredit(double? newCredit) {
    if (newCredit != null) {
      credit = newCredit;
    }
  }

  void updateLetterGrade(String? newGrade) {
    letterGrade = newGrade;
  }

  bool validateAndSave(BuildContext context) {
    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    final provider = Provider.of<AppProvider>(context, listen: false);

    final newCourse = Course(
      ad: nameController.text.trim(),
      kredi: credit,
      harfNotu: letterGrade ?? 'ETKİSİZ',
      akts: akts,
    );

    if (isEditingMode) {
      provider.updateCourse(
        semester.id,
        existingCourse!.ad,
        newCourse,
      );
    } else {
      provider.addCourse(semester.id, newCourse);
    }

    return true;
  }

  void dispose() {
    nameController.dispose();
    aktsController.dispose();
  }
}
