# 🧪 Mom's Time Test Case

> **Test Case Specification v1.0**

---

# 1. 목적

본 문서는 Mom's Time 서비스의 테스트 항목과 검증 기준을 정의한다.

모든 기능은 본 문서의 테스트를 통과한 후 출시한다.

---

# 2. 테스트 범위

테스트는 다음 영역을 포함한다.

- Authentication
- Home
- Medication
- Calendar
- Health
- AI
- OCR
- Notification
- Firebase
- Offline
- Performance
- Security

---

# 3. Authentication

| ID | Test Case | Expected Result |
|----|-----------|----------------|
| AUTH-001 | Google 로그인 | 로그인 성공 |
| AUTH-002 | Apple 로그인 | 로그인 성공 |
| AUTH-003 | 로그아웃 | 세션 종료 |
| AUTH-004 | 자동 로그인 | 앱 재실행 후 유지 |

---

# 4. Home

| ID | Test Case | Expected Result |
|----|-----------|----------------|
| HOME-001 | Home 진입 | Today Care 표시 |
| HOME-002 | AI 브리핑 조회 | 정상 표시 |
| HOME-003 | Quick Action | 해당 화면 이동 |
| HOME-004 | 당일 일정 표시 | 정확한 일정 노출 |

---

# 5. Medication

| ID | Test Case | Expected Result |
|----|-----------|----------------|
| MED-001 | 약 등록 | 저장 성공 |
| MED-002 | 약 수정 | 변경 사항 반영 |
| MED-003 | 약 삭제 | 비활성 또는 삭제 처리 |
| MED-004 | 복약 완료 | 로그 저장 |
| MED-005 | 복약 미루기 | 재알림 예약 |
| MED-006 | 복약 건너뛰기 | 상태 변경 |

---

# 6. Calendar

| ID | Test Case | Expected Result |
|----|-----------|----------------|
| CAL-001 | 일정 추가 | 캘린더 반영 |
| CAL-002 | 일정 수정 | 변경 내용 표시 |
| CAL-003 | 일정 삭제 | 일정 제거 |

---

# 7. Health

| ID | Test Case | Expected Result |
|----|-----------|----------------|
| HEA-001 | 체중 기록 | 저장 성공 |
| HEA-002 | 혈압 기록 | 저장 성공 |
| HEA-003 | 물 섭취 기록 | 저장 성공 |
| HEA-004 | 기록 조회 | 최신 데이터 표시 |

---

# 8. AI

| ID | Test Case | Expected Result |
|----|-----------|----------------|
| AI-001 | AI 브리핑 생성 | JSON 생성 성공 |
| AI-002 | AI 상담 | 정상 응답 |
| AI-003 | AI 오류 처리 | 기본 안내 표시 |
| AI-004 | 응답 시간 | 10초 이내 |

---

# 9. OCR

| ID | Test Case | Expected Result |
|----|-----------|----------------|
| OCR-001 | 약 사진 업로드 | OCR 실행 |
| OCR-002 | 텍스트 추출 | 정상 인식 |
| OCR-003 | AI Parsing | JSON 변환 |
| OCR-004 | 직접 수정 | 저장 가능 |

---

# 10. Notification

| ID | Test Case | Expected Result |
|----|-----------|----------------|
| NOTI-001 | 복약 알림 | 지정 시간 수신 |
| NOTI-002 | Action 버튼 | 정상 동작 |
| NOTI-003 | 재알림 | 설정 시간 후 재발송 |
| NOTI-004 | 검사 알림 | 예정대로 수신 |

---

# 11. Firebase

| ID | Test Case | Expected Result |
|----|-----------|----------------|
| FB-001 | Firestore 저장 | 정상 저장 |
| FB-002 | Firestore 조회 | 정상 조회 |
| FB-003 | Cloud Functions | 정상 실행 |
| FB-004 | FCM | 푸시 수신 |

---

# 12. Offline

| ID | Test Case | Expected Result |
|----|-----------|----------------|
| OFF-001 | 오프라인 실행 | 캐시 데이터 표시 |
| OFF-002 | 온라인 복귀 | 자동 동기화 |
| OFF-003 | 복약 기록 | 동기화 후 반영 |

---

# 13. Security

| ID | Test Case | Expected Result |
|----|-----------|----------------|
| SEC-001 | 타 사용자 데이터 접근 | 차단 |
| SEC-002 | 인증 없는 접근 | 거부 |
| SEC-003 | Master Collection 수정 | 거부 |
| SEC-004 | 관리자 API | 권한 검증 |

---

# 14. Performance

| ID | Test Case | 목표 |
|----|-----------|------|
| PERF-001 | 앱 실행 | 3초 이내 |
| PERF-002 | 화면 전환 | 300ms 이하 |
| PERF-003 | Firestore 조회 | 500ms 이하 |
| PERF-004 | AI 응답 | 10초 이내 |

---

# 15. UI/UX

| ID | Test Case | Expected Result |
|----|-----------|----------------|
| UI-001 | 다크 모드 | 정상 표시 |
| UI-002 | 작은 화면 | 레이아웃 유지 |
| UI-003 | 큰 글꼴 | UI 깨짐 없음 |
| UI-004 | 접근성 | 버튼 터치 영역 확보 |

---

# 16. Edge Cases

- 알림 권한 거부
- 인터넷 끊김
- AI 응답 실패
- Firestore 동기화 실패
- 동일 약 중복 등록
- 앱 강제 종료 후 재실행

모든 상황에서 서비스가 정상적으로 복구되어야 한다.

---

# 17. Regression Test

매 릴리스마다 다음 기능을 반복 검증한다.

- 로그인
- Today Care
- 복약 등록
- 복약 완료
- AI 브리핑
- 알림
- 건강 기록

---

# 18. UAT (User Acceptance Test)

실제 사용자 확인 항목

- 복약이 쉬운가?
- 알림이 부담스럽지 않은가?
- AI 설명이 이해하기 쉬운가?
- 하루 관리가 편리한가?

---

# 19. Release Criteria

출시 조건

- 모든 P1 테스트 통과
- Critical Bug 0건
- High Bug 0건
- Firestore Rules 검증 완료
- Cloud Functions 정상 동작
- AI 응답 품질 확인

---

# 20. Test Summary

Mom's Time는 기능 테스트뿐 아니라

복약, 알림, AI, Firebase 동기화까지 포함한 통합 테스트를 수행한다.

모든 핵심 시나리오는 반복 검증하며,

사용자의 건강 관리 경험이 안정적으로 제공되는 것을 최우선 목표로 한다.