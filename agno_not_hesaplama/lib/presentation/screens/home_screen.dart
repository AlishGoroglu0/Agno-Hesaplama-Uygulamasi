// ============================================
// HOME_SCREEN_WIDGET.DART
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../widgets/semester_card.dart';
import '../widgets/average_card.dart';
import '../widgets/loading_overlay.dart';
import 'add_semester_screen.dart';
import 'semester_detail_screen.dart';
import 'university_selection_screen.dart';
import '../../core/service/home_screen_logic.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = HomeScreenLogic();

    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final overallGano = logic.calculateOverallGano(provider);
        final isSemesterListEmpty = logic.isSemesterListEmpty(provider);

        return LoadingOverlay(
          isLoading: provider.isLoading,
          child: Scaffold(
            appBar: _buildAppBar(context, logic, provider),
            body: Column(
              children: [
                _buildAverageCard(overallGano),
                _buildSemesterList(
                  context,
                  provider,
                  logic,
                  isSemesterListEmpty,
                ),
              ],
            ),
            floatingActionButton: _buildFloatingActionButton(
              context,
              logic,
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // WIDGET BÖLÜMLERİ
  // ==========================================

  AppBar _buildAppBar(
    BuildContext context,
    HomeScreenLogic logic,
    AppProvider provider,
  ) {
    return AppBar(
      title: const Text('AGNO Not Hesaplama'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            logic.getCalculationTypeText(provider.useAkts),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'Hesaplama Sistemi',
          onPressed: () => logic.navigateToSettings(context),
        ),
      ],
    );
  }

  Widget _buildAverageCard(double overallGano) {
    return AverageCard(
      baslik: 'Genel Ortalama (AGNO)',
      ortalama: overallGano,
    );
  }

  Widget _buildSemesterList(
    BuildContext context,
    AppProvider provider,
    HomeScreenLogic logic,
    bool isEmpty,
  ) {
    return Expanded(
      child: isEmpty
          ? _buildEmptyState()
          : _buildSemesterListView(context, provider, logic),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 80,
            color: AppColors.textHint.withOpacity(0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Henüz dönem eklenmemiş',
            style: TextStyle(
              fontSize: AppTextSizes.subtitle,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Yeni Dönem butonuna basarak başlayın',
            style: TextStyle(
              fontSize: AppTextSizes.caption,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterListView(
    BuildContext context,
    AppProvider provider,
    HomeScreenLogic logic,
  ) {
    return ListView.builder(
      itemCount: provider.donemler.length,
      padding: const EdgeInsets.all(AppSpacing.md),
      itemBuilder: (context, index) {
        final semester = provider.donemler[index];

        return SemesterCard(
          donem: semester,
          onTap: () => logic.navigateToSemesterDetail(context, semester),
          onLongPress: () => logic.showDeleteConfirmationDialog(
            context,
            provider,
            semester,
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton(
    BuildContext context,
    HomeScreenLogic logic,
  ) {
    return FloatingActionButton.extended(
      onPressed: () => logic.navigateToAddSemester(context),
      icon: const Icon(Icons.add),
      label: const Text('Yeni Dönem'),
    );
  }
}
