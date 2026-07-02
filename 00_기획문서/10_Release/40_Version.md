# 🔢 Mom's Time Version Policy

> **Version Management Guide v1.0**

---

# 1. 목적

본 문서는 Mom's Time 프로젝트의 버전 관리 정책을 정의한다.

모든 앱, Cloud Functions, AI Prompt, Firestore Schema는 본 정책에 따라 버전을 관리한다.

---

# 2. Versioning Standard

Mom's Time는 **Semantic Versioning (SemVer)** 을 사용한다.

형식

```text id="ver001"
MAJOR.MINOR.PATCH
```

예시

```text id="ver002"
1.0.0
1.0.1
1.1.0
2.0.0
```

---

# 3. Version Rule

## MAJOR

호환되지 않는 변경 사항

예시

- Firestore 구조 변경
- AI Architecture 변경
- 대규모 UI 개편
- 앱 구조 변경

---

## MINOR

새로운 기능 추가

예시

- OCR 등록
- 배우자 공유
- 건강 리포트
- 새로운 AI 기능

---

## PATCH

버그 수정 및 성능 개선

예시

- 복약 알림 오류 수정
- UI 개선
- 성능 최적화
- 보안 패치

---

# 4. MVP Version

| Version | 설명 |
|----------|------|
| 1.0.0 | 첫 번째 정식 출시(MVP) |

---

# 5. Planned Versions

| Version | 목표 |
|----------|------|
| 1.0.1 | 버그 수정 |
| 1.1.0 | OCR 및 AI 리포트 |
| 1.2.0 | 배우자 공유 |
| 2.0.0 | AI Health Coach 및 웨어러블 연동 |

---

# 6. Build Number

버전과 별도로 Build Number를 관리한다.

예시

| Version | Build |
|----------|------:|
| 1.0.0 | 1 |
| 1.0.1 | 2 |
| 1.1.0 | 10 |

Build Number는 스토어 제출 시마다 증가시킨다.

---

# 7. App Version

Flutter

```yaml id="ver003"
version: 1.0.0+1
```

- `1.0.0` → 사용자 버전
- `+1` → Build Number

---

# 8. Firebase Version

관리 대상

- Cloud Functions
- Firestore Rules
- Storage Rules
- Remote Config

배포 이력은 Git Tag와 Release Note로 관리한다.

---

# 9. AI Prompt Version

AI Prompt도 별도 버전으로 관리한다.

예시

```text id="ver004"
prompt_v1
prompt_v1.1
prompt_v2
```

Prompt 변경 시 변경 이력을 기록한다.

---

# 10. Database Version

Firestore Schema 변경 시 버전을 관리한다.

예시

```text id="ver005"
schema_v1
schema_v2
```

호환되지 않는 변경은 Migration 계획을 함께 작성한다.

---

# 11. API Version

Cloud Functions API

```text id="ver006"
v1
v2
```

Breaking Change가 있을 경우 새로운 버전을 추가한다.

---

# 12. Git Tag

모든 릴리스는 Git Tag를 생성한다.

예시

```text id="ver007"
v1.0.0
v1.0.1
v1.1.0
```

---

# 13. Release Approval

다음 조건을 만족해야 버전을 올릴 수 있다.

- QA 완료
- 테스트 통과
- Release Note 작성
- Changelog 업데이트
- CI/CD 성공

---

# 14. Rollback Policy

배포 후 문제가 발생하면

- 이전 안정 버전으로 롤백
- Hotfix 브랜치 생성
- 수정 후 Patch 버전 배포

예시

```text id="ver008"
1.0.1

↓

1.0.2
```

---

# 15. Version History

| Version | Status |
|----------|--------|
| 1.0.0 | MVP |
| 1.0.1 | Planned |
| 1.1.0 | Planned |
| 1.2.0 | Planned |
| 2.0.0 | Planned |

---

# 16. Version Checklist

새 버전 출시 전 확인

- 버전 번호 변경
- Build Number 증가
- CHANGELOG 업데이트
- Release Note 작성
- Git Tag 생성
- Store 정보 업데이트

---

# 17. Summary

Mom's Time는 Semantic Versioning을 기반으로 버전을 관리한다.

앱, Cloud Functions, Firestore Schema, AI Prompt를 체계적으로 버전 관리하여 안정적인 배포와 유지보수를 지원한다.

모든 릴리스는 QA, 테스트, 문서 업데이트를 완료한 후 배포하는 것을 원칙으로 한다.