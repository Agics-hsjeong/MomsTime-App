# ⚙️ Mom's Time CI/CD

> **Continuous Integration & Continuous Deployment Guide v1.0**

---

# 1. 목적

본 문서는 Mom's Time 프로젝트의 CI/CD 파이프라인을 정의한다.

자동화된 빌드, 테스트, 배포를 통해 안정적인 개발 및 운영 환경을 구축한다.

---

# 2. CI/CD Architecture

```text
Developer

↓

GitHub

↓

GitHub Actions

↓

Flutter Analyze

↓

Flutter Test

↓

Build

↓

Firebase Deploy

↓

Production
```

---

# 3. 사용 기술

## Source

- GitHub

---

## CI

- GitHub Actions

---

## Build

- Flutter

---

## Backend

- Firebase

---

## Distribution

- Google Play
- TestFlight

---

# 4. Workflow

## Feature Branch

```text
feature

↓

Push

↓

Analyze

↓

Test
```

---

## Develop

```text
develop

↓

Build

↓

Firebase Deploy (Dev)
```

---

## Release

```text
release

↓

Android AAB

↓

iOS Archive

↓

Store Upload
```

---

## Main

```text
main

↓

Production Deploy
```

---

# 5. CI Process

자동 수행

- Flutter Analyze
- Flutter Test
- Format Check
- Dependency Check

---

# 6. Build Process

Android

- APK (Debug)
- AAB (Release)

---

iOS

- Archive
- IPA

---

# 7. Firebase Deploy

자동 배포

- Cloud Functions
- Firestore Rules
- Storage Rules
- Remote Config
- Firebase Hosting (관리자 웹이 있는 경우)

---

# 8. Flutter Analyze

실행

```bash
flutter analyze
```

---

# 9. Flutter Test

실행

```bash
flutter test
```

---

# 10. Code Format

실행

```bash
dart format .
```

Format이 맞지 않으면 Build 실패

---

# 11. Build Matrix

Android

- Debug
- Release

---

iOS

- Debug
- Release

---

# 12. Secrets

GitHub Secrets 사용

예시

- FIREBASE_TOKEN
- OPENAI_API_KEY
- GOOGLE_PLAY_SERVICE_ACCOUNT
- APP_STORE_CONNECT_API_KEY

민감한 값은 저장소에 커밋하지 않는다.

---

# 13. Firebase Environments

Development

```text
momstime-dev
```

---

Production

```text
momstime-prod
```

환경을 분리하여 운영한다.

---

# 14. Release Pipeline

```text
Release Branch

↓

Build

↓

QA

↓

Google Play Closed Test

↓

TestFlight

↓

Production
```

---

# 15. Rollback

배포 실패 시

- 이전 앱 버전 유지
- 이전 Functions 재배포
- 이전 Rules 복원

---

# 16. Notification

빌드 결과를 팀에 공유한다.

예시

- Build Success
- Build Failed
- Deploy Success
- Deploy Failed

(Discord, Slack 등 연동 가능)

---

# 17. Artifact

자동 저장

- APK
- AAB
- IPA
- Test Report

---

# 18. Monitoring

배포 후 확인

- Crashlytics
- Analytics
- Cloud Functions
- FCM
- Firestore 사용량

---

# 19. Branch별 정책

| Branch | 동작 |
|---------|------|
| feature/* | Analyze + Test |
| develop | Dev Build + Dev Deploy |
| release/* | Release Build + QA |
| main | Production Deploy |

---

# 20. 실패 조건

다음 중 하나라도 실패하면 Pipeline을 중단한다.

- Analyze 실패
- Test 실패
- Build 실패
- Firebase Deploy 실패
- 보안 검사 실패

---

# 21. 배포 체크리스트

배포 전 자동 확인

- Flutter Analyze
- Flutter Test
- Build 성공
- Firestore Rules 배포
- Functions 배포
- Storage Rules 배포
- Remote Config 배포
- Crashlytics 활성화

---

# 22. CI/CD Summary

Mom's Time는 GitHub Actions를 기반으로 Flutter와 Firebase를 통합한 CI/CD 파이프라인을 운영한다.

모든 변경 사항은 자동으로 분석, 테스트, 빌드되며, 검증을 통과한 경우에만 Firebase와 스토어 배포 단계로 진행한다.

이를 통해 배포 속도와 코드 품질을 동시에 확보하고, 안정적인 운영 환경을 유지한다.