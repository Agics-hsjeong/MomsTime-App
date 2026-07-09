import 'package:flutter/material.dart';

// Mom's Time 디자인 시스템 — Radius / Spacing 토큰
// `common.css` 의 --radius-* 와 8pt Grid Spacing 에 대응합니다.

/// 라운드 반경
abstract final class AppRadius {
  static const double chip = 12;
  static const double button = 16;
  static const double input = 16;
  static const double card = 20;
  static const double dialog = 24;
  static const double sheet = 28;
  static const double circle = 999;
}

/// 8pt Grid 기반 간격
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double x3 = 32;
  static const double x4 = 40;
  static const double x5 = 48;
  static const double x6 = 64;
}

/// 그림자 (Y4 / Blur12 / 8%)
abstract final class AppElevation {
  static const double card = 4;
}

/// 카드 그림자 (`common.css` --shadow-card)
abstract final class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x14F47C9C),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
}
