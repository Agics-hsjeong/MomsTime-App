# 📁 Mom's Time Flutter Structure

> **Flutter Project Structure Guide v1.0**

---

# 1. 목적

본 문서는 Mom's Time Flutter 프로젝트의 폴더 구조를 정의한다.

프로젝트는 **Feature First Architecture**를 기본 원칙으로 한다.

---

# 2. Architecture

```text
Feature First

+

Riverpod

+

Repository Pattern

+

Firebase
```

---

# 3. Project Structure

```text
lib/
│
├── app/
│   ├── app.dart
│   ├── bootstrap.dart
│   ├── router/
│   ├── theme/
│   └── config/
│
├── core/
│   ├── constants/
│   ├── enums/
│   ├── errors/
│   ├── extensions/
│   ├── utils/
│   ├── services/
│   ├── logger/
│   ├── network/
│   └── storage/
│
├── shared/
│   ├── widgets/
│   ├── components/
│   ├── dialogs/
│   ├── bottom_sheet/
│   ├── models/
│   └── providers/
│
├── features/
│
│   ├── auth/
│   ├── onboarding/
│   ├── home/
│   ├── medication/
│   ├── calendar/
│   ├── health/
│   ├── ai/
│   ├── report/
│   ├── family/
│   └── mypage/
│
├── firebase/
│
├── generated/
│
└── main.dart
```

---

# 4. Feature Structure

모든 Feature는 동일한 구조를 사용한다.

예)

```text
features/

medication/

├── models/

├── repositories/

├── providers/

├── services/

├── screens/

├── widgets/

└── medication_feature.dart
```

---

# 5. Home Feature

```text
home/

├── models/

├── providers/

├── repositories/

├── screens/

│      home_screen.dart

├── widgets/

│      today_card.dart

│      ai_card.dart

│      medication_card.dart

│      quick_action.dart

└── home_feature.dart
```

---

# 6. Medication Feature

```text
medication/

├── models/

├── repositories/

├── providers/

├── services/

├── screens/

│      medication_screen.dart

│      medication_detail_screen.dart

│      medication_add_screen.dart

├── widgets/

│      medication_tile.dart

│      medication_card.dart

└── medication_feature.dart
```

---

# 7. Shared Folder

공통 컴포넌트

```text
shared/

widgets/

PrimaryButton

SecondaryButton

AppTextField

LoadingWidget

EmptyWidget
```

---

# 8. Core Folder

프로젝트 공통 기능

```text
core/

constants/

utils/

extensions/

logger/

services/

network/
```

---

# 9. Theme

```text
theme/

app_theme.dart

colors.dart

typography.dart

spacing.dart

radius.dart
```

---

# 10. Router

```text
router/

app_router.dart

route_name.dart

route_path.dart

guards.dart
```

GoRouter 사용

---

# 11. Repository

Repository는

Feature 내부에 위치한다.

예)

```text
medication/

repositories/

medication_repository.dart
```

---

# 12. State Management

Riverpod 사용

Feature마다 Provider를 분리한다.

```text
providers/

home_provider.dart

medication_provider.dart

health_provider.dart
```

---

# 13. Firebase

```text
firebase/

auth_service.dart

firestore_service.dart

storage_service.dart

messaging_service.dart
```

Firebase 초기화 및 공통 서비스 관리

---

# 14. AI

```text
features/

ai/

repositories/

services/

providers/

screens/

widgets/
```

OpenAI 호출은 Cloud Functions를 통해 처리한다.

---

# 15. Assets

```text
assets/

images/

icons/

illustrations/

animations/

fonts/

lottie/
```

---

# 16. Localization

```text
l10n/

app_ko.arb

app_en.arb
```

초기에는 한국어를 기본으로 하며, 다국어 확장을 고려한다.

---

# 17. Naming Convention

파일

```text
snake_case.dart
```

클래스

```text
PascalCase
```

변수

```text
camelCase
```

Widget

```text
HomeScreen

MedicationCard

PrimaryButton
```

---

# 18. Dependency Rule

허용되는 의존성

```text
Screen
    ↓
Provider
    ↓
Repository
    ↓
Firebase / API
```

Screen 간 직접 의존은 금지한다.

공통 기능은 `shared` 또는 `core`를 사용한다.

---

# 19. Feature Independence

각 Feature는 독립적으로 개발 가능해야 한다.

예를 들어

- Medication
- Health
- Calendar

는 서로의 내부 구조를 참조하지 않는다.

공유가 필요한 경우 `shared`를 사용한다.

---

# 20. Example Tree

```text
lib/
│
├── app/
├── core/
├── shared/
├── features/
│   ├── auth/
│   ├── onboarding/
│   ├── home/
│   ├── medication/
│   ├── calendar/
│   ├── health/
│   ├── ai/
│   ├── report/
│   ├── family/
│   └── mypage/
│
├── firebase/
├── generated/
└── main.dart
```

---

# 21. Structure Principles

- Feature 중심으로 개발한다.
- 공통 UI는 `shared`에서 관리한다.
- 비즈니스 로직은 Repository에 작성한다.
- Firebase 접근은 서비스 계층으로 캡슐화한다.
- Riverpod로 상태를 관리한다.
- GoRouter로 화면 이동을 관리한다.
- 모든 Feature는 독립성과 재사용성을 고려한다.

---

# 22. Summary

Mom's Time는 **Feature First Architecture**를 기반으로 한다.

이를 통해 기능 단위의 개발과 유지보수를 쉽게 하고,

새로운 기능 추가나 팀 협업 시에도 일관된 프로젝트 구조를 유지한다.

Flutter, Firebase, Riverpod, GoRouter를 중심으로 확장 가능한 구조를 지향한다.