import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'app_sizes.dart';
import 'app_typography.dart';

/// Mom's Time 앱 테마 (Material 3)
abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = const ColorScheme.light(
      primary: AppColors.primaryStrong,
      onPrimary: Colors.white,
      secondary: AppColors.aiPurple,
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.border,
    );

    final textTheme = TextTheme(
      displayLarge: AppTypography.display,
      headlineLarge: AppTypography.headline,
      titleLarge: AppTypography.title,
      titleMedium: AppTypography.subtitle,
      bodyLarge: AppTypography.body,
      bodyMedium: AppTypography.caption,
      bodySmall: AppTypography.small,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,
      dividerColor: AppColors.divider,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: AppSizes.appBarHeight,
        titleTextStyle: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryStrong,
          foregroundColor: Colors.white,
          minimumSize: Size.fromHeight(AppSizes.btnHeight),
          textStyle: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusButton),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: const TextStyle(color: AppColors.textDisabled),
      ),
    );
  }
}
