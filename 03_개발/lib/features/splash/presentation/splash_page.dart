import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../auth/application/auth_providers.dart';

/// Splash — 앱 실행 화면. 잠시 후 로그인 상태에 따라 이동(탭해도 이동).
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1800), _go);
  }

  void _go() {
    if (!mounted) return;
    if (firebaseReady && ref.read(authStateProvider).value != null) {
      context.go(Routes.home);
    } else {
      context.go(Routes.onboarding);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _go,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.44, 1.0],
              colors: [Color(0xFFFFF9FA), Color(0xFFFEEFF3), Color(0xFFFBD9E4)],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // 하단 장면 (핑크 언덕 + 임산부)
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: _SplashScene(),
                ),
                // 상단 브랜드
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 76.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const BrandLogo(size: 116),
                        SizedBox(height: 22.h),
                        Text(
                          "Mom's Time",
                          style: TextStyle(
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryStrong,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '엄마의 건강한 하루를 위한 동반자',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashScene extends StatelessWidget {
  const _SplashScene();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 핑크 언덕
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 210.h,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.bottomCenter,
                  radius: 1.1,
                  colors: [
                    Color(0xFFF3B7CC),
                    Color(0xFFF8CADA),
                    Color(0x00FBD9E4),
                  ],
                  stops: [0.0, 0.48, 0.74],
                ),
              ),
            ),
          ),
          // 임산부 실루엣
          Positioned(
            bottom: 0,
            child: Text('🤰🏻', style: TextStyle(fontSize: 180.sp)),
          ),
          Positioned(
            top: 40.h,
            left: 40.w,
            child: Icon(Icons.favorite_rounded,
                color: const Color(0xFFF585A8), size: 24.sp),
          ),
          Positioned(
            top: 24.h,
            right: 48.w,
            child: Icon(Icons.favorite_rounded,
                color: const Color(0xFFF7A9C1), size: 18.sp),
          ),
        ],
      ),
    );
  }
}
