# Nirvana Digital Mobile - Engineering Department

Aplikasi mobile untuk Engineering Department Nirvana Boutique Residence yang mencakup sistem inspeksi dan log sheet dengan fitur offline-first, enkripsi data, dan sinkronisasi otomatis.

## 📱 Fitur Aplikasi

### Frontend (Flutter)
- **Dashboard Utama**: Ringkasan status inspeksi dengan Quick Scan QR Code
- **Modul Inspeksi**:
  - LVMDP Inspection (Parameter: Ampere, Volt, Cos φ, Kw, Kwh, Hz)
  - STP Inspection (Checksheet Grit Chamber, Equalizing Tank, Aeration, dll)
  - Electrical Log Sheet (Daya, KWH WBP/LWBP/KVARH, Tegangan & Arus)
  - Water Log Sheet (Meteran PAM, Deepwell, Tank Level, Flow Meter)
  - Checklist Shift 1/2/Night (Genset, Lift, Hydrant, Drainage, Fire Alarm)
- **QR Code Scanner**: Pemindaian lokasi panel/peralatan
- **Offline Storage**: SQLite untuk penyimpanan lokal dengan auto-sync
- **Export PDF/Excel**: Rekapitulasi bulanan
- **Enkripsi Data**: AES encryption untuk keamanan data sensitif

### Backend (Laravel)
- **RESTful API** dengan Laravel Sanctum authentication
- **Database PostgreSQL** dengan relasi lengkap
- **Migrations** untuk semua tabel inspeksi
- **API Endpoints**:
  - Authentication (Login, Register, Logout)
  - CRUD untuk semua modul inspeksi
  - Sync endpoint untuk offline data
  - Export PDF/Excel endpoints
  - QR Location management

## 🏗️ Struktur Folder

### Flutter Mobile App
```
nirvana-mobile/
├── lib/
│   ├── config/
│   │   ├── app_constants.dart      # Konstanta aplikasi
│   │   ├── routes.dart             # Routing configuration
│   │   └── theme/
│   │       └── app_theme.dart      # Theme & colors
│   ├── data/
│   │   ├── datasources/            # Data sources (API, Local)
│   │   ├── models/                 # Data models
│   │   └── repositories/           # Repository implementations
│   ├── domain/
│   │   ├── entities/               # Business entities
│   │   ├── repositories/           # Repository interfaces
│   │   └── usecases/               # Business logic
│   ├── presentation/
│   │   ├── pages/                  # Screen pages
│   │   ├── screens/                # UI screens
│   │   ├── widgets/                # Reusable widgets
│   │   └── controllers/            # State management (Provider)
│   ├── services/
│   │   ├── api_service.dart        # HTTP client
│   │   ├── database_helper.dart    # SQLite helper
│   │   └── encryption_service.dart # Encryption utilities
│   ├── utils/                      # Helper utilities
│   └── main.dart                   # Entry point
├── pubspec.yaml                    # Dependencies
└── README.md
```

### Laravel Backend
```
nirvana-backend/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       ├── AuthController.php
│   │   │       ├── LvmdpInspectionController.php
│   │   │       ├── StpInspectionController.php
│   │   │       └── ...
│   │   └── Middleware/
│   ├── Models/
│   │   ├── User.php
│   │   ├── LvmdpInspection.php
│   │   ├── StpInspection.php
│   │   └── ...
│   └── Services/
├── database/
│   ├── migrations/
│   │   ├── 2024_01_01_000001_create_users_table.php
│   │   └── 2024_01_01_000002_create_inspections_tables.php
│   ├── factories/
│   └── seeders/
├── routes/
│   └── api.php                     # API routes
├── .env.example                    # Environment template
└── composer.json                   # PHP dependencies
```

## 🚀 Setup & Installation

### Backend Setup

1. **Clone repository dan install dependencies**
```bash
cd nirvana-backend
composer install
```

2. **Setup environment**
```bash
cp .env.example .env
php artisan key:generate
```

3. **Konfigurasi database PostgreSQL**
Edit file `.env`:
```
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=nirvana_mobile_db
DB_USERNAME=nirvana_user
DB_PASSWORD=your_secure_password
```

4. **Jalankan migrations**
```bash
php artisan migrate
```

5. **Install Laravel Sanctum**
```bash
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
```

6. **Jalankan server**
```bash
php artisan serve
```

### Frontend Setup

1. **Install Flutter dependencies**
```bash
cd nirvana-mobile
flutter pub get
```

2. **Setup Android/iOS**
```bash
# Android
cd android && ./gradlew clean && cd ..

# iOS
cd ios && pod install && cd ..
```

3. **Jalankan aplikasi**
```bash
# Debug mode
flutter run

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release
```

## 🔐 Keamanan & Enkripsi

### Enkripsi Data
- **AES-256-CBC** untuk enkripsi data sensitif
- **Flutter Secure Storage** untuk kredensial
- **EncryptedSharedPreferences** (Android) / **Keychain** (iOS)

### Autentikasi
- **Laravel Sanctum** untuk API token authentication
- Token-based authentication dengan expiry
- Refresh token mechanism

## 📊 Database Schema

### Tabel Utama
- `users` - Data pengguna
- `lvmdp_inspections` - Inspeksi LVMDP
- `stp_inspections` - Inspeksi STP
- `electrical_logs` - Log listrik
- `water_logs` - Log air
- `checklists` - Checklist shift
- `qr_locations` - Lokasi QR code
- `sync_queue` - Antrian sync offline
- `personal_access_tokens` - API tokens

## 🔄 Sinkronisasi Offline

Aplikasi mendukung mode offline dengan fitur:
1. Penyimpanan lokal menggunakan SQLite
2. Queue untuk operasi CRUD saat offline
3. Auto-sync ketika koneksi tersedia
4. Conflict resolution berdasarkan timestamp

## 📤 Export Reports

Format export yang didukung:
- **PDF**: Laporan formal dengan format template
- **Excel**: Data mentah untuk analisis lebih lanjut

Endpoint API:
- `POST /api/v1/export/pdf` - Generate PDF report
- `POST /api/v1/export/excel` - Generate Excel report

## 🛠️ Tech Stack

| Component | Technology |
|-----------|-----------|
| Mobile App | Flutter 3.x |
| Backend | Laravel 10.x |
| Database | PostgreSQL 14+ |
| Authentication | Laravel Sanctum |
| Encryption | AES-256 |
| State Management | Provider |
| Local Storage | SQLite |
| HTTP Client | Dio |
| QR Scanner | mobile_scanner |
| PDF Export | pdf, printing |
| Excel Export | excel |

## 📝 API Documentation

### Authentication
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/logout` - Logout user
- `GET /api/v1/user` - Get current user

### Inspections
- `GET /api/v1/inspections/lvmdp` - List LVMDP inspections
- `POST /api/v1/inspections/lvmdp` - Create LVMDP inspection
- `GET /api/v1/inspections/stp` - List STP inspections
- `POST /api/v1/inspections/stp` - Create STP inspection
- ... (similar for electrical, water, checklist)

### Sync
- `POST /api/v1/sync` - Sync offline data
- `GET /api/v1/sync/status` - Get sync status

### Export
- `POST /api/v1/export/pdf` - Generate PDF report
- `POST /api/v1/export/excel` - Generate Excel report

## 👥 Tim Development

Aplikasi ini dikembangkan untuk Engineering Department Nirvana Boutique Residence.

## 📄 License

Proprietary - Nirvana Boutique Residence

---

© 2024 Nirvana Digital Mobile. All rights reserved.
