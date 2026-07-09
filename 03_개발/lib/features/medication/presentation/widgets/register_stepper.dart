import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

/// 약 등록 4단계 스텝 인디케이터 (퍼블리싱 `.stepper`).
class RegisterStepper extends StatelessWidget {
  const RegisterStepper({super.key, required this.currentStep});

  /// 0-based index (0 = step 1).
  final int currentStep;

  static const _labels = ['기본 정보', '복용 정보', '알림 설정', '확인'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < _labels.length; i++) ...[
            if (i > 0)
              Expanded(
                child: Container(
                  height: 2,
                  margin: EdgeInsets.only(top: 17.h),
                  color: i <= currentStep
                      ? AppColors.primary
                      : const Color(0xFFF3DDE4),
                ),
              ),
            _StepItem(
              index: i,
              label: _labels[i],
              state: i < currentStep
                  ? _StepState.done
                  : i == currentStep
                      ? _StepState.active
                      : _StepState.pending,
            ),
          ],
        ],
      ),
    );
  }
}

enum _StepState { pending, active, done }

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.index,
    required this.label,
    required this.state,
  });

  final int index;
  final String label;
  final _StepState state;

  @override
  Widget build(BuildContext context) {
    final isDone = state == _StepState.done;
    final isActive = state == _StepState.active;

    Color numBg;
    Color numFg;
    if (isDone || isActive) {
      numBg = isActive ? AppColors.primaryStrong : AppColors.primary;
      numFg = Colors.white;
    } else {
      numBg = const Color(0xFFF3DDE4);
      numFg = AppColors.textSecondary;
    }

    return SizedBox(
      width: 56.w,
      child: Column(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: numBg,
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: const Color(0x4DF2547F),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: isDone
                ? Icon(Icons.check_rounded, color: Colors.white, size: 20.sp)
                : Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: numFg,
                    ),
                  ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: isDone || isActive ? FontWeight.w700 : FontWeight.w400,
              color: isDone || isActive
                  ? AppColors.primaryStrong
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
