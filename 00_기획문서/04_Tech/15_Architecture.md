# 🏗️ Mom's Time Architecture

> **System Architecture v1.0**

---

# 1. 목적

본 문서는 Mom's Time 서비스의 전체 시스템 아키텍처를 정의한다.

모든 개발은 본 문서를 기준으로 구현한다.

---

# 2. Architecture Principle

Mom's Time는 다음 원칙을 따른다.

- Flutter 기반 Cross Platform
- Firebase 중심 Serverless Architecture
- Clean Architecture
- Feature First
- AI Service Layer 분리
- Component 기반 UI

---

# 3. System Architecture

```text
                    ┌──────────────────────────┐
                    │       Flutter App        │
                    └────────────┬─────────────┘
                                 │
                  ┌──────────────┴──────────────┐
                  │                             │
           Presentation Layer            Service Layer
                  │                             │
                  └──────────────┬──────────────┘
                                 │
                         Domain Layer
                                 │
                                 ▼
                           Repository
                                 │
                 ┌───────────────┼───────────────┐
                 │               │               │
          Firestore        Firebase Auth     Storage
                 │               │               │
                 └───────────────┬───────────────┘
                                 │
                         Cloud Functions
                                 │
                 ┌───────────────┴───────────────┐
                 │                               │
             OpenAI API                    Firebase FCM
```

---

# 4. Technology Stack

## Frontend

- Flutter
- Dart
- Material 3

---

## State Management

- Riverpod

---

## Navigation

- GoRouter

---

## Local Database

- Hive

---

## Backend

- Firebase

---

## Database

- Cloud Firestore

---

## Authentication

- Firebase Authentication

---

## File Storage

- Firebase Storage

---

## Notification

- Firebase Cloud Messaging

Flutter Local Notifications

---

## Backend Logic

- Cloud Functions

---

## AI

- OpenAI API

---

## Analytics

- Firebase Analytics

---

## Crash

- Firebase Crashlytics

---

# 5. Layer Architecture

## Presentation

화면(UI)

예)

- Home
- Medication
- Calendar

---

## Widget

재사용 UI

예)

- TodayCard
- MedicationCard
- PrimaryButton

---

## ViewModel

UI 상태 관리

Riverpod Provider

---

## Domain

Business Logic

예)

- Medication
- AI
- Health

---

## Repository

Data Interface

예)

MedicationRepository

HealthRepository

AIRepository

---

## DataSource

실제 데이터

- Firestore
- Hive
- API

---

# 6. Feature Module

```text
lib/

features/

home/

medication/

calendar/

health/

ai/

mypage/
```

모든 기능은 독립적으로 관리한다.

---

# 7. Data Flow

```text
User

↓

UI

↓

ViewModel

↓

UseCase

↓

Repository

↓

Firestore

↓

Response

↓

UI Update
```

---

# 8. AI Flow

```text
User

↓

AI Request

↓

Cloud Functions

↓

OpenAI API

↓

Response

↓

Firestore History

↓

UI
```

Cloud Functions를 통해 AI API Key를 보호한다.

---

# 9. Notification Flow

```text
Cloud Scheduler

↓

Cloud Functions

↓

FCM

↓

Flutter

↓

Local Notification

↓

User Action
```

---

# 10. Authentication Flow

```text
Login

↓

Firebase Auth

↓

User Profile

↓

Firestore

↓

Home
```

---

# 11. Offline Strategy

Hive를 이용하여 다음 데이터를 캐싱한다.

- 사용자 프로필
- 오늘 복약
- 오늘 일정
- 최근 AI 브리핑

오프라인에서도 조회가 가능하도록 설계한다.

---

# 12. Security

- Firebase Authentication
- Firestore Security Rules
- HTTPS Only
- API Key 서버 보관
- 최소 권한 원칙(Least Privilege)

---

# 13. Scalability

향후 확장을 고려한다.

- AI Provider 교체
- Wearable 연동
- Apple Health
- Health Connect
- 병원 시스템 연동

Repository 패턴을 유지하여 외부 서비스 변경 시 UI 수정 없이 대응한다.

---

# 14. Folder Architecture

```text
lib/
│
├── core/
├── shared/
├── features/
├── services/
├── routes/
├── theme/
├── widgets/
└── main.dart
```

---

# 15. Architecture Principles

모든 기능은 다음 구조를 따른다.

```text
Feature

↓

Screen

↓

ViewModel

↓

UseCase

↓

Repository

↓

DataSource
```

Business Logic은 UI에 작성하지 않는다.

---

# 16. Error Handling

오류는 Repository Layer에서 표준화한다.

모든 API 및 Firestore 요청은 Result 타입(성공/실패)을 반환하며, UI는 사용자 친화적인 메시지만 표시한다.

---

# 17. Performance

목표 성능

- 앱 실행 3초 이내
- 화면 전환 300ms 이하
- Firestore 응답 평균 500ms 이하
- AI 응답 10초 이내

---

# 18. Architecture Summary

Mom's Time는

**Flutter + Firebase + AI** 기반의 Serverless Architecture를 채택한다.

모든 기능은 Feature Module 단위로 개발하며,

Business Logic과 UI를 분리하여 유지보수성과 확장성을 확보한다.

AI는 Cloud Functions를 통해 외부 서비스와 통신하며,

사용자는 빠르고 안전한 건강 관리 서비스를 경험할 수 있도록 설계한다.