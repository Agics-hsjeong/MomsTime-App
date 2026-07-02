# 📱 Mom's Time Screen List

> **Mom's Time UI/UX Screen Specification v1.0**

---

# Overview

Mom's Time는 총 **32개의 화면**으로 구성된다.

- **메인 페이지** : 15개
- **서브 페이지** : 17개

---

# 📱 A. Main Pages (15)

| No | Screen | Description |
|----|--------|-------------|
| 01 | Splash | 앱 실행 및 로고 표시 |
| 02 | Login | 로그인 및 회원가입 |
| 03 | Onboarding | 서비스 소개 및 시작 |
| 04 | Stage | 임신 단계 선택 (임신 준비 / 임신 중 / 출산 후) |
| 05 | Home | Today Care Dashboard |
| 06 | Medication | 복약 관리 |
| 07 | Register | 약/영양제 등록 |
| 08 | Calendar | 일정 및 캘린더 |
| 09 | AI Care | AI 케어 메인 |
| 10 | Health | 건강 기록 |
| 11 | Checkup | 검사 일정 |
| 12 | Family | 가족 공유 |
| 13 | Report | 건강 리포트 |
| 14 | Premium | Mom+ Premium 소개 |
| 15 | My Page | 마이페이지 및 설정 |

---

# 📱 B. Sub Pages (17)

| No | Screen | Description |
|----|--------|-------------|
| 16 | Medication Detail | 약 상세 정보 |
| 17 | OCR Result | OCR 인식 결과 |
| 18 | Medication Complete | 복약 완료 화면 |
| 19 | Medication Edit | 복약 정보 수정 |
| 20 | AI Chat | AI 상담 |
| 21 | AI Briefing | AI 하루 브리핑 |
| 22 | Checkup Detail | 검사 상세 |
| 23 | Hospital Detail | 병원 정보 |
| 24 | Supplement Detail | 영양제 상세 |
| 25 | Family Invite | 배우자 및 가족 초대 |
| 26 | Notification | 알림 설정 |
| 27 | Profile Edit | 프로필 수정 |
| 28 | Statistics Detail | 통계 상세 |
| 29 | Subscription | 구독 관리 |
| 30 | Payment | 결제 및 결제수단 관리 |
| 31 | Coupon | 쿠폰 및 프로모션 |
| 32 | Store | 제휴 스토어 |

---

# 📊 Screen Summary

| Category | Count |
|----------|------:|
| Main Pages | 15 |
| Sub Pages | 17 |
| **Total** | **32** |

---

# Navigation Structure

```text
Splash
   │
   ▼
Login
   │
   ▼
Onboarding
   │
   ▼
Stage Selection
   │
   ▼
Home
   ├── Medication
   ├── Calendar
   ├── AI Care
   ├── Health
   ├── Checkup
   ├── Family
   ├── Report
   ├── Premium
   └── My Page
```

---

# Bottom Navigation

```text
🏠 Home

💊 Medication

📅 Calendar

🤖 AI Care

👤 My Page
```

---

# Premium Navigation

```text
Premium

├── Subscription

├── Payment

├── Coupon

└── Store
```

---

# Future Expansion

향후 추가 예정 화면

- Wearable 연동
- Health Connect
- Apple Health
- 병원 예약
- 보험 연동
- AI Health Coach
- AI 식단 관리
- AI 운동 코칭

---

# Summary

Mom's Time는 **총 32개의 화면**으로 구성된다.

메인 화면은 사용자의 일상적인 건강 관리 흐름을 중심으로 설계하며,

서브 화면은 복약, AI, 건강 관리, Premium 서비스 등 세부 기능을 지원한다.

특히 **Home(Today Care Dashboard)** 를 중심으로 모든 기능이 자연스럽게 연결되는 사용자 경험을 목표로 한다.