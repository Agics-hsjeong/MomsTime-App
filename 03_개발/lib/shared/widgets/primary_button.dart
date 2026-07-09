import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';

/// 그라데이션 Primary 버튼 (퍼블리싱 `.btn--primary`).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.gradient = AppColors.primaryGradient,
    this.height,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient gradient;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSizes.radiusButton),
          child: Ink(
            height: height ?? AppSizes.btnHeight,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(AppSizes.radiusButton),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x47F2547F),
                  blurRadius: 16.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (icon != null) ...[
                  SizedBox(width: 6.w),
                  Icon(icon, color: Colors.white, size: 20.sp),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 아웃라인 보조 버튼 (퍼블리싱 `.btn--secondary`).
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height,
  });

  final String label;
  final VoidCallback? onPressed;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? AppSizes.btnHeight),
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusButton),
        ),
        textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    );
  }
}
