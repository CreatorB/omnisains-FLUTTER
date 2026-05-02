# Flutter MVP Plan - Omnisains Mobile App

## Overview

Flutter app untuk memenuhi requirement Play Store agar akun tidak ditutup Google.

## MVP Features (1-2 Minggu)

### Week 1: Foundation & Auth

#### Day 1-2: Setup & API Integration
- [x] Project skeleton created
- [ ] `flutter pub get` & setup dependencies
- [ ] Run `flutter pub run build_runner build`
- [ ] Update `api_client.dart` - test connection to Go API
- [ ] Implement AuthRepository (login/register)
- [ ] Create AuthNotifier (Riverpod)

#### Day 3-4: Auth Screens
- [ ] Login screen - implement API call
- [ ] Register screen - implement API call
- [ ] Token storage & auth state management
- [ ] Auto-login check (biarkan di login screen jika no token)

### Week 2: Core Features

#### Day 5-6: Dashboard & Seasons
- [ ] SeasonRepository - implement getActiveSeasons()
- [ ] Dashboard screen - list seasons with FutureBuilder/AsyncValue
- [ ] Season item card UI
- [ ] Loading & error states

#### Day 7-8: Registration Flow
- [ ] Season detail screen
- [ ] StageRepository - getStageByProgram()
- [ ] Registration form (minimal fields: nama, email, phone, kota)
- [ ] CitySelect component (reusable dari FE logic)
- [ ] Submit registration API

#### Day 9: Profile & Settings
- [ ] ProfileRepository - getUserProfile()
- [ ] Profile screen - show user info
- [ ] My registrations list
- [ ] Logout functionality

#### Day 10: Privacy Policy (Wajib Play Store)
- [ ] Privacy policy screen (static content)
- [ ] Add route to settings
- [ ] Link to online privacy policy (upload ke omnisains.id/privacy)

#### Day 11-12: Build & Polish
- [ ] App icon & splash screen
- [ ] Material 3 theming (color, typography)
- [ ] Error handling & user feedback (SnackBar)
- [ ] Build test on physical device
- [ ] `flutter build appbundle --release`

## Play Store Requirements

### Technical
- [x] Target SDK 34+ (update android/app/build.gradle)
- [x] Minimum SDK 21 (Flutter default)
- [ ] Only INTERNET permission required
- [ ] App Bundle (.aab) format (NOT .apk)

### Content
- [ ] App must have core functionality (NOT placeholder)
- [ ] Privacy policy screen + online version
- [ ] App icon (512x512)
- [ ] Screenshots (min 2, recommended 4-8)
- [ ] Short description (80 chars)
- [ ] Full description (4000 chars)

### Store Listing
- **Title**: Omnisains - Olimpiade Akademik
- **Category**: Education
- **Content Rating**: Everyone
- **Privacy Policy URL**: https://omnisains.id/privacy

## API Endpoints (Go Backend)

### Auth
```
POST /api/v1/public/auth/login
POST /api/v1/public/auth/register
```

### Public
```
GET /api/v1/public/seasons/active
GET /api/v1/public/season/{id}
GET /api/v1/public/stage?program={program}
GET /api/v1/public/user/profile
GET /api/v1/public/user/registrations
POST /api/v1/public/registration
```

Note: Sesuaikan dengan actual Go API routes.

## Development Workflow

1. **Feature Branch**: `feature/flutter-mvp`
2. **Test**: Flutter dev channel + physical device
3. **Build**: Flutter release channel
4. **Deploy**: Internal test track (Play Console) → Production

## Risks & Mitigation

### Risk: Go API tidak sesuai dokumentasi
**Mitigation**: Test setiap endpoint sebelum implement UI

### Risk: Build issues
**Mitigation**: Pastikan Flutter SDK up-to-date, clean build jika error

### Risk: Play Store rejection
**Mitigation**: Follow semua policy, test internal track dulu

## Timeline Estimation

- **Sprint 1 (5 hari)**: Auth, Dashboard, Seasons
- **Sprint 2 (5 hari)**: Registration, Profile, Build
- **Sprint 3 (2 hari)**: Polish, Play Store submission

**Total: 12 hari kerja** (2.4 minggu)

## Next Steps

1. Review skeleton structure di `omnisains-FLUTTER/`
2. Install Flutter SDK (jika belum)
3. Run `flutter pub get` & `flutter pub run build_runner build`
4. Test API connection ke `https://dev-api.omnisains.id/api/v1/public`
5. Implement auth flow pertama
6. Lanjutkan ke features lain sesuai plan

## Questions?

- Ada auth endpoint spesifik di Go API?
- Apakah registration perlu payment?
- Ada fitur lain yang wajib untuk MVP Play Store?
