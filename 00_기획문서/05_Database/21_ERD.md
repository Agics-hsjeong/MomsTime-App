# 🗄️ Mom's Time ERD

> **Firestore Data Model v1.0**

---

# 1. 목적

본 문서는 Mom's Time의 데이터 모델(ERD)을 정의한다.

Mom's Time는 **Cloud Firestore**를 사용하며,

관계형 데이터베이스가 아닌 **Collection 기반 구조**를 따른다.

---

# 2. 데이터 모델

```text
users
│
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

# 3. Collection Overview

| Collection | 설명 |
|------------|------|
| users | 사용자 정보 |
| medications | 약/영양제 정보 |
| medication_logs | 복약 기록 |
| schedules | 일정 |
| health_records | 건강 기록 |
| ai_briefings | AI 브리핑 |
| ai_chats | AI 대화 |
| notifications | 알림 |
| reports | 리포트 |

---

# 4. users

```text
users
```

### Fields

| Field | Type |
|---------|------|
| uid | string |
| nickname | string |
| email | string |
| provider | string |
| pregnancyStage | string |
| dueDate | timestamp |
| birthDate | timestamp |
| profileImage | string |
| createdAt | timestamp |
| updatedAt | timestamp |

---

# 5. medications

```text
users/{uid}/medications
```

### Fields

| Field | Type |
|---------|------|
| id | string |
| name | string |
| category | medicine / supplement |
| dosage | string |
| frequency | number |
| times | array |
| beforeMeal | bool |
| startDate | timestamp |
| endDate | timestamp |
| memo | string |
| isActive | bool |
| createdAt | timestamp |

---

# 6. medication_logs

```text
users/{uid}/medication_logs
```

### Fields

| Field | Type |
|---------|------|
| medicationId | reference/string |
| scheduledTime | timestamp |
| completedTime | timestamp |
| status | completed / skipped / delayed |
| note | string |
| createdAt | timestamp |

---

# 7. schedules

```text
users/{uid}/schedules
```

### Fields

| Field | Type |
|---------|------|
| title | string |
| type | medication / checkup / hospital / personal |
| date | timestamp |
| memo | string |
| completed | bool |
| createdAt | timestamp |

---

# 8. health_records

모든 건강 기록을 하나의 Collection으로 관리한다.

```text
users/{uid}/health_records
```

### Fields

| Field | Type |
|---------|------|
| type | weight / blood_pressure / blood_sugar / water / exercise |
| value | number |
| unit | string |
| memo | string |
| recordedAt | timestamp |
| createdAt | timestamp |

---

# 9. ai_briefings

```text
users/{uid}/ai_briefings
```

### Fields

| Field | Type |
|---------|------|
| date | timestamp |
| title | string |
| summary | string |
| tips | array |
| warnings | array |
| createdAt | timestamp |

---

# 10. ai_chats

```text
users/{uid}/ai_chats
```

### Fields

| Field | Type |
|---------|------|
| role | user / assistant |
| message | string |
| createdAt | timestamp |

---

# 11. notifications

```text
users/{uid}/notifications
```

### Fields

| Field | Type |
|---------|------|
| title | string |
| body | string |
| type | medication / checkup / system |
| read | bool |
| sentAt | timestamp |

---

# 12. reports

```text
users/{uid}/reports
```

### Fields

| Field | Type |
|---------|------|
| period | weekly / monthly |
| medicationRate | number |
| healthScore | number |
| summary | string |
| createdAt | timestamp |

---

# 13. Collection Relationship

```text
User
│
├── Medication
│      └── Medication Log
│
├── Schedule
│
├── Health Record
│
├── AI Briefing
│
├── AI Chat
│
├── Notification
│
└── Report
```

---

# 14. Index Strategy

Composite Index 예시

- medication_logs(status, scheduledTime)
- schedules(type, date)
- health_records(type, recordedAt)

---

# 15. Soft Delete

삭제 시 즉시 제거하지 않는다.

```text
deletedAt
```

필드를 사용하여 Soft Delete를 지원한다.

---

# 16. Audit Fields

모든 Document는 다음 필드를 포함한다.

- createdAt
- updatedAt
- deletedAt (선택)

---

# 17. 확장 고려

향후 다음 Collection을 추가할 수 있다.

- prescriptions
- family_members
- wearable_records
- vaccination_records
- baby_records

기존 구조를 변경하지 않고 확장 가능하도록 설계한다.

---

# 18. ERD Summary

Mom's Time는 **사용자(User)를 중심으로 데이터를 관리하는 Firestore 구조**를 채택한다.

각 기능은 독립적인 Collection으로 분리하여 관리하며,

공통 필드와 일관된 데이터 구조를 통해 유지보수성과 확장성을 확보한다.

건강 데이터는 `health_records`로 통합 관리하여 차트, 통계, AI 분석 등 다양한 기능으로 자연스럽게 확장할 수 있도록 설계한다.