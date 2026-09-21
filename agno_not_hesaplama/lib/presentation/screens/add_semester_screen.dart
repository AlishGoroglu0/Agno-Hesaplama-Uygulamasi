// ============================================
// ADD_SEMESTER_SCREEN.DART (VALIDATORS İLE GÜNCELLENMİŞ)
// ============================================
// Değişiklik:
// - TextFormField validator'unda Validators.semesterName kullanılıyor
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_provider.dart';
import '../../data/models/semester_model.dart';
import '../../core/theme/app_theme.dart'; // Tema renkleri
import '../../core/utils/validators.dart'; // Doğrulama kuralları

class AddSemesterScreen extends StatefulWidget {
  const AddSemesterScreen({super.key});

  @override
  State<AddSemesterScreen> createState() => _AddSemesterScreenState();
}

class _AddSemesterScreenState extends State<AddSemesterScreen> {
  final TextEditingController _adController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _adController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Dönem Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),

              // ============================================
              // DÖNEM ADI: Validators.semesterName kullanıyor
              // ============================================
              TextFormField(
                controller: _adController,
                decoration: const InputDecoration(
                  labelText: 'Dönem Adı',
                  hintText: 'Örn: 2024-2025 Güz Dönemi',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                // ============================================
                // VALIDATORS: Merkezi doğrulama
                // ============================================
                validator: Validators.semesterName,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _kaydet(),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Kaydet butonu
              ElevatedButton.icon(
                onPressed: _kaydet,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Kaydet',
                  style: TextStyle(fontSize: AppTextSizes.body),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _kaydet() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<AppProvider>();

    final yeniDonem = Semester(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      ad: _adController.text.trim(),
      dersler: [],
    );

    provider.addSemester(yeniDonem);
    Navigator.pop(context);
  }
}
