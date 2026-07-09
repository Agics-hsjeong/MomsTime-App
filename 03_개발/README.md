# 03_개발 — Mom's Time (Flutter)

`mom_time` · 버전 `0.4.0+31` · Flutter (Material 3)

기획(`00_기획문서`) · 디자인(`01. 디자인`) · 퍼블리싱(`02_퍼블리싱`)을 기반으로 한 앱 구현 단계입니다.

---

## 실행

```bash
cd 03_개발
flutter pub get
flutter run          # 실행
flutter analyze      # 정적 분석 (현재 0 issues)
flutter test         # 테스트
```

---

## Firebase 연동 설정

앱은 **Firebase 미설정 상태에서도 목업(mock)으로 동작**하도록 만들어져 있습니다.
실제 인증/데이터 저장을 활성화하려면 아래를 진행하세요.

```bash
# 1. CLI 도구 설치 (최초 1회)
dart pub global activate flutterfire_cli
npm install -g firebase-tools

# 2. Firebase 로그인 (브라우저 인증 — 최초 1회)
firebase login

# 3. 프로젝트 연결 (momstime-app)
cd 03_개발
./scripts/firebase_configure.sh
# 또는 직접 실행:
# flutterfire configure --project=momstime-app --yes --platforms=android,ios,web
```

- `flutterfire configure` 를 실행하면 `lib/firebase_options.dart` 의 `REPLACE_ME`
  placeholder가 실제 값으로 교체되고, `DefaultFirebaseOptions.isConfigured` 가
  `true` 가 되어 앱이 자동으로 Firebase에 연결됩니다.
- **Firebase 콘솔에서 활성화 필요**: Authentication(이메일/비밀번호, Google),
  Cloud Firestore.
- Firestore Database 생성 후 `firestore.rules` 를 배포하세요:

```bash
cd 03_개발
firebase deploy --only firestore:rules --project momstime-app
```

### Cloud Functions 배포 (AI/푸시)

앱의 AI 기능은 기본적으로 로컬 폴백으로 동작하지만, **실제 AI 응답/푸시 발송**을 위해
Cloud Functions를 배포할 수 있습니다.

```bash
cd 03_개발/functions
npm install

# (선택) Gemini API 키를 사용하려면 환경변수로 설정 후 배포
# macOS/zsh 예시:
export GEMINI_API_KEY="YOUR_KEY"

cd ..
firebase deploy --only functions --project momstime-app
```

- `askAI`, `generateDailyBriefing`, `sendNotification` 이 배포됩니다.
- `GEMINI_API_KEY`가 없으면 Functions는 안전한 기본 응답(폴백)을 반환합니다.

### (무료 플랜) .env로 Gemini 직접 호출 (MVP/개인 테스트용)

Blaze 업그레이드 없이도 Gemini를 쓰고 싶다면, 앱에서 **Gemini API를 직접 호출**하도록
`.env`를 사용할 수 있습니다. (단, 키가 앱 바이너리에 포함될 수 있어 운영용으로는 권장하지 않아요.)

1) `03_개발/.env.example`를 `03_개발/.env`로 복사 후 키 입력
2) 실행

`.env`는 `.gitignore`에 포함되어 git에 올라가지 않습니다.

- Google 로그인은 iOS/Android 각 플랫폼 설정(`GoogleService-Info.plist`,
  `google-services.json`, SHA 지문 등)이 추가로 필요합니다.

### Firestore 컬렉션 구조

```
users/{uid}                         # 프로필 (nickname, pregnancyStage, ...)
users/{uid}/medications/{id}        # 복약 등록
users/{uid}/medication_logs/{id}    # 복용 체크 기록
users/{uid}/health_records/{id}     # 건강기록(혈압/체중/혈당 등)
users/{uid}/schedules/{id}          # 캘린더 일정
users/{uid}/notifications/{id}    # 앱 알림 목록
users/{uid}/ai_chats/{id}           # AI 채팅 기록
users/{uid}/ai_briefings/{id}       # AI 일일 브리핑
```

