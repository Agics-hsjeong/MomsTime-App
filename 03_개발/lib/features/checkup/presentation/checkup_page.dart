import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_frame.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/connected_notification_bell.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../auth/application/auth_providers.dart';

/// 검사/검진 — 퍼블리싱 11_checkup.html
class CheckupPage extends ConsumerStatefulWidget {
  const CheckupPage({super.key});

  @override
  ConsumerState<CheckupPage> createState() => _CheckupPageState();
}

class _CheckupPageState extends ConsumerState<CheckupPage> {
  int _tab = 0;
  static const _tabs = ['전체', '예정', '완료', '결과'];

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final name = (profile?.nickname.isNotEmpty ?? false)
        ? profile!.nickname
        : '엄마';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: '검사/검진',
        actions: [
          const ConnectedNotificationBell(),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 32.h),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '안녕하세요, $name님 💕',
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 4.h),
                Text(
                  '다가오는 검사 일정을 확인해 보세요.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 44.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              children: [
                for (var i = 0; i < _tabs.length; i++)
                  Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: GestureDetector(
                      onTap: () => setState(() => _tab = i),
                      child: Container(
                        height: 44.h,
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        decoration: BoxDecoration(
                          color: _tab == i
                              ? const Color(0xFFFFF3F7)
                              : AppColors.surface,
                          border: Border.all(
                            color: _tab == i
                                ? AppColors.primaryStrong
                                : AppColors.border,
                          ),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Center(
                          child: Text(
                            _tabs[i],
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: _tab == i
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: _tab == i
                                  ? AppColors.primaryStrong
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          AppContent(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.aiPurpleLight,
                    borderRadius: BorderRadius.circular(AppSizes.radiusCard),
                  ),
                  child: Row(
                    children: [
                      Text('🤖', style: TextStyle(fontSize: 48.sp)),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI 검진 분석',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF7C5CD6),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '최근 검사 결과를 분석해 맞춤 건강 조언을 드려요.',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: const Color(0xFF7C5CD6), size: 22.sp),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                AppCard(
                  child: Row(
                    children: [
                      for (var i = 0; i < 4; i++)
                        _GlanceItem(
                          icon: [
                            Icons.calendar_month_rounded,
                            Icons.science_rounded,
                            Icons.check_circle_rounded,
                            Icons.warning_rounded,
                          ][i],
                          bg: [
                            const Color(0xFFE9EFFC),
                            const Color(0xFFFDEFF3),
                            const Color(0xFFE8F5EC),
                            const Color(0xFFFEF3E2),
                          ][i],
                          iconColor: [
                            const Color(0xFF3B82F6),
                            AppColors.primaryStrong,
                            const Color(0xFF22A050),
                            AppColors.warning,
                          ][i],
                          label: ['예정', '진행 중', '완료', '주의'][i],
                          value: ['2건', '1건', '5건', '1건'][i],
                          showBorder: i > 0,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: '최근 검사 결과', moreLabel: '전체 보기'),
                      SizedBox(height: 8.h),
                      _ResultRow(
                        icon: Icons.science_rounded,
                        bg: Color(0xFFFDEFF3),
                        title: '정기 혈액검사',
                        meta: '2024.06.10 · 삼성산부인과',
                        status: '정상',
                        statusColor: Color(0xFF22A050),
                        onTap: () => context.push(Routes.checkupDetail),
                      ),
                      _ResultRow(
                        icon: Icons.monitor_heart_rounded,
                        bg: Color(0xFFE9EFFC),
                        title: '초음파 검사',
                        meta: '2024.05.28 · 삼성산부인과',
                        status: '정상',
                        statusColor: Color(0xFF22A050),
                        onTap: () => context.push(Routes.checkupDetail),
                      ),
                      _ResultRow(
                        icon: Icons.water_drop_rounded,
                        bg: Color(0xFFFEF3E2),
                        title: '당화혈색소 검사',
                        meta: '2024.05.15 · 삼성산부인과',
                        status: '주의',
                        statusColor: AppColors.warning,
                        onTap: () => context.push(Routes.checkupDetail),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: '검사 일정', moreLabel: '캘린더 보기'),
                      SizedBox(height: 8.h),
                      const _ScheduleRow(
                        date: '06.15',
                        day: '토',
                        title: '독감 예방접종',
                        hospital: '삼성산부인과',
                        time: '14:00',
                        isUpcoming: true,
                      ),
                      const _ScheduleRow(
                        date: '06.20',
                        day: '목',
                        title: '정기 산전 검진',
                        hospital: '삼성산부인과',
                        time: '10:30',
                        isUpcoming: true,
                      ),
                      const _ScheduleRow(
                        date: '05.28',
                        day: '화',
                        title: '초음파 검사',
                        hospital: '삼성산부인과',
                        time: '11:00',
                        isUpcoming: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlanceItem extends StatelessWidget {
  const _GlanceItem({
    required this.icon,
    required this.bg,
    required this.iconColor,
    required this.label,
    required this.value,
    this.showBorder = false,
  });

  final IconData icon;
  final Color bg;
  final Color iconColor;
  final String label;
  final String value;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: showBorder
            ? const BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppColors.divider),
                ),
              )
            : null,
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Column(
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            SizedBox(height: 10.h),
            Text(label,
                style: TextStyle(
                    fontSize: 12.sp, color: AppColors.textSecondary)),
            SizedBox(height: 4.h),
            Text(value,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.icon,
    required this.bg,
    required this.title,
    required this.meta,
    required this.status,
    required this.statusColor,
    this.onTap,
  });

  final IconData icon;
  final Color bg;
  final String title;
  final String meta;
  final String status;
  final Color statusColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.primaryStrong, size: 21.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.w700)),
                Text(meta,
                    style: TextStyle(
                        fontSize: 11.sp, color: AppColors.textSecondary)),
              ],
            ),
          ),
          StatusChip(
            label: status,
            height: 24.h,
            backgroundColor: statusColor.withValues(alpha: 0.12),
            color: statusColor,
          ),
          SizedBox(width: 4.w),
          Icon(Icons.chevron_right_rounded,
              color: AppColors.textSecondary, size: 20.sp),
        ],
      ),
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({
    required this.date,
    required this.day,
    required this.title,
    required this.hospital,
    required this.time,
    required this.isUpcoming,
  });

  final String date;
  final String day;
  final String title;
  final String hospital;
  final String time;
  final bool isUpcoming;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 52.w,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: isUpcoming
                  ? const Color(0xFFFFF3F7)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(12.r),
              border: isUpcoming
                  ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
                  : null,
            ),
            child: Column(
              children: [
                Text(date,
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.w800)),
                Text(day,
                    style: TextStyle(
                        fontSize: 11.sp, color: AppColors.textSecondary)),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.w700)),
                Text('$hospital · $time',
                    style: TextStyle(
                        fontSize: 11.sp, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (isUpcoming)
            StatusChip(
              label: '예정',
              height: 22.h,
              backgroundColor: const Color(0xFFFFF3F7),
              color: AppColors.primaryStrong,
            ),
        ],
      ),
    );
  }
}
