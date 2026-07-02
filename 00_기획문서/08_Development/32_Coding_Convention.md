# 📘 Mom's Time Coding Convention

> **Flutter Coding Convention v1.0**

---

# 1. 목적

본 문서는 Mom's Time 프로젝트의 코딩 스타일과 개발 규칙을 정의한다.

모든 개발자는 동일한 규칙을 적용하여 일관성 있는 코드를 작성한다.

---

# 2. 기본 원칙

- 읽기 쉬운 코드
- 명확한 네이밍
- 작은 함수
- 단일 책임 원칙(SRP)
- 중복 코드 최소화(DRY)
- Feature First Architecture 준수

---

# 3. 파일 및 폴더 구조

모든 기능은 Feature 단위로 구성한다.

```text
features/
    home/
    medication/
    calendar/
    health/
    ai/
```

공통 기능은 `shared/`, 프로젝트 공통 코드는 `core/`에 배치한다.

---

# 4. 파일 네이밍

모든 파일은 `snake_case`를 사용한다.

예시

```text
home_screen.dart
medication_repository.dart
health_provider.dart
primary_button.dart
```

---

# 5. 클래스 네이밍

`PascalCase`를 사용한다.

```dart
class HomeScreen {}

class MedicationRepository {}

class PrimaryButton {}
```

---

# 6. 변수 및 메서드

`camelCase`를 사용한다.

```dart
final medicationList = [];

void loadMedications() {}

String formatDate() {}
```

---

# 7. 상수

컴파일 타임 상수는 `lowerCamelCase`를 사용한다.

```dart
const maxRetryCount = 3;
const defaultPadding = 16.0;
```

공통 상수는 `core/constants`에서 관리한다.

---

# 8. Widget 작성 원칙

Widget은 하나의 역할만 가진다.

복잡한 UI는 작은 Widget으로 분리한다.

좋은 예

```text
HomeScreen

↓

TodayCard

↓

MedicationCard

↓

QuickActionCard
```

---

# 9. 상태 관리

- Riverpod 사용
- `AsyncNotifier`를 기본으로 사용
- `setState()`는 화면 내부의 일시적인 UI 상태에만 사용한다.

---

# 10. Repository 규칙

Firestore 및 외부 API 접근은 Repository에서만 수행한다.

```text
Screen

↓

Notifier

↓

Repository

↓

Firestore
```

UI에서 Firestore를 직접 호출하지 않는다.

---

# 11. 비동기 처리

모든 비동기 함수는 `async/await`를 사용한다.

예외 처리는 `try/catch`로 처리한다.

---

# 12. Error Handling

사용자에게 내부 오류 메시지를 그대로 노출하지 않는다.

오류는 Repository에서 공통 형식으로 변환하여 처리한다.

---

# 13. Null Safety

Null Safety를 적극 활용한다.

불필요한 `!` 사용을 지양한다.

---

# 14. Model

모든 데이터 모델은 불변(Immutable) 객체로 작성한다.

권장 라이브러리

- freezed
- json_serializable

---

# 15. 주석 규칙

왜 필요한지 설명하는 주석만 작성한다.

코드가 무엇을 하는지는 코드 자체로 표현한다.

---

# 16. Import 순서

1. Dart SDK
2. Flutter
3. 외부 패키지
4. 프로젝트 내부

각 그룹 사이에는 한 줄을 띄운다.

---

# 17. Logging

`print()`는 사용하지 않는다.

공통 Logger를 사용한다.

로그 레벨

- Debug
- Info
- Warning
- Error

---

# 18. UI 규칙

- Material 3 사용
- Design System 준수
- 색상은 Theme에서 관리
- 하드코딩된 색상 사용 금지
- 하드코딩된 문자열 사용 최소화

---

# 19. Git Commit Convention

형식

```text
type: summary
```

예시

```text
feat: add medication reminder
fix: resolve notification issue
refactor: simplify home provider
docs: update PRD
style: improve dashboard spacing
test: add repository tests
chore: upgrade dependencies
```

---

# 20. Pull Request

PR에는 다음 내용을 포함한다.

- 변경 내용
- 테스트 결과
- 관련 이슈
- UI 변경 시 스크린샷 첨부

---

# 21. 코드 리뷰 원칙

코드 리뷰는 사람을 평가하는 것이 아니라 코드를 개선하기 위한 과정이다.

리뷰에서는

- 가독성
- 유지보수성
- 성능
- 안정성

을 우선적으로 확인한다.

---

# 22. 테스트

권장 테스트

- Repository Unit Test
- Provider Test
- Widget Test

핵심 기능은 테스트를 작성한다.

---

# 23. 성능

- 불필요한 rebuild 방지
- const Widget 적극 활용
- Lazy Loading 적용
- 이미지 최적화

---

# 24. 보안

- API Key는 코드에 포함하지 않는다.
- Secret은 Firebase Secret Manager에서 관리한다.
- 민감한 사용자 정보는 로그에 기록하지 않는다.

---

# 25. Summary

Mom's Time는 **일관성, 가독성, 유지보수성**을 최우선으로 하는 코딩 컨벤션을 따른다.

모든 기능은 Feature First Architecture와 Repository Pattern을 기반으로 구현하며,

Flutter, Riverpod, Firebase의 Best Practice를 준수한다.

프로젝트 전반에 동일한 규칙을 적용하여 장기적으로 확장 가능한 코드베이스를 유지하는 것을 목표로 한다.