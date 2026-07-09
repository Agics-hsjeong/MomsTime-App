import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';

/// 퍼블리싱 `.appbar` 공통 앱바.
class MomsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MomsAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions = const [],
    this.leading,
  });

  final String title;
  final VoidCallback? onBack;
  final List<Widget> actions;
  final Widget? leading;

  @override
  Size get preferredSize => Size.fromHeight(AppSizes.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: AppSizes.appBarHeight,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 48.w,
      leading: leading ??
          IconButton(
            onPressed: onBack ?? () => context.pop(),
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                size: AppSizes.iconAppBar),
          ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
      actions: actions,
    );
  }
}
