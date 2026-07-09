import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';

/// 퍼블리싱 `.chip` — 작은 상태/라벨 뱃지.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.color = AppColors.primaryStrong,
    this.backgroundColor = AppColors.primaryLight,
    this.height,
  });

  final String label;
  final Color color;
  final Color backgroundColor;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 24.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusChip),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
