# 📦 04_릴리즈노트

Mom's Time의 **버전·변경 이력**을 관리하는 폴더입니다.

| 문서 | 용도 | 대상 |
|---|---|---|
| [`VERSION.md`](./VERSION.md) | 현재 버전·버전 정책 요약·유지 규칙 | 개발/PM |
| [`CHANGELOG.md`](./CHANGELOG.md) | 모든 변경 상세 이력 (Keep a Changelog) | 개발 |
| [`RELEASE_NOTES.md`](./RELEASE_NOTES.md) | 사용자용 업데이트 안내 | 사용자/스토어 |

> 버전 **정책 원문**은 `00_기획문서/10_Release/40_Version.md` 에 있습니다.
> 이 폴더는 그 정책에 따라 **실제 이력**을 기록하는 곳입니다.

---

## 현재 상태

- **버전:** `0.3.0` (+30) — 퍼블리싱/프로토타입 완료
- **다음:** `0.4.0` — Flutter 개발 착수

---

## 개발 시작 시 워크플로우

1. 작업할 때마다 → `CHANGELOG.md` 의 `[Unreleased]` 에 한 줄 추가
2. 버전 올릴 때 →
   ```bash
   # 예: 0.4.0 릴리스
   #  1) CHANGELOG: [Unreleased] → ## [0.4.0] - YYYY-MM-DD 로 이동
   #  2) VERSION.md 현재 버전 갱신
   #  3) pubspec.yaml: version: 0.4.0+31
   #  4) 사용자 대상 변경이면 RELEASE_NOTES.md 추가
   git commit -am "chore(release): v0.4.0"
   git tag v0.4.0
   ```
3. 스토어 업로드 시 → BUILD 번호(+N)만이라도 반드시 증가

---

## 커밋 컨벤션 (권장)

`feat:` 기능 · `fix:` 수정 · `refactor:` 리팩터 · `docs:` 문서 · `chore:` 잡무
→ MINOR/PATCH 판단과 CHANGELOG 분류에 그대로 매핑됩니다.
