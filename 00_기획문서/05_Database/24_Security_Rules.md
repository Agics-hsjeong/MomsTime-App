# 🔐 Mom's Time Firestore Security Rules

> **Firestore Security Rules Specification v1.0**

---

# 1. 목적

본 문서는 Mom's Time의 Firestore 접근 권한 정책(Security Rules)을 정의한다.

모든 사용자 데이터는 기본적으로 **본인만 접근 가능**하며, 최소 권한 원칙(Least Privilege)을 따른다.

---

# 2. 보안 원칙

Mom's Time는 다음 원칙을 따른다.

- 기본 거부(Default Deny)
- 인증 사용자만 접근
- 사용자 데이터는 본인만 접근
- Master Data는 읽기 전용
- 서버에서 생성되는 데이터는 클라이언트 수정 제한

---

# 3. 인증 정책

모든 사용자 데이터는 Firebase Authentication 로그인 후 접근할 수 있다.

```text id="8s2r6j"
로그인

↓

Firebase Authentication

↓

Firestore 접근
```

---

# 4. 사용자 데이터 접근

경로

```text id="sj5g8n"
users/{uid}
```

규칙

- 읽기 : 본인만 가능
- 생성 : 본인만 가능
- 수정 : 본인만 가능
- 삭제 : 본인만 가능

---

# 5. 하위 Collection

다음 Collection은 모두 동일한 정책을 따른다.

- medications
- medication_logs
- schedules
- health_records
- ai_chats
- notifications
- reports

접근 규칙

```text id="ux9v0m"
request.auth.uid == uid
```

인 경우만 허용한다.

---

# 6. AI Briefing

경로

```text id="oc5wzs"
users/{uid}/ai_briefings
```

정책

- 읽기 : 사용자
- 생성 : Cloud Functions
- 수정 : Cloud Functions
- 삭제 : 관리자 또는 Cloud Functions

사용자는 AI 브리핑을 직접 수정할 수 없다.

---

# 7. Master Collection

Collection

- medication_master
- supplement_master
- checkup_master

정책

- 읽기 : 모든 인증 사용자
- 생성 : 관리자
- 수정 : 관리자
- 삭제 : 관리자

---

# 8. App Config

Collection

```text id="l2h9kt"
app_config
```

정책

- 읽기 : 모든 사용자
- 수정 : 관리자

---

# 9. Notification

알림 이력은 사용자가 조회할 수 있다.

다만 발송 상태 및 시스템 필드는 서버에서만 변경한다.

---

# 10. Validation Rule

생성 시

다음 조건을 만족해야 한다.

예)

- 필수 필드 존재
- Timestamp 형식
- 문자열 길이 제한
- Enum 값 검증

---

# 11. Field Validation

예시

Medication

- frequency ≥ 1
- times 배열 존재
- mealType Enum 검증

Health Record

- value ≥ 0

---

# 12. Server Timestamp

다음 필드는

서버 시간을 기준으로 저장한다.

- createdAt
- updatedAt

클라이언트 임의 값 사용을 지양한다.

---

# 13. Soft Delete

삭제는

```text id="rn6j31"
deletedAt
```

필드를 사용하는 것을 기본 정책으로 한다.

실제 삭제는 관리자 또는 백그라운드 작업에서 수행한다.

---

# 14. Cloud Functions 전용 작업

다음 기능은 Cloud Functions만 수행할 수 있다.

- AI 브리핑 생성
- AI 응답 저장
- 알림 예약
- 통계 생성
- 리포트 생성

---

# 15. 관리자 권한

관리자만 가능한 작업

- Master Data 수정
- 공지사항 수정
- FAQ 수정
- 앱 설정 변경

관리자 여부는 Custom Claims로 관리한다.

---

# 16. Firestore Rules 예시

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;
    }

    match /medication_master/{doc} {
      allow read: if request.auth != null;
      allow write: if false;
    }

    match /supplement_master/{doc} {
      allow read: if request.auth != null;
      allow write: if false;
    }

    match /checkup_master/{doc} {
      allow read: if request.auth != null;
      allow write: if false;
    }
  }
}
```

---

# 17. Storage 보안

Firebase Storage

사용자 이미지

경로

```text id="x4zj7b"
users/{uid}/
```

본인만 업로드 및 조회 가능

OCR 원본 이미지는 처리 후 삭제하거나, 사용자가 저장을 선택한 경우에만 보관한다.

---

# 18. 개인정보 보호

민감한 건강 정보는 사용자 동의 없이 공유하지 않는다.

배우자 공유 기능은 명시적인 초대 및 수락 이후에만 활성화한다.

---

# 19. 감사 로그

향후 관리자 기능에서는 다음 작업을 기록한다.

- Master Data 수정
- 공지 수정
- 관리자 로그인
- 권한 변경

---

# 20. Security Checklist

출시 전 반드시 확인한다.

- Firebase Authentication 적용
- Firestore Security Rules 배포
- Storage Rules 적용
- Cloud Functions 인증 확인
- API Key 클라이언트 미포함
- 관리자 권한(Custom Claims) 검증
- 테스트 계정 권한 검증

---

# 21. Security Summary

Mom's Time는 **기본 거부(Default Deny)** 와 **최소 권한 원칙(Least Privilege)** 을 기반으로 설계한다.

사용자는 자신의 데이터만 접근할 수 있으며,

공통 데이터와 AI 생성 데이터는 서버에서 안전하게 관리한다.

이를 통해 개인정보와 건강 데이터를 안전하게 보호하면서도, AI 기반 케어 서비스를 안정적으로 제공하는 것을 목표로 한다.