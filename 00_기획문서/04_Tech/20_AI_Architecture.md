# 🤖 Mom's Time AI Architecture

> **AI System Architecture v1.0**

---

# 1. 목적

본 문서는 Mom's Time의 AI 시스템 구조를 정의한다.

AI는 단순한 챗봇이 아니라,

사용자의 건강한 하루를 함께 관리하는 **AI Care Engine**이다.

---

# 2. AI Vision

Mom's Time의 AI는

질문에 답하는 것이 아니라,

필요한 정보를 먼저 제공한다.

---

# 3. AI Principle

AI는

- 먼저 안내한다.
- 쉽게 설명한다.
- 행동을 돕는다.
- 불안을 만들지 않는다.

---

# 4. AI Architecture

```text id="yx4fcp"
Flutter

↓

AI Service

↓

Prompt Builder

↓

Cloud Functions

↓

OpenAI

↓

Response Parser

↓

Flutter
```

---

# 5. AI Layer

## Presentation

AI Card

AI Chat

---

## Service

Prompt 생성

응답 처리

---

## Cloud

Cloud Functions

---

## AI

OpenAI

---

## Parser

JSON Parsing

---

# 6. AI Modules

## Daily Care AI ⭐⭐⭐⭐⭐

오늘 브리핑

---

## Medication AI ⭐⭐⭐⭐⭐

복약

---

## Health AI

건강

---

## Checkup AI

검사

---

## Report AI

건강 리포트

---

# 7. AI Flow

```text id="rccqke"
User

↓

Home

↓

Today Care

↓

AI Daily Briefing

↓

사용자 행동

↓

AI Feedback
```

---

# 8. AI Request Flow

```text id="b2vkaw"
Flutter

↓

Cloud Functions

↓

OpenAI

↓

JSON

↓

Flutter
```

API Key는

Cloud Functions에서만 관리한다.

---

# 9. AI Prompt Builder

입력 데이터

- 임신 단계
- 복약
- 오늘 일정
- 건강 기록
- 검사 일정

↓

Prompt 생성

↓

OpenAI

---

# 10. AI Response

반드시

JSON으로 응답한다.

예)

```json id="krw2s0"
{
  "title": "오늘의 브리핑",
  "summary": "...",
  "tips": [],
  "warning": []
}
```

---

# 11. AI Daily Briefing

생성 내용

- 오늘 복약
- 오늘 일정
- 오늘 주의사항
- 오늘 응원

---

# 12. Medication AI

질문

철분은 언제 먹나요?

↓

답변

↓

관련 주의사항

↓

추천 행동

---

# 13. Health AI

분석

- 체중
- 혈압
- 혈당

↓

건강 요약

---

# 14. Checkup AI

설명

- 검사 목적
- 준비사항
- 주의사항

---

# 15. Report AI

주간

↓

복약 분석

↓

건강 분석

↓

AI 요약

---

# 16. Safety

AI는

진단하지 않는다.

처방하지 않는다.

질병을 확정하지 않는다.

필요한 경우

의료진 상담을 안내한다.

---

# 17. AI Cache

오늘 브리핑은

Firestore에 저장한다.

동일한 날에는

재생성하지 않는다.

---

# 18. AI History

저장

- 질문
- 답변
- 생성일

---

# 19. Future AI

향후

- 음성 상담
- 이미지 분석
- 처방전 분석
- 약 성분 분석
- AI 건강 코치

---

# 20. AI Summary

Mom's Time의 AI는

챗봇이 아니라,

**사용자의 하루를 함께 관리하는 AI Care Engine**이다.

모든 AI 기능은

오늘의 건강한 행동을 돕는 것을 목표로 하며,

서비스 전반에 자연스럽게 녹아드는 경험을 제공한다.