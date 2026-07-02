# 🌿 Mom's Time Git Strategy

> **Git Branch & Workflow Guide v1.0**

---

# 1. 목적

본 문서는 Mom's Time 프로젝트의 Git 브랜치 전략과 협업 방식을 정의한다.

모든 개발자는 동일한 Git Workflow를 사용하여 안정적이고 일관된 개발 환경을 유지한다.

---

# 2. Git Workflow

Mom's Time는 **GitHub Flow + Release Branch** 전략을 사용한다.

```text
main
 │
 ├── develop
 │      │
 │      ├── feature/home-dashboard
 │      ├── feature/medication
 │      ├── feature/calendar
 │      ├── feature/health
 │      └── feature/ai-chat
 │
 ├── release/v1.0.0
 │
 └── hotfix/login-crash
```

---

# 3. Branch 역할

## main

- 항상 배포 가능한 상태를 유지한다.
- Google Play / App Store 출시 버전과 동일하다.

---

## develop

- 다음 버전 개발 브랜치
- 모든 Feature Branch는 develop으로 Merge한다.

---

## feature/*

새로운 기능 개발

예시

```text
feature/home
feature/medication
feature/notification
feature/ocr
feature/ai-briefing
```

---

## release/*

출시 준비

예시

```text
release/v1.0.0
release/v1.1.0
```

버그 수정과 QA만 진행한다.

---

## hotfix/*

운영 중 긴급 수정

예시

```text
hotfix/login
hotfix/notification
```

수정 후 `main`과 `develop`에 모두 반영한다.

---

# 4. Branch Naming

형식

```text
type/description
```

예시

```text
feature/home-dashboard
feature/add-medication
feature/ocr-register

fix/notification-error
fix/calendar-bug

refactor/home-provider

docs/prd-update

chore/firebase-upgrade
```

---

# 5. Commit Convention

형식

```text
type: summary
```

예시

```text
feat: add medication reminder

fix: resolve duplicate notification

refactor: simplify medication repository

docs: update feature list

style: improve home ui spacing

test: add ai briefing test

chore: upgrade firebase sdk
```

---

# 6. Pull Request

모든 기능은 Pull Request를 통해 병합한다.

PR에는 반드시 포함한다.

- 변경 목적
- 변경 내용
- 테스트 결과
- 관련 Issue
- UI 변경 시 스크린샷

---

# 7. Merge Strategy

기본 Merge 방식

**Squash and Merge**

장점

- Commit History 단순화
- 기능 단위 이력 관리
- Revert 용이

---

# 8. Code Review

리뷰 체크 항목

- 기능 정상 동작
- 코드 가독성
- 성능
- Null Safety
- 예외 처리
- 디자인 시스템 준수

---

# 9. Release Process

```text
feature/*
        │
        ▼
develop
        │
        ▼
release/v1.x.x
        │
        ▼
QA
        │
        ▼
main
        │
        ▼
Google Play
App Store
```

---

# 10. Hotfix Process

```text
main

↓

hotfix/login

↓

main

↓

develop
```

긴급 수정은 운영 버전에 먼저 반영한 후 develop에도 동일하게 병합한다.

---

# 11. Version Strategy

Semantic Versioning 사용

형식

```text
MAJOR.MINOR.PATCH
```

예시

```text
1.0.0

1.0.1

1.1.0

2.0.0
```

---

# 12. Tag

출시 시 Tag 생성

예시

```text
v1.0.0

v1.0.1

v1.1.0
```

---

# 13. Git Ignore

제외 대상

- build/
- .dart_tool/
- .idea/
- .vscode/
- firebase-debug.log
- *.keystore
- *.jks
- .env

---

# 14. Issue Labels

권장 Label

- feature
- bug
- enhancement
- documentation
- ui
- ai
- firebase
- notification
- ocr

---

# 15. Milestone

예시

- MVP
- v1.0
- v1.1
- v2.0

---

# 16. GitHub Projects

권장 컬럼

- Backlog
- Ready
- In Progress
- Review
- Testing
- Done

---

# 17. CI/CD

Pull Request 생성 시 자동 실행

- Flutter Analyze
- Flutter Test
- Build Check

Release Branch에서는

- Android Release Build
- iOS Archive Build

---

# 18. Release Checklist

출시 전 확인

- 모든 테스트 통과
- Firestore Rules 배포
- Cloud Functions 배포
- 앱 버전 증가
- AI Prompt 버전 확인
- Crashlytics 확인

---

# 19. Branch Protection

main

- 직접 Push 금지
- Pull Request 필수
- CI 통과 필수
- 최소 1회 리뷰 권장

develop

- Pull Request 권장
- CI 통과 후 Merge

---

# 20. Git Strategy Summary

Mom's Time는 **GitHub Flow + Release Branch** 전략을 사용한다.

기능 개발은 `feature/*` 브랜치에서 진행하고,

모든 변경 사항은 Pull Request와 Code Review를 거쳐 `develop`으로 병합한다.

출시 준비는 `release/*` 브랜치에서 진행하며,

운영 중 긴급 수정은 `hotfix/*` 브랜치를 통해 관리한다.

이 전략을 통해 안정적인 배포와 효율적인 협업을 동시에 달성하는 것을 목표로 한다.