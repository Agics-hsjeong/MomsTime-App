import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_sizes.dart';

/// Mom's Time 디자인 시스템 — 타이포그래피 토큰 (ScreenUtil `.sp`)
abstract final class AppTypography {
  static const String fontFamily = 'Pretendard';

  static TextStyle get display => TextStyle(
        fontFamily: fontFamily,
        fontSize: AppSizes.fontDisplay,
        fontWeight: FontWeight.w700,
        height: 1.35,
        color: AppColors.textPrimary,
      );

  static TextStyle get headline => TextStyle(
        fontFamily: fontFamily,
        fontSize: AppSizes.fontHeadline,
        fontWeight: FontWeight.w700,
        height: 1.35,
        color: AppColors.textPrimary,
      );

  static TextStyle get title => TextStyle(
        fontFamily: fontFamily,
        fontSize: AppSizes.fontTitle,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.textPrimary,
      );

  static TextStyle get subtitle => TextStyle(
        fontFamily: fontFamily,
        fontSize: AppSizes.fontSubtitle,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.textPrimary,
      );

  static TextStyle get body => TextStyle(
        fontFamily: fontFamily,
        fontSize: AppSizes.fontBody,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get caption => TextStyle(
        fontFamily: fontFamily,
        fontSize: AppSizes.fontCaption,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textSecondary,
      );

  static TextStyle get small => TextStyle(
        fontFamily: fontFamily,
        fontSize: AppSizes.fontSmall,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textSecondary,
      );
}
