import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Mom's Time 디자인 시스템 — 타이포그래피 토큰
///
/// `common.css` 의 타입 스케일에 대응합니다. 폰트는 Pretendard.
abstract final class AppTypography {
  static const String fontFamily = 'Pretendard';

  static const TextStyle display = TextStyle(
    fontSize: 32, fontWeight: FontWeight.w700, height: 1.35, color: AppColors.textPrimary);
  static const TextStyle headline = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w700, height: 1.35, color: AppColors.textPrimary);
  static const TextStyle title = TextStyle(
    fontSize: 24, fontWeight: FontWeight.w600, height: 1.4, color: AppColors.textPrimary);
  static const TextStyle subtitle = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w600, height: 1.4, color: AppColors.textPrimary);
  static const TextStyle body = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textPrimary);
  static const TextStyle caption = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textSecondary);
  static const TextStyle small = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textSecondary);
}
