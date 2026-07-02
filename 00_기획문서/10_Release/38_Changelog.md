# 📝 Mom's Time Changelog

> **Project Change History**

본 문서는 Mom's Time 프로젝트의 주요 변경 사항을 기록한다.

버전 관리는 **Semantic Versioning (MAJOR.MINOR.PATCH)** 을 따른다.

---

# Version Format

```text id="r7wq3k"
MAJOR.MINOR.PATCH

예)
1.0.0
1.0.1
1.1.0
2.0.0
```

---

# Release Types

### Major

대규모 기능 추가 또는 구조 변경

예)

- AI Health Coach
- Wearable 연동
- 병원 연동

---

### Minor

기능 추가

예)

- OCR 등록
- 건강 리포트
- 배우자 공유

---

### Patch

버그 수정

예)

- 알림 오류 수정
- UI 개선
- 성능 개선

---

# [Unreleased]

## Added

- 개발 예정 기능 작성

## Changed

- 변경 예정 기능 작성

## Fixed

- 수정 예정 버그 작성

---

# [1.0.0] - MVP

## Added

### Authentication

- Google 로그인
- Apple 로그인
- 카카오 로그인

---

### Home

- Today Care Dashboard
- AI Daily Briefing
- Quick Actions

---

### Medication

- 약 등록
- 영양제 등록
- 복약 알림
- 복약 기록

---

### Calendar

- 일정 관리
- 검사 일정

---

### Health

- 체중 기록
- 혈압 기록
- 물 섭취 기록

---

### AI

- AI 브리핑
- AI 복약 상담
- Quick Questions

---

### Notification

- 복약 알림
- 검사 알림
- 재알림

---

### Firebase

- Firestore
- Cloud Functions
- Firebase Authentication
- FCM

---

## Changed

- 없음

---

## Fixed

- 초기 릴리스

---

# [1.1.0]

## Added

- OCR 약 등록
- OCR 처방전 분석
- AI 건강 리포트

---

## Changed

- Home Dashboard 개선
- 알림 UX 개선

---

## Fixed

- 알림 중복 문제
- AI 응답 속도 개선

---

# [1.2.0]

## Added

- 가족 공유
- 배우자 모드
- 건강 통계

---

## Changed

- Today Care UI 개선

---

## Fixed

- 캘린더 동기화 오류

---

# [2.0.0]

## Added

- AI Health Coach
- Wearable 연동
- 병원 시스템 연동
- Health Connect
- Apple Health

---

## Changed

- AI Engine 업그레이드
- 새로운 Dashboard

---

## Fixed

- 성능 최적화
- Firestore 구조 개선

---

# Changelog 작성 규칙

모든 변경 사항은 다음 항목으로 기록한다.

- **Added** : 새로운 기능
- **Changed** : 기존 기능 변경
- **Deprecated** : 향후 제거 예정
- **Removed** : 제거된 기능
- **Fixed** : 버그 수정
- **Security** : 보안 관련 변경

---

# 작성 원칙

- 사용자에게 영향을 주는 변경 사항만 기록한다.
- 내부 리팩토링은 필요한 경우에만 기록한다.
- 출시 버전마다 반드시 업데이트한다.
- 변경 내용은 간결하고 명확하게 작성한다.

---

# Release History

| Version | Status | Release Date |
|----------|--------|--------------|
| Unreleased | 🚧 Development | - |
| 1.0.0 | MVP | - |
| 1.1.0 | Planned | - |
| 1.2.0 | Planned | - |
| 2.0.0 | Planned | - |

---

# Summary

Mom's Time는 모든 릴리스의 변경 사항을 `CHANGELOG.md`에서 관리한다.

변경 이력은 개발자뿐 아니라 기획자, 디자이너, QA가 함께 참고하는 공식 기록으로 활용한다.

릴리스마다 기능 추가, 개선, 버그 수정, 보안 변경 사항을 명확하게 기록하여 프로젝트의 이력을 체계적으로 관리한다.