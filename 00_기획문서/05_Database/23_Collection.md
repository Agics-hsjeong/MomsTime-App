# 📚 Mom's Time Collection Specification

> **Firestore Collection Schema v1.0**

---

# 1. 목적

본 문서는 Mom's Time에서 사용하는 모든 Firestore Collection의 상세 스키마를 정의한다.

각 Collection은 동일한 설계 원칙과 네이밍 규칙을 따른다.

---

# 2. Collection 목록

| Collection | 구분 |
|------------|------|
| users | User |
| medications | User |
| medication_logs | User |
| schedules | User |
| health_records | User |
| ai_briefings | User |
| ai_chats | User |
| notifications | User |
| reports | User |
| medication_master | Master |
| supplement_master | Master |
| checkup_master | Master |
| app_config | System |

---

# 3. 공통 필드

모든 Document는 다음 필드를 포함한다.

| Field | Type | Required |
|--------|------|----------|
| id | string | ✅ |
| createdAt | timestamp | ✅ |
| updatedAt | timestamp | ✅ |
| deletedAt | timestamp? | ❌ |

---

# 4. users

## Path

```text id="q8c11m"
users/{uid}
```

### Schema

| Field | Type | Required | Default |
|--------|------|----------|---------|
| uid | string | ✅ | - |
| nickname | string | ✅ | "" |
| email | string | ✅ | "" |
| provider | string | ✅ | google |
| pregnancyStage | string | ✅ | preparing |
| dueDate | timestamp | ❌ | null |
| birthDate | timestamp | ❌ | null |
| profileImage | string | ❌ | "" |
| createdAt | timestamp | ✅ | serverTimestamp |
| updatedAt | timestamp | ✅ | serverTimestamp |

---

# 5. medications

## Path

```text id="w2txhf"
users/{uid}/medications/{medicationId}
```

### Schema

| Field | Type | Required | Default |
|--------|------|----------|---------|
| masterId | string | ❌ | null |
| customName | string | ❌ | "" |
| type | string | ✅ | supplement |
| dosage | string | ❌ | "" |
| frequency | number | ✅ | 1 |
| times | array | ✅ | [] |
| mealType | string | ❌ | after |
| startDate | timestamp | ✅ | now |
| endDate | timestamp | ❌ | null |
| active | bool | ✅ | true |
| memo | string | ❌ | "" |

### Validation

- frequency ≥ 1
- times 개수 = frequency

---

# 6. medication_logs

## Path

```text id="xtjx1n"
users/{uid}/medication_logs/{logId}
```

### Schema

| Field | Type |
|--------|------|
| medicationId | string |
| scheduledTime | timestamp |
| completedTime | timestamp |
| status | completed / skipped / delayed |
| note | string |

---

# 7. schedules

## Path

```text id="hrw6k9"
users/{uid}/schedules/{scheduleId}
```

### Schema

| Field | Type |
|--------|------|
| title | string |
| type | medication / checkup / hospital / personal |
| date | timestamp |
| memo | string |
| completed | bool |

---

# 8. health_records

## Path

```text id="imh5ea"
users/{uid}/health_records/{recordId}
```

### Schema

| Field | Type |
|--------|------|
| type | weight / blood_pressure / blood_sugar / water / exercise |
| value | number |
| unit | string |
| memo | string |
| recordedAt | timestamp |

---

# 9. ai_briefings

## Path

```text id="krt17u"
users/{uid}/ai_briefings/{briefingId}
```

### Schema

| Field | Type |
|--------|------|
| title | string |
| summary | string |
| tips | array |
| warnings | array |
| generatedAt | timestamp |

---

# 10. ai_chats

## Path

```text id="a8j4e8"
users/{uid}/ai_chats/{chatId}
```

### Schema

| Field | Type |
|--------|------|
| role | user / assistant |
| message | string |
| createdAt | timestamp |

---

# 11. notifications

## Path

```text id="w3vgmx"
users/{uid}/notifications/{notificationId}
```

### Schema

| Field | Type |
|--------|------|
| title | string |
| body | string |
| type | medication / checkup / system |
| read | bool |
| sentAt | timestamp |

---

# 12. reports

## Path

```text id="mvgv2d"
users/{uid}/reports/{reportId}
```

### Schema

| Field | Type |
|--------|------|
| period | weekly / monthly |
| medicationRate | number |
| healthScore | number |
| summary | string |

---

# 13. medication_master

## Path

```text id="0qcdul"
medication_master/{id}
```

### Schema

| Field | Type |
|--------|------|
| name | string |
| ingredients | array |
| pregnancy | safe / caution / avoid |
| breastfeeding | safe / caution / avoid |
| interactions | array |
| cautions | array |

---

# 14. supplement_master

## Path

```text id="k06j7s"
supplement_master/{id}
```

### Schema

| Field | Type |
|--------|------|
| name | string |
| bestTime | string |
| interactions | array |
| cautions | array |

---

# 15. checkup_master

## Path

```text id="mrjlwm"
checkup_master/{id}
```

### Schema

| Field | Type |
|--------|------|
| week | string |
| title | string |
| description | string |
| preparation | array |

---

# 16. app_config

## Path

```text id="y88kij"
app_config/{configId}
```

### Schema

| Field | Type |
|--------|------|
| version | string |
| notice | string |
| faq | array |
| aiPromptVersion | string |

---

# 17. 네이밍 규칙

## Collection

- 소문자
- snake_case
- 복수형 사용

예)

```text id="5e9lyb"
health_records
medication_logs
```

---

## Field

- camelCase 사용

예)

```text id="vh2myv"
createdAt
updatedAt
masterId
```

---

# 18. 공통 규칙

- Timestamp는 UTC 기준으로 저장한다.
- 삭제는 `deletedAt`을 이용한 Soft Delete를 기본으로 한다.
- Firestore Server Timestamp를 사용한다.
- 모든 Document ID는 Firestore Auto ID를 기본으로 사용한다.

---

# 19. Repository 매핑

| Collection | Repository |
|------------|------------|
| users | UserRepository |
| medications | MedicationRepository |
| medication_logs | MedicationLogRepository |
| schedules | ScheduleRepository |
| health_records | HealthRepository |
| ai_briefings | AIBriefingRepository |
| ai_chats | AIChatRepository |
| notifications | NotificationRepository |
| reports | ReportRepository |

---

# 20. Collection Summary

Mom's Time의 Firestore Collection은 **사용자 데이터(User Data)** 와 **마스터 데이터(Master Data)** 를 명확히 분리한다.

모든 Collection은 동일한 네이밍 규칙과 공통 필드를 사용하며,

Repository와 1:1로 대응하여 유지보수성과 확장성을 높인다.

이 구조를 기반으로 Firestore, Flutter 모델, Repository, AI 분석 기능까지 일관된 방식으로 구현할 수 있다.