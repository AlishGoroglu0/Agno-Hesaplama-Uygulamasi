// ============================================
// SEMESTER_DETAIL_SCREEN_WIDGET.DART
// ============================================

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../widgets/empty_state.dart';
import '../../data/models/course_model.dart';
import '../../data/models/semester_model.dart';
import '../../providers/app_provider.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/course_row.dart';
import '../widgets/average_card.dart';
import 'add_course_screen.dart';
import 'scenario_screen.dart';
import '../../core/service/semester_detail_screen_logic.dart';

class SemesterDetailScreen extends StatelessWidget {
  final Semester semester;

  const SemesterDetailScreen({
    super.key,
    required this.semester,
  });

  @override
  Widget build(BuildContext context) {
    final logic = SemesterDetailScreenLogic(semester: semester);

    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final currentSemester = logic.getCurrentSemester(provider);
        final semesterAverage = logic.calculateSemesterAverage(
          provider,
          currentSemester,
        );

        return Scaffold(
          appBar: _buildAppBar(currentSemester),
          body: Column(
            children: [
              _buildAverageCard(semesterAverage),
              _buildCourseListHeader(currentSemester),
              _buildCourseList(context, provider, logic, currentSemester),
            ],
          ),
          bottomNavigationBar: _buildBottomButtons(context, logic, currentSemester),
        );
      },
    );
  }

  // ==========================================
  // WIDGET BÖLÜMLERİ
  // ==========================================

  AppBar _buildAppBar(Semester semester) {
    return AppBar(
      title: Text(semester.ad),
    );
  }

  Widget _buildAverageCard(double average) {
    return AverageCard(
      baslik: 'Dönem Ortalaması',
      ortalama: average,
    );
  }

  Widget _buildCourseListHeader(Semester semester) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          const Text(
            'Dersler',
            style: TextStyle(
              fontSize: AppTextSizes.subtitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            '${semester.dersler.length} ders',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList(
    BuildContext context,
    AppProvider provider,
    SemesterDetailScreenLogic logic,
    Semester semester,
  ) {
    return Expanded(
      child: semester.dersler.isEmpty
          ? _buildEmptyState(context, logic, semester)
          : _buildCourseListView(context, provider, logic, semester),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    SemesterDetailScreenLogic logic,
    Semester semester,
  ) {
    return EmptyStateWidget(
      icon: Icons.menu_book_outlined,
      title: 'Henüz Ders Yok',
      description: 'Bu döneme ders ekleyerek ortalamanızı hesaplayın.',
      buttonLabel: 'Yeni Ders Ekle',
      onPressed: () => logic.navigateToAddCourse(context, semester),
    );
  }

  Widget _buildCourseListView(
    BuildContext context,
    AppProvider provider,
    SemesterDetailScreenLogic logic,
    Semester semester,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: semester.dersler.length,
      itemBuilder: (context, index) {
        final course = semester.dersler[index];

        return Slidable(
          endActionPane: _buildSlidableActionPane(
            context,
            provider,
            logic,
            semester,
            course,
          ),
          child: _buildCourseCard(context, provider, logic, semester, course),
        );
      },
    );
  }

  ActionPane _buildSlidableActionPane(
    BuildContext context,
    AppProvider provider,
    SemesterDetailScreenLogic logic,
    Semester semester,
    Course course,
  ) {
    return ActionPane(
      motion: const ScrollMotion(),
      extentRatio: 0.25,
      children: [
        SlidableAction(
          onPressed: (_) {
            logic.showDeleteConfirmationDialog(
              context,
              provider,
              semester,
              course,
            );
          },
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Sil',
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ],
    );
  }

  Widget _buildCourseCard(
    BuildContext context,
    AppProvider provider,
    SemesterDetailScreenLogic logic,
    Semester semester,
    Course course,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: CourseRow(
        ders: course,
        useAkts: provider.useAkts,
        onTap: () => logic.navigateToAddCourse(
          context,
          semester,
          existingCourse: course,
        ),
      ),
    );
  }

  Widget _buildBottomButtons(
    BuildContext context,
    SemesterDetailScreenLogic logic,
    Semester semester,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            _buildScenarioButton(context, logic, semester),
            const SizedBox(width: AppSpacing.md),
            _buildAddCourseButton(context, logic, semester),
          ],
        ),
      ),
    );
  }

  Widget _buildScenarioButton(
    BuildContext context,
    SemesterDetailScreenLogic logic,
    Semester semester,
  ) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () => logic.navigateToScenario(context, semester),
        icon: const Icon(Icons.psychology, size: 20),
        label: const Text('Senaryo'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
    );
  }

  Widget _buildAddCourseButton(
    BuildContext context,
    SemesterDetailScreenLogic logic,
    Semester semester,
  ) {
    return Expanded(
      flex: 2,
      child: ElevatedButton.icon(
        onPressed: () => logic.navigateToAddCourse(context, semester),
        icon: const Icon(Icons.add),
        label: const Text('Yeni Ders'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
    );
  }
}