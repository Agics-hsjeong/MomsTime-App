import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';

/// 상단 알림 벨 + 뱃지 (퍼블리싱 `.bell` / `.home-top__bell`).
class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key, this.count = 0, this.onTap});

  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      style: IconButton.styleFrom(minimumSize: Size(40.w, 40.w)),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(Icons.notifications_rounded, size: 26.sp),
          if (count > 0)
            Positioned(
              top: -4.h,
              right: -6.w,
              child: Container(
                constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.w),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  count > 9 ? '9+' : '$count',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
