# 🎨 Mom's Time Design System

> **Design System v1.0**

---

# 1. Design Philosophy

엄마의시간은 의료 서비스처럼 차갑지 않고,

커뮤니티 서비스처럼 복잡하지 않으며,

명상 앱처럼 편안해야 합니다.

우리가 만들고자 하는 경험은

> **"오늘도 잘하고 있어요."**

라는 감정을 전달하는 것입니다.

---

# 2. Design Keywords

```
Warm

Soft

Simple

Premium

Modern

Trust

Care

Minimal
```

---

# 3. Design Principles

## 3.1 Care First

사용자의 불안을 자극하지 않습니다.

사용자를 배려하는 경험을 제공합니다.

---

## 3.2 Today First

앱을 열면

오늘 해야 할 일부터 보여줍니다.

---

## 3.3 One Tap Action

자주 사용하는 기능은

한 번의 터치로 실행할 수 있어야 합니다.

---

## 3.4 AI Everywhere

AI는 하나의 메뉴가 아니라

서비스 전체에 자연스럽게 녹아 있어야 합니다.

---

## 3.5 Positive Feedback

사용자를 평가하지 않습니다.

응원합니다.

예)

- 오늘도 잘하고 있어요.
- 건강한 하루를 함께 만들어요.
- 조금씩 꾸준히 이어가 볼까요?

---

# 4. Color System

## Primary

브랜드 컬러

```
#F47C9C
```

의미

- 따뜻함
- 생명
- 사랑
- 엄마

---

## Primary Light

```
#FFE7EE
```

---

## Primary Dark

```
#D95F84
```

---

## AI Purple

```
#A78BFA
```

AI

추천

브리핑

---

## Background

```
#FFFDFC
```

---

## Surface

```
#FFFFFF
```

---

## Border

```
#EFEFEF
```

---

## Success

```
#4CAF50
```

---

## Warning

```
#F59E0B
```

---

## Error

```
#EF4444
```

---

## Text

Primary

```
#1F2937
```

---

Secondary

```
#6B7280
```

---

Disabled

```
#9CA3AF
```

---

# 5. Typography

## Font

Pretendard

---

## Display

32px

Bold

---

## Headline

28px

Bold

---

## Title

24px

SemiBold

---

## Subtitle

20px

SemiBold

---

## Body

16px

Regular

---

## Caption

14px

Regular

---

## Small

12px

Regular

---

# 6. Grid System

8pt Grid

```
4

8

12

16

20

24

32

40

48

64
```

---

# 7. Border Radius

| Component | Radius |
|-----------|--------|
| Chip | 12 |
| Button | 16 |
| Input | 16 |
| Card | 20 |
| BottomSheet | 28 |
| Dialog | 24 |

---

# 8. Shadow

모든 그림자는 최소한으로 사용합니다.

```
Y : 4

Blur : 12

Opacity : 8%
```

---

# 9. Icon

Material Symbols Rounded

또는

Cupertino Icons

---

Icon Size

```
20

24

28

32
```

---

# 10. Button

## Primary Button

- Pink Fill
- White Text

사용 예

- 복약 완료
- 저장
- 시작하기

---

## Secondary Button

- White
- Gray Border

사용 예

- 취소
- 나중에

---

## Ghost Button

Border 없음

Text Only

---

## Floating Button

원형

"+"

약 등록

---

# 11. Input

Height

```
56px
```

Radius

```
16px
```

지원

- Prefix Icon
- Suffix Icon
- Validation
- Error Message

---

# 12. Card System

## Today Card

오늘 해야 할 일

---

## Medication Card

복약

영양제

---

## AI Card

오늘 브리핑

AI 추천

---

## Calendar Card

일정

검사

---

## Health Card

체중

혈압

혈당

---

## Report Card

복약률

건강 분석

---

# 13. Chip

사용 예

```
오늘

철분

18주

AI

복약완료
```

---

# 14. Bottom Navigation

메뉴

🏠 홈

💊 복약

📅 캘린더

❤️ 건강

👤 마이

---

# 15. Dialog

사용 목적

- 삭제 확인
- 복약 완료
- AI 추천
- 권한 요청

---

# 16. Bottom Sheet

사용 목적

- 약 상세
- 일정 상세
- AI 설명

---

# 17. Chart

사용

- 복약률
- 체중 변화
- 혈압
- 물 섭취

스타일

- 단순한 선(Line)
- 부드러운 곡선
- 최소한의 Grid

---

# 18. Motion

Animation Duration

```
200~300ms
```

Animation

- Fade
- Slide Up
- Scale
- Hero

과도한 Bounce 사용 금지

---

# 19. Illustration

스타일

- Flat Illustration
- Soft Gradient
- Rounded Shape
- Minimal

3D 캐릭터 사용 금지

과도한 장식 사용 금지

---

# 20. Micro Interaction

복약 완료

✔ 체크 애니메이션

---

AI 브리핑

Fade In

---

카드

Slide Up

---

버튼

Scale 0.98

---

# 21. Accessibility

- Dynamic Font 지원
- VoiceOver / TalkBack 지원
- Color Contrast 준수
- 한 손 사용 고려

---

# 22. Empty State

비어있는 화면도 친절하게 안내합니다.

예)

"아직 등록된 약이 없어요."

"첫 번째 약을 등록해볼까요?"

---

# 23. Loading

Skeleton UI 우선 사용

필요 시 Circular Progress Indicator

---

# 24. Error

기술적인 오류 문구 대신

사용자가 이해하기 쉬운 표현을 사용합니다.

예)

❌ Error 500

↓

"잠시 후 다시 시도해주세요."

---

# 25. Component Naming

Flutter Widget 기준

```
PrimaryButton

SecondaryButton

MedicationCard

TodayCard

AIBriefingCard

CalendarCard

HealthCard

ReportCard

ProgressCircle

StatusChip

SectionTitle

InfoTile
```

---

# 26. Design Token

## Colors

```
primary

primaryLight

primaryDark

background

surface

success

warning

error
```

---

## Typography

```
display

headline

title

subtitle

body

caption

small
```

---

## Radius

```
xs

sm

md

lg

xl
```

---

## Spacing

```
xs

sm

md

lg

xl
```

---

# 27. Brand Experience

엄마의시간의 디자인은

예쁘기 위한 디자인이 아닙니다.

사용자가 앱을 실행할 때

"오늘도 건강한 하루를 시작해볼까?"

라는 마음이 들도록 만드는 것이 목표입니다.

복잡한 기능보다

안심,

신뢰,

따뜻함,

그리고 꾸준한 건강 습관을 만드는 경험을 가장 중요하게 생각합니다.