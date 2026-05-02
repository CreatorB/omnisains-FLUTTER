# Omnisains Mobile App

Flutter app untuk platform manajemen kompetisi olimpiade akademik Indonesia.

## Build Status

**Debug APK:** `build/app/outputs/flutter-apk/app-debug.apk`

## Tech Stack

- **Framework**: Flutter 3.24+
- **State Management**: Riverpod
- **Navigation**: go_router
- **HTTP**: dio
- **Storage**: shared_preferences
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: 34 (Android 14)
- **Compile SDK**: 36

## Project Structure

```
lib/
|- api/                    # API clients & repositories
|  |- api_client.dart      # Dio HTTP client setup
|  |- auth_repository.dart # Login/Register/Logout
|  |- season_repository.dart
|  |- stage_repository.dart
|  |- wilayah_repository.dart  # Province/City/District/Village
|  `- participation_repository.dart
|- features/
|  |- auth/
|  |  |- login_screen.dart
|  |  `- register_screen.dart
|  |- dashboard/
|  |  |- dashboard_screen.dart  # List stages & my participations
|  |  `- event_detail_screen.dart
|  |- registration/
|  |  `- registration_screen.dart  # CitySelect, form
|  |- profile/
|  |  `- profile_screen.dart
|  `- privacy/
|     `- privacy_policy_screen.dart
|- models/
|  |- user.dart
|  |- season.dart
|  |- stage.dart
|  |- region.dart  # Province, Regency, District, Village
|  `- participation.dart
|- providers/
|  |- auth_provider.dart
|  |- event_provider.dart
|  `- participation_provider.dart
|- utils/
|  `- routes.dart  # go_router setup
`- main.dart
```

## Setup

```bash
cd omnisains-FLUTTER
flutter pub get
flutter build apk --debug
```

## API Endpoints (Go Backend)

### Auth
- `POST /api/v1/auth/login` - Login with email/password
- `POST /api/v1/auth/register` - Register participant
- `POST /api/v1/auth/logout` - Logout

### Public
- `GET /api/v1/events/stages` - List all stages
- `GET /api/v1/public/stage?program=X` - Get public stage info
- `GET /api/v1/wilayah/provinces` - List provinces
- `GET /api/v1/wilayah/regencies?province_code=X` - List cities by province
- `GET /api/v1/wilayah/districts?regency_code=X` - List districts
- `GET /api/v1/wilayah/villages?district_code=X` - List villages
- `GET /api/v1/wilayah/cities/search?q=X` - Search cities

### Auth Required
- `GET /api/v1/participants/me` - Get current user profile
- `GET /api/v1/participations/my` - List user's participations
- `POST /api/v1/participations/register` - Register to stage

## Features MVP

### Phase 1 - Complete ✅
- [x] Login screen
- [x] Register screen with wilayah (province/city/district/village)
- [x] Dashboard - list stages and my participations
- [x] Event detail screen
- [x] Registration form with city select
- [x] Profile screen with user info
- [x] Logout functionality
- [x] Privacy policy screen (Play Store requirement)
- [x] Debug APK build

### Phase 2 - TODO
- [ ] Push notifications
- [ ] Payment integration
- [ ] Certificate download
- [ ] Scoreboard view

## Play Store Submission

### Requirements Met
- [x] App functionality (not placeholder) ✅
- [x] Privacy policy screen ✅
- [x] INTERNET permission only ✅
- [x] Target SDK 34+ ✅
- [x] App Bundle format ready ✅

### Pre-submission Checklist
- [ ] Update version in pubspec.yaml
- [ ] Generate release APK: `flutter build appbundle --release`
- [ ] Upload to Play Console
- [ ] Add privacy policy URL (https://omnisains.id/privacy)
- [ ] Add app screenshots (4-8 screenshots recommended)

## Build Commands

```bash
# Debug APK
flutter build apk --debug

# Release App Bundle (for Play Store)
flutter build appbundle --release

# Clean build
flutter clean && flutter pub get && flutter build apk --debug
```

## Troubleshooting

### Gradle issues
- Update Gradle wrapper: `android/gradle/wrapper/gradle-wrapper.properties`
- Update AGP: `android/settings.gradle` (com.android.application version)
- Update Kotlin: `android/settings.gradle` (org.jetbrains.kotlin.android version)

### Common Build Errors
- `filePermissions` error → Upgrade Gradle to 8.4+
- `NDK` version mismatch → Update ndkVersion in build.gradle
- `compileSdk` too low → Update compileSdk to 36

## Notes

- API base URL: `https://dev-api.omnisains.id/api/v1` (staging)
- For production, update `api_client.dart` to use `https://omnisains.id/api/v1`
- Token stored in SharedPreferences (consider flutter_secure_storage for production)