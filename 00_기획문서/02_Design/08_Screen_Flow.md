# 🔀 Mom's Time Screen Flow

> **Application Screen Flow v1.0**

---

# 1. 목적

본 문서는 Mom's Time의 전체 화면 이동(Screen Flow)을 정의한다.

모든 화면은 본 문서를 기준으로 설계하며, 화면 추가 및 변경 시 본 문서를 함께 수정한다.

---

# 2. 전체 화면 구조

```text
Launch
│
├── Splash
│
├── Onboarding
│
├── Login
│
├── Pregnancy Step Setup
│
└── Main Application
      │
      ├── Home
      ├── Medication
      ├── Calendar
      ├── Health
      └── My Page
```

---

# 3. 앱 실행 Flow

```text
앱 실행

↓

Splash

↓

자동 로그인 확인

↓

로그인 O
↓

Home

-----------------------

로그인 X

↓

Onboarding

↓

Login

↓

프로필 설정

↓

Home
```

---

# 4. 사용자 초기 설정 Flow

```text
로그인

↓

현재 단계 선택

↓

임신 준비

또는

임신 중

또는

출산 후

↓

예정일 / 출산일 입력

↓

기본 건강정보 입력

↓

Home
```

---

# 5. Main Navigation

```text
┌─────────────────────────┐
│         Home            │
└──────────┬──────────────┘
           │
────────────────────────────────

💊 Medication

📅 Calendar

❤️ Health

👤 My Page
```

Bottom Navigation은 모든 메인 화면에서 동일하게 유지한다.

---

# 6. Home Flow

```text
Home

│
├── Today Care
│
├── Today's Medication
│
│     └── Medication Detail
│
├── Today's Schedule
│
│     └── Schedule Detail
│
├── AI Briefing
│
│     └── AI Chat
│
└── Next Checkup
```

---

# 7. Medication Flow

```text
Medication

│
├── Medication List
│
├── Add Medication
│
│      ├── OCR
│      ├── Photo
│      └── Manual
│
├── Medication Detail
│
├── Medication Record
│
└── Medication Report
```

---

# 8. Calendar Flow

```text
Calendar

│
├── Monthly Calendar
│
├── Daily Schedule
│
├── Schedule Detail
│
└── Add Schedule
```

---

# 9. Health Flow

```text
Health

│
├── Weight

├── Blood Pressure

├── Blood Sugar

├── Water Intake

└── Exercise
```

---

# 10. AI Flow

AI는 독립 메뉴가 아니라 서비스 전반에 포함된다.

진입 경로

```text
Home

↓

AI Briefing

↓

AI Chat
```

또는

```text
Medication Detail

↓

AI Medication Guide
```

또는

```text
Medication Report

↓

AI Analysis
```

---

# 11. My Page Flow

```text
My Page

│
├── Profile
│
├── Notification
│
├── Family
│
├── Account
│
├── Privacy
│
└── App Info
```

---

# 12. Medication Registration Flow

```text
Medication

↓

Add Medication

↓

OCR
   │
   ├── Recognition Result
   │
   └── Confirm

-----------------------

Manual Input

↓

Save

↓

Medication List
```

---

# 13. Daily Medication Flow

```text
Notification

↓

Medication Reminder

↓

Completed

↓

Today's Progress Update

↓

AI Feedback
```

---

# 14. AI Consultation Flow

```text
AI Briefing

↓

Ask Question

↓

AI Answer

↓

Related Guide

↓

Finish
```

---

# 15. Checkup Flow

```text
Home

↓

Next Checkup

↓

Checkup Detail

↓

Calendar

↓

Reminder
```

---

# 16. Family Flow

```text
My Page

↓

Family

↓

Invite Partner

↓

Invitation Accepted

↓

Shared Dashboard
```

---

# 17. Empty Flow

등록된 데이터가 없는 경우

```text
Empty

↓

Guide Message

↓

Primary Action

↓

Create First Data
```

예시

- 첫 번째 약 등록하기
- 첫 번째 건강기록 작성하기

---

# 18. Error Flow

```text
Network Error

↓

Retry

↓

Success

또는

Customer Support
```

---

# 19. Permission Flow

앱 최초 실행

```text
Notification Permission

↓

Camera Permission

↓

Photo Permission

↓

Completed
```

필요한 시점에만 권한을 요청한다.

---

# 20. Logout Flow

```text
My Page

↓

Settings

↓

Logout

↓

Confirm

↓

Login
```

---

# 21. UX Flow Principle

모든 주요 기능은 다음 원칙을 따른다.

- 3회 이하의 터치로 접근 가능
- 주요 기능은 Home에서 바로 진입 가능
- 사용자는 현재 위치를 항상 인지할 수 있어야 함
- 완료 후에는 이전 화면이 아닌 "자연스러운 다음 행동"으로 연결

---

# 22. MVP Screen List

## Launch

- Splash
- Onboarding
- Login
- Step Setup

---

## Main

- Home
- Medication
- Calendar
- Health
- My Page

---

## Sub

- Medication Detail
- Add Medication
- OCR
- Medication Record
- Medication Report
- Schedule Detail
- AI Chat
- Family
- Notification
- Settings

---

# 23. Navigation Rule

메인 메뉴 이동은 Bottom Navigation을 사용한다.

세부 기능은

- Push
- Bottom Sheet
- Dialog
- Modal

중 가장 적합한 방식을 사용한다.

새로운 화면을 만드는 것보다

기존 화면 내에서 해결 가능한 UX를 우선 고려한다.

---

# 24. Screen Flow Summary

Mom's Time의 모든 화면은 하나의 목표를 향한다.

> **"오늘 해야 할 건강 관리를 가장 쉽고 자연스럽게 완료하도록 돕는다."**

사용자는 앱을 열면

1. 오늘 해야 할 일을 확인하고
2. 필요한 행동을 바로 수행하며
3. AI의 도움을 받아 건강한 습관을 이어간다.

이것이 Mom's Time의 핵심 Screen Flow이다.