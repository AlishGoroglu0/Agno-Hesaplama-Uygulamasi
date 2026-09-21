

App created:

2. Core Katmanı
grade_values.dart oluştur — harf notu map'i (AA: 4.00, BA: 3.50...)
app_colors.dart oluştur — uygulama renkleri
app_strings.dart oluştur — metin sabitleri
app_theme.dart oluştur — Material 3 teması
grade_calculator.dart oluştur — ATKS ve GANO hesaplama fonksiyonları
validators.dart oluştur — boş alan kontrolü





lib/
│
├── main.dart
│
├── app.dart
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── grade_values.dart      # Harf notu değerleri (AA=4.00...)
│   │
│   ├── theme/
│   │   └── app_theme.dart
│   │
│   └── utils/
│       ├── grade_calculator.dart    # ATKS, GANO hesaplama
│       └── validators.dart
│
├── data/
│   ├── models/
│   │   ├── semester_model.dart
│   │   └── course_model.dart
│   │
│   └── repositories/
│       └── local_storage.dart       # SharedPreferences işlemleri
│
├── presentation/
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── add_semester_screen.dart
│   │   ├── semester_detail_screen.dart
│   │   ├── add_course_screen.dart
│   │   └── scenario_screen.dart   # 🎯 Hedefim
│   │
│   └── widgets/
│       ├── semester_card.dart
│       ├── course_row.dart
│       ├── grade_selector.dart
│       └── result_banner.dart
│
└── providers/                       # State management (basit)
    └── app_provider.dart