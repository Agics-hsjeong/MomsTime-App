# 🔥 Mom's Time Firestore Design

> **Cloud Firestore Database Design v1.0**

---

# 1. 목적

본 문서는 Mom's Time에서 사용하는 Cloud Firestore의 Collection 구조와 Document 설계를 정의한다.

Firestore는 사용자 데이터를 중심으로 설계하며,

공통 데이터는 Master Collection으로 분리한다.

---

# 2. Firestore 구조

```text
Firestore

├── users
│
├── medication_master
│
├── supplement_master
│
├── checkup_master
│
└── app_config
```

---

# 3. User Structure

```text
users

└── {uid}
```

하위 Collection

```text
users/{uid}

├── medications

├── medication_logs

├── schedules

├── health_records

├── ai_briefings

├── ai_chats

├── notifications

└── reports
```

---

# 4. Master Collections

## medication_master

전체 약 정보

---

## supplement_master

영양제

---

## checkup_master

임신 주차별 검사

---

## app_config

앱 설정

공지

버전

FAQ

---

# 5. users

```text
users/{uid}
```

필드

| Field | Type |
|---------|------|
| nickname | string |
| email | string |
| provider | string |
| pregnancyStage | string |
| dueDate | timestamp |
| birthDate | timestamp |
| createdAt | timestamp |

---

# 6. medications

```text
users/{uid}/medications/{id}
```

필드

| Field | Type |
|---------|------|
| masterId | string |
| customName | string |
| dosage | string |
| frequency | number |
| times | array |
| mealType | before / after |
| startDate | timestamp |
| endDate | timestamp |
| active | bool |

---

# 7. medication_logs

```text
users/{uid}/medication_logs/{id}
```

필드

| Field | Type |
|---------|------|
| medicationId | string |
| scheduledTime | timestamp |
| completedTime | timestamp |
| status | completed / skipped / delayed |

---

# 8. schedules

```text
users/{uid}/schedules/{id}
```

필드

| Field | Type |
|---------|------|
| type | medication |
| title | string |
| date | timestamp |
| completed | bool |

---

# 9. health_records

```text
users/{uid}/health_records/{id}
```

필드

| Field | Type |
|---------|------|
| type | weight / blood_pressure / water |
| value | number |
| unit | string |
| recordedAt | timestamp |

---

# 10. ai_briefings

```text
users/{uid}/ai_briefings/{id}
```

필드

| Field | Type |
|---------|------|
| date | timestamp |
| summary | string |
| tips | array |
| warnings | array |

---

# 11. ai_chats

```text
users/{uid}/ai_chats/{id}
```

필드

| Field | Type |
|---------|------|
| role | user / assistant |
| message | string |
| createdAt | timestamp |

---

# 12. notifications

```text
users/{uid}/notifications/{id}
```

필드

| Field | Type |
|---------|------|
| title | string |
| body | string |
| type | medication |
| read | bool |
| createdAt | timestamp |

---

# 13. reports

```text
users/{uid}/reports/{id}
```

필드

| Field | Type |
|---------|------|
| period | weekly |
| medicationRate | number |
| summary | string |

---

# 14. medication_master

```text
medication_master/{id}
```

필드

| Field | Type |
|---------|------|
| name | string |
| ingredient | array |
| category | string |
| caution | array |
| pregnancy | safe / caution / avoid |
| breastfeeding | safe / caution |
| createdAt | timestamp |

---

# 15. supplement_master

```text
supplement_master/{id}
```

필드

| Field | Type |
|---------|------|
| name | string |
| bestTime | string |
| caution | array |
| interaction | array |

---

# 16. checkup_master

```text
checkup_master/{id}
```

필드

| Field | Type |
|---------|------|
| week | string |
| title | string |
| description | string |
| preparation | array |

---

# 17. app_config

```text
app_config/{id}
```

예시

- version
- faq
- notice
- ai_prompt

---

# 18. Security Rule

사용자는

본인 Document만 읽고 수정할 수 있다.

Master Collection은

읽기 전용이다.

관리자만 수정할 수 있다.

---

# 19. Index

Composite Index

- medication_logs(status, scheduledTime)
- schedules(date)
- health_records(type, recordedAt)

---

# 20. Cache

오프라인 캐싱

- users
- medications
- schedules
- health_records

Firestore Offline Persistence를 활성화한다.

---

# 21. Summary

Mom's Time Firestore는

사용자 데이터(User Data)와

공통 데이터(Master Data)를 분리하는 Hybrid 구조를 사용한다.

이를 통해

- 유지보수성
- AI 확장성
- OCR 자동 등록
- 약 정보 관리

를 효율적으로 지원한다.