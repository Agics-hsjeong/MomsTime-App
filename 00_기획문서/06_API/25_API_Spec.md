# 🌐 Mom's Time API Specification

> **Cloud Functions API Specification v1.0**

---

# 1. 목적

본 문서는 Mom's Time에서 사용하는 서버 API(Cloud Functions)를 정의한다.

Firestore CRUD는 Flutter SDK를 통해 직접 처리하며,

Cloud Functions는 AI 처리, OCR 분석, 알림, 리포트 생성 등 서버에서 수행해야 하는 기능만 담당한다.

---

# 2. Architecture

```text id="apb4z6"
Flutter

↓

Firebase SDK

↓

Firestore

--------------------

Flutter

↓

HTTPS Callable

↓

Cloud Functions

↓

OpenAI
```

---

# 3. Authentication

모든 API는

Firebase Authentication ID Token을 검증한다.

인증되지 않은 사용자는 호출할 수 없다.

---

# 4. API List

| API | Method | 설명 |
|------|--------|------|
| generateDailyBriefing | Callable | AI 하루 브리핑 생성 |
| askAI | Callable | AI 상담 |
| parseOCR | Callable | OCR 결과 분석 |
| analyzeMedication | Callable | 복약 분석 |
| generateWeeklyReport | Callable | 주간 리포트 생성 |
| generateMonthlyReport | Callable | 월간 리포트 생성 |
| sendTestNotification | Callable | 테스트 알림 |
| syncMedicationMaster | HTTP | 의약품 마스터 동기화(관리자) |

---

# 5. generateDailyBriefing

목적

오늘의 AI 브리핑 생성

### Input

```json id="r2hrbd"
{
  "date": "2026-07-02"
}
```

### Output

```json id="htw3dj"
{
  "title": "오늘의 브리핑",
  "summary": "...",
  "tips": [],
  "warnings": []
}
```

---

# 6. askAI

목적

사용자 질문 응답

### Input

```json id="yywn2m"
{
  "question": "철분은 언제 먹나요?"
}
```

### Output

```json id="f9x46d"
{
  "answer": "...",
  "references": [],
  "disclaimer": "의료진 상담이 필요한 경우 전문의와 상담하세요."
}
```

---

# 7. parseOCR

목적

OCR 텍스트를 구조화된 데이터로 변환

### Input

```json id="tudmx5"
{
  "text": "철분 1일 2회 30일"
}
```

### Output

```json id="eptfpg"
{
  "name": "철분",
  "frequency": 2,
  "duration": 30
}
```

---

# 8. analyzeMedication

목적

복약 패턴 분석

### Input

```json id="4ls6jz"
{
  "userId": "auto"
}
```

### Output

```json id="t6l2n3"
{
  "completionRate": 94,
  "advice": [
    "아침 복약 성공률이 높습니다."
  ]
}
```

---

# 9. generateWeeklyReport

목적

주간 건강 리포트 생성

### Output

```json id="ynwjlwm"
{
  "medicationRate": 92,
  "healthScore": 88,
  "summary": "이번 주도 꾸준히 관리하고 계세요."
}
```

---

# 10. generateMonthlyReport

목적

월간 리포트 생성

출력 형식은 주간 리포트와 동일하며 기간만 월 단위이다.

---

# 11. sendTestNotification

목적

FCM 테스트

### Input

```json id="8cjlwm"
{
  "title": "테스트",
  "body": "복약 알림 테스트입니다."
}
```

---

# 12. syncMedicationMaster

목적

의약품 마스터 데이터 동기화

관리자만 호출 가능

HTTP Trigger 사용

---

# 13. Error Response

공통 형식

```json id="nlvdz5"
{
  "success": false,
  "code": "INVALID_ARGUMENT",
  "message": "잘못된 요청입니다."
}
```

---

# 14. Success Response

공통 형식

```json id="fjlwm7"
{
  "success": true,
  "data": {}
}
```

---

# 15. Timeout

| API | 목표 |
|------|------:|
| AI 브리핑 | 10초 이내 |
| AI 상담 | 15초 이내 |
| OCR 분석 | 8초 이내 |
| 리포트 생성 | 15초 이내 |

---

# 16. Rate Limit

사용자 기준

- AI 상담 : 분당 10회
- OCR 분석 : 일 30회
- 브리핑 생성 : 하루 1회
- 리포트 생성 : 주간/월간 각 1회

---

# 17. Logging

모든 API는 다음 정보를 기록한다.

- 호출 시간
- 사용자 UID
- 처리 시간
- 성공/실패 여부
- 오류 코드

민감한 질문 내용은 최소한으로 기록한다.

---

# 18. Versioning

초기 버전

```text id="7b6u63"
v1
```

향후 Breaking Change 발생 시

```text id="gllfxf"
v2
```

를 추가한다.

---

# 19. Security

- Firebase Authentication 필수
- HTTPS만 허용
- API Key는 Cloud Functions 환경 변수로 관리
- 관리자 API는 Custom Claims 검증
- 입력 데이터 검증 후 처리

---

# 20. API Summary

Mom's Time는 Firestore를 중심으로 동작하며,

Cloud Functions API는 AI, OCR, 알림, 리포트 등 **서버에서만 처리해야 하는 기능**을 담당한다.

이를 통해 보안성과 확장성을 확보하고, Flutter 앱은 단순하고 빠르게 유지한다.