import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';

/// 퍼블리싱 `.bottom-nav` — Material NavigationBar 대신 HTML 구조 그대로.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = <(IconData, IconData, String)>[
    (Icons.home_rounded, Icons.home_rounded, '홈'),
    (Icons.medication_rounded, Icons.medication_rounded, '복약 관리'),
    (Icons.calendar_month_rounded, Icons.calendar_month_rounded, '캘린더'),
    (Icons.smart_toy_rounded, Icons.smart_toy_rounded, 'AI 케어'),
    (Icons.person_rounded, Icons.person_rounded, '마이페이지'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Container(
      height: AppSizes.bottomNavHeight + bottomInset,
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.divider)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0FF47C9C),
            blurRadius: 12.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          for (var i = 0; i < _items.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _items[i].$1,
                      size: AppSizes.iconNav,
                      color: i == currentIndex
                          ? AppColors.primaryStrong
                          : AppColors.textDisabled,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _items[i].$3,
                      style: TextStyle(
                        fontSize: AppSizes.fontTiny,
                        fontWeight: i == currentIndex
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: i == currentIndex
                            ? AppColors.primaryStrong
                            : AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
