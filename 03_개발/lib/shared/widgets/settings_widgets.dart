import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/layout/app_frame.dart';
import '../../core/theme/app_colors.dart';
import 'app_card.dart';
import 'section_header.dart';

/// 설정 화면 공용 위젯 — `settings.css` 대응.

class SetLead extends StatelessWidget {
  const SetLead(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 0),
      child: Text(
        text,
        style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
      ),
    );
  }
}

class SetSection extends StatelessWidget {
  const SetSection({
    super.key,
    required this.title,
    required this.child,
    this.moreLabel,
    this.onMoreTap,
  });

  final String title;
  final Widget child;
  final String? moreLabel;
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppContent(
          bottom: false,
          child: SectionHeader(
            title: title,
            moreLabel: moreLabel,
            onMoreTap: onMoreTap,
          ),
        ),
        AppContent(bottom: false, child: child),
      ],
    );
  }
}

class SetList extends StatelessWidget {
  const SetList({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(children: children),
    );
  }
}

class SetRow extends StatelessWidget {
  const SetRow({
    super.key,
    required this.title,
    this.subtitle,
    this.value,
    this.icon,
    this.iconColor,
    this.onTap,
    this.trailing,
    this.showDivider = true,
  });

  final String title;
  final String? subtitle;
  final String? value;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 15.h),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon,
                  size: 22.sp, color: iconColor ?? AppColors.primaryStrong),
            ),
            SizedBox(width: 14.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (value != null)
            Text(
              value!,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
            ),
          if (trailing != null)
            trailing!
          else if (onTap != null)
            Icon(Icons.chevron_right_rounded,
                size: 20.sp, color: AppColors.textDisabled),
        ],
      ),
    );

    return Column(
      children: [
        if (onTap != null)
          InkWell(onTap: onTap, child: row)
        else
          row,
        if (showDivider)
          const Divider(height: 1, color: AppColors.divider, indent: 72),
      ],
    );
  }
}

class OptList extends StatefulWidget {
  const OptList({super.key, required this.options, this.initialIndex = 0});
  final List<String> options;
  final int initialIndex;

  @override
  State<OptList> createState() => _OptListState();
}

class _OptListState extends State<OptList> {
  late int _selected = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return SetList(
      children: [
        for (var i = 0; i < widget.options.length; i++)
          InkWell(
            onTap: () => setState(() => _selected = i),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.options[i],
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight:
                            _selected == i ? FontWeight.w700 : FontWeight.w400,
                        color: _selected == i
                            ? AppColors.primaryStrong
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.check_rounded,
                    size: 22.sp,
                    color: _selected == i
                        ? AppColors.primaryStrong
                        : Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class SetSwitchRow extends StatelessWidget {
  const SetSwitchRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return SetRow(
      title: title,
      subtitle: subtitle,
      icon: icon,
      showDivider: showDivider,
      trailing: Switch(
        value: value,
        activeThumbColor: AppColors.primaryStrong,
        onChanged: onChanged,
      ),
    );
  }
}

class SetNote extends StatelessWidget {
  const SetNote(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 20.w, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              size: 16.sp, color: AppColors.textDisabled),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textDisabled,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SetDangerActions extends StatelessWidget {
  const SetDangerActions({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: Size.fromHeight(50.h),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                '로그아웃',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: Size.fromHeight(50.h),
                side: const BorderSide(color: Color(0xFFF6D4D4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                '회원 탈퇴',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
