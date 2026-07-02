# 🚀 Mom's Time MVP

> **Minimum Viable Product Specification v1.0**

---

# 1. 목적

본 문서는 Mom's Time의 첫 번째 출시(MVP)에 포함되는 기능을 정의한다.

MVP는 가능한 많은 기능을 제공하는 것이 아니라,

사용자가 **매일 사용할 수 있는 핵심 가치(Core Value)** 를 검증하는 것을 목표로 한다.

---

# 2. MVP 목표

Mom's Time MVP의 목표는 다음과 같다.

> **"엄마가 하루의 복약과 건강 관리를 놓치지 않도록 돕는다."**

---

# 3. MVP 핵심 가치

Mom's Time는

복약 알림 앱이 아니다.

건강 정보를 제공하는 앱도 아니다.

Mom's Time는

**오늘 해야 할 건강 관리를 함께 실천하는 AI 케어 서비스**이다.

---

# 4. MVP 성공 기준

사용자가

- 오늘 해야 할 일을 확인하고
- 약과 영양제를 복용하고
- 건강을 기록하고
- 다음 날 다시 앱을 실행한다.

이 경험이 자연스럽게 이어지는 것이 MVP의 성공이다.

---

# 5. MVP 포함 기능

## 1. 사용자

### 회원가입

- Google 로그인
- Apple 로그인
- 카카오 로그인

---

### 프로필

- 닉네임
- 임신 단계
- 출산 예정일
- 출산일

---

## 2. Home (Today Care)

앱의 핵심 화면

제공 정보

- 오늘 복약
- 오늘 영양제
- 오늘 일정
- 다음 검사
- AI 하루 브리핑

---

### Quick Action

- 약 등록
- 건강 기록
- AI 상담

---

## 3. 복약 관리

### 약 등록

- 직접 입력

---

### 영양제 등록

- 직접 입력

---

### 복약 설정

- 시간
- 횟수
- 기간
- 식전/식후

---

### 복약 실행

- 먹었어요
- 10분 뒤
- 건너뛰기

---

### 복약 기록

- 일별
- 주간

---

## 4. 캘린더

- 오늘 일정
- 월간 일정
- 검사 일정

---

## 5. 건강

기록

- 체중
- 혈압
- 물 섭취

---

## 6. AI

### AI 하루 브리핑

제공 내용

- 오늘 복약
- 오늘 일정
- 오늘 주의사항
- 오늘의 응원

---

### AI 상담

질문

- 약
- 영양제
- 건강

---

## 7. 알림

- 복약
- 영양제
- 검사 일정

---

## 8. 설정

- 프로필
- 알림
- 로그아웃

---

# 6. MVP 제외 기능

다음 기능은 MVP에 포함하지 않는다.

### OCR

- 처방전 인식
- 약 사진 인식

---

### 가족 공유

- 배우자 초대
- 가족 관리

---

### 리포트

- 주간 리포트
- 월간 리포트

---

### 병원 기능

- 병원 예약
- 진료 기록
- 처방전 보관

---

### 웨어러블

- Apple Health
- Health Connect
- 스마트워치

---

### AI 고급 기능

- 복약 패턴 분석
- 건강 습관 분석
- AI 추천 시간

---

# 7. MVP 사용자 시나리오

```text
회원가입

↓

임신 단계 설정

↓

약 등록

↓

복약 시간 설정

↓

알림 수신

↓

복약 완료

↓

오늘 브리핑 확인

↓

건강 기록

↓

다음 날 다시 실행
```

---

# 8. MVP KPI

## 사용자

- 회원가입 완료율
- 프로필 완료율

---

## 서비스

- DAU (일간 활성 사용자)
- WAU (주간 활성 사용자)

---

## 복약

- 복약 완료율
- 알림 확인율

---

## AI

- AI 브리핑 조회율
- AI 상담 이용률

---

## 유지율

- Day 1 Retention
- Day 7 Retention
- Day 30 Retention

---

# 9. MVP 기술 범위

## Frontend

- Flutter

---

## Backend

- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Cloud Messaging
- Cloud Functions

---

## AI

- OpenAI API

---

## Notification

- Flutter Local Notifications
- Firebase Cloud Messaging

---

# 10. MVP 화면

## Launch

- Splash
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
- AI Chat
- Schedule Detail

---

# 11. 출시 목표

### Android

Google Play Closed Test

---

### iOS

TestFlight

---

# 12. 출시 후 검증

출시 후 가장 먼저 검증할 항목

- 사용자는 매일 앱을 실행하는가?
- 복약 완료율은 얼마나 되는가?
- AI 브리핑을 읽는가?
- 알림이 실제 행동으로 이어지는가?
- 어떤 화면에서 가장 오래 머무는가?

---

# 13. MVP 이후 계획

## v1.1

- OCR 등록
- 복약 통계
- AI 복약 가이드

---

## v1.5

- 배우자 공유
- 가족 관리
- 건강 리포트

---

## v2.0

- 병원 연동
- 스마트워치 연동
- AI 건강 코치

---

# MVP Definition

Mom's Time MVP는

기능이 많은 앱이 아니라,

**매일 한 번 이상 실행하게 만드는 앱**을 목표로 한다.

사용자가 앱을 열면

1. 오늘 해야 할 일을 확인하고
2. 복약을 완료하고
3. 건강을 기록하고
4. AI의 도움을 받아 안심하고 하루를 보낸다.

이 경험이 자연스럽게 반복된다면,

Mom's Time MVP는 성공한 것이다.