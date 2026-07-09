import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';

/// 퍼블리싱 `.tabs` — 하단 보더 탭.
class AppTabs extends StatelessWidget {
  const AppTabs({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: i == index
                            ? AppColors.primaryStrong
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: i == index
                          ? AppColors.primaryStrong
                          : AppColors.textDisabled,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
