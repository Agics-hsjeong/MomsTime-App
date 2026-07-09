import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';

/// 복약 체크 원형 버튼 (퍼블리싱 `.check-circle`).
class MedCheckCircle extends StatelessWidget {
  const MedCheckCircle({
    super.key,
    required this.checked,
    this.onTap,
  });

  final bool checked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          color: checked ? AppColors.primaryStrong : AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: checked ? AppColors.primaryStrong : AppColors.border,
            width: 2,
          ),
        ),
        child: checked
            ? Icon(Icons.check_rounded, color: Colors.white, size: 18.sp)
            : null,
      ),
    );
  }
}
