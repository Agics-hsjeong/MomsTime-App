# 🗺️ Mom's Time Sitemap

> **Application Sitemap v1.0**

---

# 1. 목적

본 문서는 Mom's Time 서비스의 전체 화면 구조(Sitemap)를 정의한다.

Sitemap은 사용자에게 제공되는 모든 화면(Screen)과 화면 간의 계층 구조를 나타낸다.

---

# 2. 전체 구조

```text
Mom's Time

├── Launch
│   ├── Splash
│   ├── Onboarding
│   ├── Login
│   ├── Pregnancy Step Setup
│   └── Profile Setup
│
├── Home
│   ├── Today Care
│   ├── Today's Medication
│   ├── Today's Schedule
│   ├── AI Daily Briefing
│   ├── Next Checkup
│   └── Quick Actions
│
├── Medication
│   ├── Medication List
│   ├── Add Medication
│   │   ├── OCR Scan
│   │   ├── Photo Registration
│   │   └── Manual Input
│   ├── Medication Detail
│   ├── Medication History
│   ├── Medication Statistics
│   └── AI Medication Guide
│
├── Calendar
│   ├── Monthly Calendar
│   ├── Daily Schedule
│   ├── Checkup Schedule
│   ├── Hospital Schedule
│   └── Schedule Detail
│
├── Health
│   ├── Health Dashboard
│   ├── Weight
│   ├── Blood Pressure
│   ├── Blood Sugar
│   ├── Water Intake
│   ├── Exercise
│   └── Health Report
│
├── My Page
│   ├── Profile
│   ├── Family Sharing
│   ├── Notification Settings
│   ├── Account
│   ├── Privacy
│   └── App Information
│
└── Common
    ├── AI Chat
    ├── Bottom Sheet
    ├── Dialog
    ├── Loading
    ├── Empty State
    └── Error
```

---

# 3. 메인 메뉴 구조

```text
🏠 Home
│
├── Today Care
├── Medication Summary
├── Today's Schedule
├── AI Daily Briefing
└── Next Checkup

💊 Medication
│
├── Medication List
├── Add Medication
├── Medication Detail
├── History
└── Statistics

📅 Calendar
│
├── Monthly Calendar
├── Daily Schedule
├── Checkup
└── Schedule Detail

❤️ Health
│
├── Dashboard
├── Weight
├── Blood Pressure
├── Water Intake
├── Exercise
└── Health Report

👤 My
│
├── Profile
├── Family
├── Notification
├── Account
└── Settings
```

---

# 4. 화면 계층(Level)

| Level | 화면 |
|--------|------|
| Level 1 | Splash / Login / Home |
| Level 2 | Medication / Calendar / Health / My |
| Level 3 | Medication Detail / Schedule Detail / Health Detail |
| Level 4 | Dialog / Bottom Sheet / OCR Result |

---

# 5. Bottom Navigation

모든 메인 화면에서 동일하게 유지한다.

```text
🏠 Home

💊 Medication

📅 Calendar

❤️ Health

👤 My
```

---

# 6. 주요 사용자 이동

## 앱 시작

```text
Splash
    ↓
Login
    ↓
Step Setup
    ↓
Home
```

---

## 복약 등록

```text
Home
    ↓
Medication
    ↓
Add Medication
    ↓
Save
    ↓
Medication List
```

---

## 복약 완료

```text
Home
    ↓
Medication Reminder
    ↓
Complete
    ↓
Today Care Update
```

---

## AI 상담

```text
Home
    ↓
AI Daily Briefing
    ↓
AI Chat
```

---

## 검사 일정 확인

```text
Home
    ↓
Next Checkup
    ↓
Schedule Detail
```

---

# 7. Screen Count

## Launch

- Splash
- Onboarding
- Login
- Step Setup
- Profile Setup

**5 Screens**

---

## Main

- Home
- Medication
- Calendar
- Health
- My Page

**5 Screens**

---

## Business

- Medication Detail
- Add Medication
- Medication History
- Medication Statistics
- OCR Scan
- Schedule Detail
- AI Chat
- Health Report
- Family Sharing

**9 Screens**

---

## Common

- Dialog
- Bottom Sheet
- Loading
- Empty State
- Error

**5 Screens**

---

# 총 화면 수

| 구분 | 개수 |
|------|------:|
| Launch | 5 |
| Main | 5 |
| Business | 9 |
| Common | 5 |
| **Total** | **24 Screens** |

---

# 8. 설계 원칙

- 모든 핵심 기능은 Home에서 3회 이내 터치로 접근 가능해야 한다.
- Bottom Navigation은 앱 전체에서 일관성을 유지한다.
- 새로운 화면을 추가하기보다 기존 화면 내 확장(Bottom Sheet, Dialog)을 우선 고려한다.
- 사용자는 현재 위치를 항상 쉽게 인지할 수 있어야 한다.

---

# 9. MVP 기준 화면

출시(v1.0) 시 반드시 포함되는 화면

- Splash
- Login
- Step Setup
- Home
- Medication
- Add Medication
- Medication Detail
- Calendar
- Health
- AI Chat
- My Page

이후 OCR, 리포트, 가족 공유 등의 기능은 점진적으로 확장한다.

---

# Sitemap Summary

Mom's Time는 **"오늘의 건강 루틴"**을 중심으로 설계된 서비스이다.

모든 화면은 사용자가 복잡하게 탐색하는 것이 아니라,

**오늘 해야 할 건강 관리 → 즉시 실행 → 기록 → AI 피드백**

으로 이어지는 단순하고 자연스러운 흐름을 제공하는 것을 목표로 한다.