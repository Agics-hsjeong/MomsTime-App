import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';

/// 섹션 제목 + 더보기 링크 (퍼블리싱 `.section__head`).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.moreLabel,
    this.onMoreTap,
    this.titleStyle,
  });

  final String title;
  final String? moreLabel;
  final VoidCallback? onMoreTap;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: titleStyle ??
                TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700),
          ),
        ),
        if (moreLabel != null)
          GestureDetector(
            onTap: onMoreTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  moreLabel!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 16.sp,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
