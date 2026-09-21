// ============================================
// ADD_COURSE_SCREEN_WIDGET.DART
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/grade_values.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/course_model.dart';
import '../../data/models/semester_model.dart';
import '../../providers/app_provider.dart';
import '../../core/service/add_course_screen_logic.dart';

class AddCourseScreen extends StatefulWidget {
  final Semester semester;
  final Course? existingCourse;

  const AddCourseScreen({
    super.key,
    required this.semester,
    this.existingCourse,
  });

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  late AddCourseScreenLogic _logic;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aktsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _logic = AddCourseScreenLogic(
      semester: widget.semester,
      existingCourse: widget.existingCourse,
      nameController: _nameController,
      aktsController: _aktsController,
      formKey: _formKey,
    );
    _logic.initData();
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  void _handleSave(BuildContext context) {
    if (_logic.validateAndSave(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final bool useAkts = provider.useAkts;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              _logic.isEditingMode ? 'Dersi Düzenle' : 'Yeni Ders Ekle',
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoBanner(useAkts),
                  const SizedBox(height: AppSpacing.lg),
                  _buildCourseNameField(),
                  const SizedBox(height: AppSpacing.md),
                  _buildCreditDropdown(useAkts),
                  const SizedBox(height: AppSpacing.md),
                  if (useAkts) ...[
                    _buildAktsField(),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  _buildLetterGradeDropdown(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // WIDGET BÖLÜMLERİ
  // ==========================================

  Widget _buildInfoBanner(bool useAkts) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Ortalama: ${useAkts ? 'AKTS ile' : 'Kredi ile'} hesaplanıyor',
              style: const TextStyle(
                fontSize: AppTextSizes.small,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Ders Adı',
        prefixIcon: Icon(Icons.book),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ders adı gerekli';
        }
        return null;
      },
    );
  }

  Widget _buildCreditDropdown(bool useAkts) {
    return DropdownButtonFormField<double>(
      value: AddCourseScreenLogic.creditOptions.contains(_logic.credit)
          ? _logic.credit
          : null,
      decoration: InputDecoration(
        labelText: useAkts ? 'Kredi (Bilgi amaçlı)' : 'Kredi *',
      ),
      items: AddCourseScreenLogic.creditOptions.map((credit) {
        return DropdownMenuItem(
          value: credit,
          child:
              Text(credit == credit.toInt() ? '${credit.toInt()}' : '$credit'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _logic.updateCredit(value);
        });
      },
    );
  }

  Widget _buildAktsField() {
    return TextFormField(
      controller: _aktsController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'AKTS *',
        hintText: 'Örn: 6.0',
        prefixIcon: Icon(Icons.public),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'AKTS gerekli';
        }
        if (double.tryParse(value.replaceAll(',', '.')) == null) {
          return 'Geçerli bir sayı girin';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _logic.updateAkts(value);
        });
      },
    );
  }

  Widget _buildLetterGradeDropdown() {
    return DropdownButtonFormField<String?>(
      value: harfNotuDegerleri.containsKey(_logic.letterGrade)
          ? _logic.letterGrade
          : null,
      decoration: const InputDecoration(
        labelText: 'Harf Notu',
      ),
      items: [
        const DropdownMenuItem(
          value: null,
          child: Text('Seçilmedi'),
        ),
        ...harfNotuDegerleri.keys.map((grade) {
          final value = harfNotuDegerleri[grade];
          return DropdownMenuItem(
            value: grade,
            child: Text(
              value != null ? '$grade (${value.toStringAsFixed(2)})' : grade,
            ),
          );
        }),
      ],
      onChanged: (value) {
        setState(() {
          _logic.updateLetterGrade(value);
        });
      },
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: () => _handleSave(context),
      icon: Icon(_logic.isEditingMode ? Icons.save : Icons.add),
      label: Text(_logic.isEditingMode ? 'Kaydet' : 'Ders Ekle'),
    );
  }
}
