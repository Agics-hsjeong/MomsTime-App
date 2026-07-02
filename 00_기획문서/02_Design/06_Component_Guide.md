# 🧩 Mom's Time Component Guide

> **Component Design Specification v1.0**

---

# 1. 목적

본 문서는 Mom's Time에서 사용하는 모든 UI Component를 정의한다.

모든 화면(Screen)은 본 문서의 Component를 조합하여 구성한다.

Component의 목적은 다음과 같다.

- UI 일관성 유지
- 재사용성 향상
- Flutter Widget 표준화
- Figma Component 통일

---

# 2. Component Structure

```text
Foundation
      │
      ▼
Basic Component
      │
      ▼
Business Component
      │
      ▼
Screen
```

---

# 3. Foundation

## Color

Design System 참조

---

## Typography

Design System 참조

---

## Radius

Design System 참조

---

## Shadow

Design System 참조

---

# 4. Basic Component

가장 작은 단위의 UI

---

## Primary Button

### 사용 목적

주요 액션

### 사용 예

- 저장
- 복약 완료
- 시작하기

### Flutter

```dart
PrimaryButton()
```

---

## Secondary Button

사용 목적

취소

닫기

나중에

---

Flutter

```dart
SecondaryButton()
```

---

## Ghost Button

배경 없음

텍스트만

---

## Icon Button

원형 버튼

예)

뒤로가기

삭제

편집

---

## Floating Action Button

사용

약 등록

---

# 5. Input Component

## TextField

지원

- Placeholder
- Label
- Error
- Helper

Flutter

```dart
AppTextField()
```

---

## SearchField

검색

---

## Time Picker

복약 시간

---

## Date Picker

예정일

---

## Step Selector

```text
○ 임신 준비

○ 임신 중

○ 출산 후
```

---

# 6. Navigation

## Bottom Navigation

메뉴

🏠 홈

💊 복약

📅 캘린더

❤️ 건강

👤 마이

Flutter

```dart
AppBottomNavigation()
```

---

## App Bar

지원

- Title
- Back
- Action

---

# 7. Card Component

Mom's Time의 핵심 컴포넌트

---

## TodayCard ⭐⭐⭐⭐⭐

가장 중요한 카드

표시

- 오늘 복약
- 오늘 일정
- AI 브리핑

Flutter

```dart
TodayCard()
```

---

## MedicationCard ⭐⭐⭐⭐⭐

약

영양제

표시

Flutter

```dart
MedicationCard()
```

---

## ScheduleCard

검사

병원

Flutter

```dart
ScheduleCard()
```

---

## HealthCard

체중

혈압

혈당

Flutter

```dart
HealthCard()
```

---

## AIAdviceCard ⭐⭐⭐⭐⭐

AI 추천

주의사항

브리핑

Flutter

```dart
AIAdviceCard()
```

---

## ReportCard

통계

복약률

Flutter

```dart
ReportCard()
```

---

# 8. List Component

## MedicationTile

약 리스트

---

## ScheduleTile

일정

---

## HealthTile

건강기록

---

## SettingTile

설정

---

# 9. Status Component

## Chip

예)

오늘

철분

AI

18주

---

## Badge

예)

NEW

추천

AI

---

## Progress

Circle

Linear

---

# 10. Dialog

## Confirm Dialog

삭제

확인

---

## Success Dialog

복약 완료

---

## AI Recommendation Dialog

AI 추천

---

# 11. Bottom Sheet

사용

약 상세

AI 설명

일정 상세

---

# 12. Notification Component

복약 알림

---

검사 알림

---

물 마시기

---

# 13. Chart

Line Chart

---

Bar Chart

---

Progress Circle

---

# 14. Empty State

약 없음

---

일정 없음

---

기록 없음

---

# 15. Loading

Skeleton

---

Loading

---

# 16. Snackbar

저장 완료

삭제 완료

복약 완료

---

# 17. Business Component

여기서부터는

Mom's Time 전용

---

## Today Care Widget ⭐⭐⭐⭐⭐

홈 최상단

구성

- 인사
- 오늘 날짜
- 임신 주수
- 오늘 일정

Flutter

```dart
TodayCareWidget()
```

---

## Medication Schedule Widget

오늘 약

오늘 영양제

---

## Daily Briefing Widget ⭐⭐⭐⭐⭐

AI 브리핑

---

## Water Tracker Widget

물

---

## Weight Widget

체중

---

## Blood Pressure Widget

혈압

---

## Health Summary Widget

건강 요약

---

## Next Checkup Widget

다음 검사

---

## Weekly Report Widget

주간 리포트

---

## Family Widget

배우자

---

# 18. Screen Template

모든 화면은 동일한 구조를 사용한다.

```text
AppBar

↓

Header

↓

Content

↓

Bottom CTA

↓

Bottom Navigation
```

---

# 19. Naming Convention

Flutter

```dart
TodayCard

MedicationCard

HealthCard

AIAdviceCard

PrimaryButton

SecondaryButton

MedicationTile

StatusChip

ProgressCircle

AppBottomNavigation

AppTextField
```

---

# 20. Component Priority

## ⭐⭐⭐⭐⭐

TodayCard

MedicationCard

AIAdviceCard

PrimaryButton

BottomNavigation

---

## ⭐⭐⭐⭐☆

ScheduleCard

HealthCard

ProgressCircle

AppBar

Dialog

---

## ⭐⭐⭐☆☆

Badge

Chip

Loading

Snackbar

EmptyState

---

# 21. Design Rule

모든 Component는 다음 원칙을 따른다.

- Radius 통일
- Padding 통일
- Color Token 사용
- Typography Token 사용
- Shadow 최소화
- Component 재사용 우선

---

# 22. Flutter Architecture Mapping

```text
lib/

widgets/

button/

card/

dialog/

navigation/

input/

chart/

tile/

chip/

badge/

screen/

home/

medication/

calendar/

health/

mypage/
```

---

# 23. Future Components

향후 추가 예정

- OCR Card
- AI Chat Bubble
- Voice Input
- Smart Reminder Card
- Family Timeline
- AI Health Score
- Habit Card
- Weekly Mission Card

---

# Component Principle

Mom's Time의 모든 화면은

새로운 UI를 만드는 것이 아니라,

이미 정의된 Component를 조합하여 구성하는 것을 원칙으로 한다.

이를 통해 일관된 사용자 경험과 높은 개발 생산성을 유지한다.