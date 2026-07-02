# 🚀 Mom's Time Release Process

> **Release Management Guide v1.0**

---

# 1. 목적

본 문서는 Mom's Time의 개발 완료부터 운영 배포까지의 전체 Release Process를 정의한다.

안정적인 서비스 제공을 위해 모든 릴리스는 동일한 절차를 따른다.

---

# 2. Release Flow

```text id="4tzk9h"
Feature Development
        │
        ▼
Code Review
        │
        ▼
Develop Merge
        │
        ▼
QA Testing
        │
        ▼
Release Branch
        │
        ▼
Beta Test
        │
        ▼
Production Release
        │
        ▼
Monitoring
```

---

# 3. Release 단계

### STEP 1. Feature 완료

- 기능 개발 완료
- Unit Test 통과
- Widget Test 완료

---

### STEP 2. Code Review

확인 항목

- Coding Convention 준수
- Design System 적용
- State Management 규칙 준수
- Repository Pattern 준수

---

### STEP 3. QA

기능 테스트

- 로그인
- 회원가입
- 복약 등록
- 복약 완료
- AI 브리핑
- AI 상담
- OCR 등록
- 알림

---

### STEP 4. Release Branch 생성

```text id="m3f7v2"
release/v1.0.0
```

생성 후

버그 수정만 허용한다.

---

### STEP 5. Beta Test

Android

- Google Play Closed Testing

iOS

- TestFlight

테스트 기간

- 최소 7일 권장

---

### STEP 6. Production

Google Play

↓

App Store

동시 배포를 원칙으로 한다.

---

# 4. QA Checklist

## Authentication

- 로그인
- 로그아웃
- 자동 로그인

---

## Home

- Today Care
- AI 브리핑
- Quick Action

---

## Medication

- 등록
- 수정
- 삭제
- 복약 완료
- 알림 동작

---

## Calendar

- 일정 생성
- 일정 수정
- 일정 삭제

---

## Health

- 체중 기록
- 혈압 기록
- 물 섭취 기록

---

## AI

- 하루 브리핑
- AI 상담
- 응답 시간
- JSON 형식

---

## OCR

- 사진 등록
- OCR Parsing
- AI Parsing

---

## Notification

- Local Notification
- FCM
- 알림 Action 버튼
- 재알림

---

# 5. Performance Test

목표

- 앱 실행 3초 이내
- 화면 전환 300ms 이하
- Firestore 응답 500ms 이하
- AI 응답 10초 이내

---

# 6. Security Check

출시 전 확인

- Firestore Rules
- Storage Rules
- Secret Manager
- API Key 노출 여부
- Firebase Authentication

---

# 7. Release Checklist

### Flutter

- Flutter Analyze
- Flutter Test
- Build Success

---

### Firebase

- Firestore Rules 배포
- Functions 배포
- Storage Rules 배포
- FCM 정상 동작

---

### AI

- Prompt Version 확인
- AI 응답 검증
- 오류 응답 확인

---

### Assets

- 앱 아이콘
- 스플래시
- 스크린샷
- 앱 설명

---

# 8. Version

Semantic Versioning 사용

```text id="wg3n7p"
1.0.0
```

Patch

```text id="lry6gh"
1.0.1
```

Minor

```text id="gaxhje"
1.1.0
```

Major

```text id="h4hn2w"
2.0.0
```

---

# 9. Rollback

문제 발생 시

```text id="odm0rf"
Production

↓

Previous Version

↓

Hotfix

↓

Release
```

이전 안정 버전으로 롤백한다.

---

# 10. Monitoring

출시 후 확인

- Crashlytics
- Analytics
- FCM
- Cloud Functions
- Firestore Usage

---

# 11. KPI

출시 후

- DAU
- 복약 완료율
- AI 이용률
- 알림 클릭률
- Day 1 Retention
- Day 7 Retention

---

# 12. Bug Priority

P0

서비스 중단

---

P1

핵심 기능 오류

---

P2

일반 기능 오류

---

P3

UI 개선

---

# 13. Release Schedule

예시

```text id="54y5n7"
월요일

↓

QA

↓

화요일

↓

Release Branch

↓

수요일

↓

Closed Test

↓

금요일

↓

Production
```

---

# 14. Post Release

출시 후

- 사용자 피드백 수집
- Crash 분석
- AI 응답 분석
- 성능 분석
- 다음 버전 계획

---

# 15. Hotfix

긴급 수정

```text id="5mjlwm"
main

↓

hotfix

↓

Store Update
```

---

# 16. 운영 원칙

- 기능보다 안정성을 우선한다.
- 데이터 손실 가능성이 있는 변경은 출시하지 않는다.
- AI 오류 발생 시 기본 템플릿으로 대체하여 서비스 중단을 방지한다.

---

# 17. Store 배포

Android

- Google Play Closed Test
- Google Play Production

iOS

- TestFlight
- App Store Review
- App Store Release

---

# 18. Release Summary

Mom's Time는 QA, 베타 테스트, 운영 모니터링을 포함한 단계적 릴리스 프로세스를 따른다.

모든 릴리스는 기능 검증뿐 아니라 복약 알림, AI 브리핑, 건강 데이터 처리의 안정성을 확인한 후 배포한다.

출시 이후에도 Crashlytics와 Analytics를 통해 지속적으로 품질을 모니터링하고, 사용자 피드백을 기반으로 서비스를 개선해 나간다.