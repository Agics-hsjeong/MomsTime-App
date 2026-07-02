# ☁️ Mom's Time Firebase Cloud Functions

> **Cloud Functions Architecture v1.0**

---

# 1. 목적

본 문서는 Mom's Time에서 사용하는 Firebase Cloud Functions 구조를 정의한다.

Cloud Functions는 AI, OCR, 알림, 리포트 생성 등 서버에서 처리해야 하는 기능을 담당한다.

---

# 2. 역할

Cloud Functions는 다음 역할을 수행한다.

- AI 호출
- OCR Parsing
- FCM 발송
- Scheduler
- Report 생성
- Master Data 동기화

---

# 3. Architecture

```text
Flutter

↓

Firebase SDK

↓

Cloud Functions

↓

OpenAI

Firestore

FCM
```

---

# 4. Folder Structure

```text
functions/

src/

├── ai/

│     ├── dailyBriefing/

│     ├── askAI/

│     ├── medication/

│     └── parser/

├── notification/

│     ├── scheduler/

│     ├── send/

│     └── reminder/

├── report/

│     ├── weekly/

│     └── monthly/

├── ocr/

│     ├── parser/

│     └── medication/

├── master/

│     ├── medication/

│     └── supplement/

├── shared/

│     ├── auth/

│     ├── logger/

│     ├── prompt/

│     └── utils/

└── index.ts
```

---

# 5. Function 종류

## HTTPS Callable

Flutter에서 직접 호출

예)

- askAI
- parseOCR
- generateDailyBriefing

---

## Firestore Trigger

자동 실행

예)

- 복약 완료
- 건강 기록

---

## Scheduler

정해진 시간 실행

예)

매일 오전 7시

↓

브리핑 생성

---

## HTTP Trigger

관리자

마스터 데이터 동기화

---

# 6. AI Functions

## generateDailyBriefing()

오늘 브리핑 생성

---

## askAI()

AI 상담

---

## analyzeMedication()

복약 분석

---

## summarizeHealth()

건강 분석

---

# 7. OCR Functions

## parseOCR()

OCR 결과 분석

---

## medicationParser()

약 정보 추출

---

# 8. Notification Functions

## scheduleMedication()

복약 알림 예약

---

## sendNotification()

FCM 발송

---

## retryReminder()

미복용 재알림

---

# 9. Report Functions

## generateWeeklyReport()

주간 리포트

---

## generateMonthlyReport()

월간 리포트

---

# 10. Scheduler

매일

07:00

↓

AI 브리핑 생성

---

매일

23:00

↓

복약 통계 생성

---

매주

일요일

↓

주간 리포트 생성

---

매월

1일

↓

월간 리포트 생성

---

# 11. Firestore Trigger

복약 완료

↓

복약률 업데이트

---

건강 기록

↓

건강 점수 계산

---

사용자 가입

↓

기본 데이터 생성

---

# 12. AI Flow

```text
Flutter

↓

Callable

↓

Prompt Builder

↓

OpenAI

↓

Parser

↓

Firestore 저장

↓

Response
```

---

# 13. Security

모든 Callable Function은

Firebase Authentication을 검증한다.

관리자 API는

Custom Claims를 확인한다.

---

# 14. Logging

기록

- 실행 시간
- UID
- 실행 결과
- 오류
- 처리 시간

Cloud Logging 사용

---

# 15. Error Handling

모든 Function은

공통 오류 형식을 사용한다.

예)

- invalid-argument
- permission-denied
- unauthenticated
- internal

---

# 16. Environment

환경 변수

- OPENAI_API_KEY
- PROJECT_ID
- FCM_CONFIG

Secret Manager를 사용하여 관리한다.

---

# 17. Retry

실패 시

자동 재시도

대상

- AI
- FCM
- Scheduler

---

# 18. Performance

목표

- AI 응답 10초 이내
- OCR Parsing 8초 이내
- Notification 2초 이내
- Scheduler 30초 이내

---

# 19. Future Functions

향후 추가

- AI Health Coach
- OCR Prescription
- Wearable Sync
- Hospital Sync
- Family Sync

---

# 20. Cloud Functions Summary

Mom's Time의 Cloud Functions는

AI, OCR, 알림, 리포트, 데이터 동기화 등 서버에서만 처리해야 하는 기능을 담당한다.

모든 Function은 **Feature 단위로 분리**하여 관리하며,

Firebase Authentication과 Secret Manager를 기반으로 안전하게 운영한다.

이를 통해 Flutter 앱은 가볍게 유지하면서도 확장 가능한 AI 기반 헬스케어 플랫폼을 구현한다.