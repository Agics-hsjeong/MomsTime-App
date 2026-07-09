import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/primary_button.dart';
import 'register_stepper.dart';

/// 약 등록 위저드 공통 레이아웃 (앱바 + 스텝 + 본문 + 하단 CTA).
class RegisterScaffold extends StatelessWidget {
  const RegisterScaffold({
    super.key,
    required this.step,
    required this.body,
    required this.onNext,
    this.onPrev,
    this.nextLabel = '다음',
    this.nextIcon,
    this.showDraft = true,
    this.showPrev = false,
  });

  final int step;
  final Widget body;
  final VoidCallback onNext;
  final VoidCallback? onPrev;
  final String nextLabel;
  final IconData? nextIcon;
  final bool showDraft;
  final bool showPrev;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (showPrev && onPrev != null) {
                        onPrev!();
                      } else {
                        context.pop();
                      }
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
                  ),
                  Expanded(
                    child: Text(
                      '약 등록',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (showDraft)
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        '임시저장',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryStrong,
                        ),
                      ),
                    )
                  else
                    SizedBox(width: 48.w),
                ],
              ),
            ),
            RegisterStepper(currentStep: step),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                child: body,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
              child: showPrev
                  ? Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            label: '이전',
                            onPressed: onPrev,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          flex: 2,
                          child: PrimaryButton(
                            label: nextLabel,
                            icon: nextIcon,
                            onPressed: onNext,
                          ),
                        ),
                      ],
                    )
                  : PrimaryButton(
                      label: nextLabel,
                      icon: nextIcon ?? Icons.chevron_right_rounded,
                      onPressed: onNext,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
