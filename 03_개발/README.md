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

- [ ] **Pretendard 폰트** 파일 `assets/fonts/`에 추가 + `pubspec.yaml` fonts 등록
- [ ] `go_router` 도입 → Splash → Onboarding(3) → Login → Stage → Home 흐름
- [ ] 공통 위젯 위젯화 (PrimaryButton, AppCard, StatusChip, BottomNav 등)
- [ ] Firebase 연동 (Auth · Firestore · FCM) — `00_기획문서/04_Tech`, `05_Database` 참고
- [ ] 화면별 구현 순서: Splash → Onboarding → Login → Home → Medication …

> 버전·변경 이력은 `05_릴리즈노트/`(CHANGELOG · VERSION · RELEASE_NOTES)에 계속 기록합니다.
