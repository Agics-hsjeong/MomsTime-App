import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ScreenUtil 기반 크기 토큰 — `common.css` 레이아웃 변수 대응.
abstract final class AppSizes {
  static double get maxWidth => 420.w;

  // Layout
  static double get appBarHeight => 56.h;
  static double get bottomNavHeight => 64.h;
  static double get contentPaddingH => 20.w;
  static double get contentPaddingTop => 8.h;
  static double get contentPaddingBottom => 32.h;

  // Radius (common.css --radius-*)
  static double get radiusChip => 12.r;
  static double get radiusButton => 16.r;
  static double get radiusInput => 16.r;
  static double get radiusCard => 20.r;
  static double get radiusDialog => 24.r;
  static double get radiusSheet => 28.r;

  // Spacing (8pt grid)
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 12.w;
  static double get lg => 16.w;
  static double get xl => 20.w;
  static double get xxl => 24.w;
  static double get x3 => 32.w;

  // Typography scale (.sp)
  static double get fontDisplay => 32.sp;
  static double get fontHeadline => 28.sp;
  static double get fontTitle => 24.sp;
  static double get fontSubtitle => 20.sp;
  static double get fontBody => 16.sp;
  static double get fontCaption => 14.sp;
  static double get fontSmall => 12.sp;
  static double get fontTiny => 11.sp;

  // Components
  static double get btnHeight => 56.h;
  static double get iconNav => 24.sp;
  static double get iconAppBar => 20.sp;
}
