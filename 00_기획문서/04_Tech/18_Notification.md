# 🔔 Mom's Time Notification Architecture

> **Notification System Specification v1.0**

---

# 1. 목적

본 문서는 Mom's Time의 알림(Notification) 시스템을 정의한다.

알림은 단순한 메시지 전달이 아니라,

사용자가 건강한 습관을 유지하도록 돕는 핵심 기능이다.

---

# 2. Notification Principle

Mom's Time의 알림은

**기억시키는 것보다 행동하게 만드는 것**을 목표로 한다.

---

# 3. Notification Architecture

```text id="zgm3ut"
               Firestore
                    │
                    ▼
          Cloud Functions
                    │
         ┌──────────┴──────────┐
         │                     │
        FCM            Local Scheduler
         │                     │
         └──────────┬──────────┘
                    ▼
            Flutter Application
                    │
                    ▼
          Flutter Local Notification
                    │
                    ▼
                 User
```

---

# 4. Notification Types

## 복약

- 약
- 영양제

---

## 건강

- 물 마시기
- 운동

---

## 검사

- 검사 일정
- 병원 방문

---

## AI

- 하루 브리핑

---

## 시스템

- 업데이트
- 공지사항

---

# 5. Priority

## High

복약

---

## Medium

검사 일정

---

## Low

AI 브리핑

운동

물 마시기

---

# 6. Delivery Strategy

## Local Notification ⭐⭐⭐⭐⭐

사용

- 복약
- 영양제

인터넷 없이도 동작

---

## Push Notification

사용

- 공지
- AI
- 이벤트
- 긴급 안내

---

# 7. Reminder Flow

```text id="mqn1wg"
복약 시간

↓

Local Notification

↓

먹었어요

↓

Firestore Update

↓

Today Care Update

↓

AI 응원 메시지
```

---

# 8. Notification Action

복약 알림

버튼

- 💊 먹었어요
- ⏰ 10분 뒤
- ❌ 건너뛰기

---

검사

버튼

- 일정 보기
- 캘린더

---

# 9. Notification Timing

## 복약

사용자 설정 시간

---

## 검사

7일 전

1일 전

당일

---

## AI 브리핑

오전

---

# 10. Smart Notification

향후 추가

AI가

사용자의 습관을 분석하여

추천 시간을 제공한다.

---

# 11. Notification Permission

최초 실행 시

```text id="j7g2vt"
알림 설명

↓

권한 요청

↓

허용

↓

알림 등록
```

권한 요청 전에

알림이 필요한 이유를 먼저 안내한다.

---

# 12. Notification Message

좋은 예

💊 철분을 드실 시간이에요.

오늘도 건강한 하루를 함께 만들어가요.

---

좋은 예

🌿 물 한 잔 마셔볼까요?

---

좋은 예

📅 내일은 정밀 초음파 검사 예정이에요.

---

피해야 하는 표현

복약하지 않았습니다.

위험합니다.

반드시 드세요.

---

# 13. Notification Category

Android

- Medication
- Health
- AI
- Checkup

---

iOS

- Medication
- Reminder
- Health
- AI

---

# 14. Retry Strategy

복약 완료하지 않은 경우

10분 후

재알림

사용자가 설정 가능

---

# 15. Background Strategy

앱 종료

↓

Local Notification

↓

복약 완료

↓

앱 실행

↓

Firestore 동기화

---

# 16. Analytics

기록

- 알림 수신
- 알림 열기
- 복약 완료
- 미루기
- 건너뛰기

---

# 17. Flutter Package

- firebase_messaging
- flutter_local_notifications
- timezone

---

# 18. Future Plan

향후 추가

- AI 추천 알림
- 위치 기반 알림
- 스마트워치 알림
- 배우자 알림
- 가족 공유 알림

---

# 19. UX Rule

알림은

불안을 만드는 것이 아니라

안심을 제공해야 한다.

사용자는

알림을 받았을 때

부담보다

응원을 느껴야 한다.

---

# 20. Notification Summary

Mom's Time는

FCM과 Local Notification을 함께 사용하여

언제 어디서나 안정적으로 복약 알림을 제공한다.

모든 알림은

사용자가 건강한 습관을 이어갈 수 있도록

따뜻하고 친절한 문구와 빠른 행동(Action)을 함께 제공하는 것을 원칙으로 한다.