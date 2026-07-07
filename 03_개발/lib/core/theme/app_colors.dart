import 'package:flutter/material.dart';

/// Mom's Time 디자인 시스템 — 컬러 토큰
///
/// `02_퍼블리싱/assets/css/common.css` 의 CSS 변수와 1:1 대응합니다.
abstract final class AppColors {
  // Primary
  static const Color primary = Color(0xFFF47C9C);
  static const Color primaryStrong = Color(0xFFF2547F); // 버튼 그라데이션 진한 톤
  static const Color primaryLight = Color(0xFFFFE7EE);
  static const Color primaryDark = Color(0xFFD95F84);

  // AI (Purple)
  static const Color aiPurple = Color(0xFFA78BFA);
  static const Color aiPurpleLight = Color(0xFFF3EEFF);

  // Surface / Background
  static const Color background = Color(0xFFFFF5F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFF3E3E8);
  static const Color divider = Color(0xFFF7EDF0);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Text
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF9CA3AF);

  /// Primary 버튼 그라데이션 (135deg, primary → primaryStrong)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryStrong],
  );

  /// AI 그라데이션 (135deg, #B99CFF → aiPurple)
  static const LinearGradient aiGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB99CFF), aiPurple],
  );
}
