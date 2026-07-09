import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

/// 퍼블리싱 `.app` 프레임 — 최대 420px, 데스크톱 바깥 배경 #EFE6E9.
abstract final class AppLayout {
  /// ScreenUtil 기준 디자인 사이즈 (퍼블리싱 `--app-max-width: 420px`).
  static const Size designSize = Size(420, 912);

  static const Color frameOuterBg = Color(0xFFEFE6E9);
}

/// 앱 콘텐츠를 420px 모바일 프레임 안에 고정.
class AppFrame extends StatelessWidget {
  const AppFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppLayout.frameOuterBg,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 420.w),
          child: Material(
            color: AppColors.background,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 40.r,
                  ),
                ],
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// 퍼블리싱 `.content` 패딩 (8 20 32).
class AppContent extends StatelessWidget {
  const AppContent({
    super.key,
    required this.child,
    this.padding,
    this.bottom = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          EdgeInsets.fromLTRB(20.w, 8.h, 20.w, bottom ? 32.h : 0),
      child: child,
    );
  }
}