### Cloud Functions (서버 배포 필요)

| 함수 | 용도 |
|---|---|
| `askAI` | AI 건강 상담 응답 생성 |
| `generateDailyBriefing` | 오늘의 AI 브리핑 생성 |
| `sendNotification` | FCM 푸시 발송 |

Functions 미배포 시에도 앱은 **로컬 폴백 응답**으로 동작합니다.
배포 후 `askAI`, `generateDailyBriefing` callable 함수가 자동으로 연결됩니다.

### FCM 추가 설정

- iOS: Xcode에서 Push Notifications capability 활성화
- Android: `google-services.json` 적용 후 알림 권한 허용
- 앱 실행 후 로그인하면 FCM 토큰이 `users/{uid}.fcmToken`에 저장됩니다

### 화면 크기 (ScreenUtil)

- **디자인 기준**: `420 × 912` (퍼블리싱 `--app-max-width: 420px` 와 동일)
- **앱 프레임**: `AppFrame` — 최대 420px 고정, 태블릿/데스크톱에서는 가운데 정렬 + 바깥 배경 `#EFE6E9`
- **크기 토큰**: `core/theme/app_sizes.dart` — `.w` / `.h` / `.sp` / `.r` 기반

첫 실행 시 **디자인 토큰 쇼케이스 화면**(`DesignShowcasePage`)이 뜹니다 — 팔레트·타이포·버튼이 시안대로 나오면 테마가 정상 반영된 것입니다.

---

## 폴더 구조

```
lib/
  main.dart                  # 진입점
  app.dart                   # MaterialApp + 테마
  core/
    theme/
      app_colors.dart        # 컬러 토큰 (common.css 대응)
      app_typography.dart    # 타입 스케일 (Pretendard)
      app_dimens.dart        # Radius / Spacing / Elevation
      app_theme.dart         # ThemeData (Material 3)
    router/                  # (예정) go_router
    constants/
  features/                  # 화면 흐름별 모듈 (presentation/ 하위 구현)
    splash · onboarding · auth · home · medication · calendar
    ai_care · health · checkup · family · report · premium · mypage
    dev/design_showcase_page.dart
  shared/widgets/            # 공통 위젯 (버튼·카드·칩 등)
assets/
  fonts/                     # ← Pretendard 폰트 파일 추가 위치
  images/
```

---

## 디자인 → 코드 매핑

| 퍼블리싱(CSS) | Flutter |
|---|---|
| `common.css` `:root` 변수 | `core/theme/app_colors.dart`, `app_dimens.dart` |
| 타입 스케일 | `core/theme/app_typography.dart` |
| 컴포넌트(.btn/.card/.input) | `AppTheme` + `shared/widgets/` |
| 화면 HTML | `features/<name>/presentation/` |
| 화면 흐름 | (예정) `core/router/app_router.dart` |

---

## 다음 할 일 (0.4.x)

- [x] **Pretendard 폰트** 파일 `assets/fonts/`에 추가 + `pubspec.yaml` fonts 등록
- [x] `go_router` 도입 → Splash → Onboarding(3) → Login → Stage → Home 흐름
- [x] 공통 위젯 위젯화 (PrimaryButton, AppCard, StatusChip, BottomNav 등)
- [x] Firebase 연동 (Auth · Firestore) — 인증/복약/건강기록/캘린더 실데이터 연동
- [x] 메인 탭 5종 구현 (홈 · 복약 · 캘린더 · AI 케어 · 마이페이지)
- [x] 약 등록 4단계 위저드 + OCR 결과 화면
- [x] 복약 상세 · 복약 완료 · AI 채팅 화면
- [x] 복약 CRUD (등록·복용체크·수정·삭제) 연동
- [x] 건강기록 추가·조회, 캘린더 일정 추가·조회
- [x] FCM 푸시 알림, AI 케어 백엔드 연동

> 버전·변경 이력은 `05_릴리즈노트/`(CHANGELOG · VERSION · RELEASE_NOTES)에 계속 기록합니다.
