# 🧠 Mom's Time State Management

> **State Management Guideline v1.0**

---

# 1. 목적

본 문서는 Mom's Time Flutter 프로젝트의 상태 관리 전략을 정의한다.

프로젝트는 **Riverpod 3**를 기반으로 상태를 관리하며,

모든 Feature는 동일한 상태 관리 원칙을 따른다.

---

# 2. 기본 원칙

Mom's Time는

- Feature First Architecture
- Repository Pattern
- Riverpod 3
- Async First

를 기본 원칙으로 한다.

---

# 3. State Flow

```text
UI

↓

Notifier / AsyncNotifier

↓

Repository

↓

Firebase / API

↓

Notifier

↓

UI
```

UI는 Repository를 직접 호출하지 않는다.

---

# 4. Provider 종류

## Provider

읽기 전용 객체

사용 예

- Repository
- Service
- Utility

예시

- MedicationRepository
- AIRepository
- NotificationService

---

## NotifierProvider

동기 상태

사용 예

- Theme
- Settings
- Navigation
- Filter

---

## AsyncNotifierProvider ⭐⭐⭐⭐⭐

비동기 상태

사용 예

- Login
- Home
- Medication
- Health
- AI
- Report

프로젝트 기본 Provider

---

## StreamProvider

실시간 데이터

사용 예

- Firestore Snapshot
- Notification Stream
- Auth State

---

# 5. Feature 구조

```text
feature/

providers/

home_provider.dart

medication_provider.dart

health_provider.dart
```

Feature마다 Provider를 분리한다.

---

# 6. Repository Pattern

모든 비즈니스 로직은 Repository에 작성한다.

```text
Screen

↓

Notifier

↓

Repository

↓

Firestore
```

---

# 7. Home State

관리 데이터

- Today Care
- 오늘 복약
- 오늘 일정
- AI 브리핑

Provider

```dart
HomeNotifier
```

---

# 8. Medication State

관리 데이터

- 약 목록
- 복약 기록
- 복약 완료
- 알림

Provider

```dart
MedicationNotifier
```

---

# 9. Health State

관리 데이터

- 체중
- 혈압
- 혈당
- 물

Provider

```dart
HealthNotifier
```

---

# 10. AI State

관리 데이터

- 브리핑
- AI 답변
- 채팅

Provider

```dart
AINotifier
```

---

# 11. Authentication State

관리 데이터

- 로그인
- 사용자
- 토큰

Provider

```dart
AuthNotifier
```

---

# 12. Loading State

Loading은

Provider 내부에서 관리한다.

UI에서 bool loading을 사용하지 않는다.

---

예)

```text
Loading

↓

Data

↓

Error
```

---

# 13. Error State

모든 Provider는

동일한 Error 구조를 사용한다.

예)

- Network
- Permission
- Validation

---

# 14. AsyncValue 활용

모든 비동기 화면은

다음 세 가지 상태를 가진다.

- Loading
- Data
- Error

UI는 AsyncValue를 기반으로 처리한다.

---

# 15. Refresh

새로고침은

Provider를 invalidate하여 수행한다.

직접 setState를 사용하지 않는다.

---

# 16. State Scope

전역 상태

- Auth
- Theme
- Locale

---

Feature 상태

- Medication
- Calendar
- Health
- Home

---

Local 상태

Widget 내부에서 관리

예)

TextField

Animation

PageController

---

# 17. Dependency

```text
Screen

↓

Provider

↓

Repository

↓

Firebase
```

Provider끼리 직접 의존하지 않는다.

필요한 경우 Repository를 통해 데이터를 공유한다.

---

# 18. Auto Dispose

일시적인 화면은

AutoDispose를 사용한다.

예)

- Search
- AI Chat
- Add Medication

메인 화면은 유지한다.

---

# 19. Offline

Provider는

Hive 캐시를 우선 읽고,

이후 Firestore와 동기화한다.

```text
Hive

↓

Firestore

↓

UI
```

---

# 20. Naming Convention

Provider

```dart
homeProvider

authProvider
```

Notifier

```dart
HomeNotifier

MedicationNotifier
```

State

```dart
HomeState

MedicationState
```

Repository

```dart
MedicationRepository
```

---

# 21. Best Practice

- UI는 상태만 표현한다.
- 비즈니스 로직은 Repository에 둔다.
- AsyncNotifier를 기본으로 사용한다.
- Firestore 직접 접근은 Repository만 수행한다.
- Feature별 Provider를 분리한다.
- AsyncValue로 Loading, Data, Error를 일관되게 처리한다.

---

# 22. Summary

Mom's Time는 **Riverpod 3**를 기반으로 상태를 관리한다.

모든 상태는 Feature 단위로 분리하며,

UI는 Provider를 통해서만 데이터를 읽고 변경한다.

이를 통해 유지보수성과 테스트 용이성을 확보하고,

Firebase 및 AI 기능과의 연동을 일관된 방식으로 구현한다.