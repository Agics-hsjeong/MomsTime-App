import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_frame.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/med_check_circle.dart';
import '../../../shared/widgets/connected_notification_bell.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/firestore_status_banner.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/app_user.dart';
import '../../ai_care/application/ai_care_providers.dart';
import '../../medication/application/medication_providers.dart';
import '../../shell/presentation/main_shell.dart';

/// 홈 (Today Care) — 퍼블리싱 05_home.html
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);
    final profile = profileAsync.value;
    final name =
        (profile?.nickname.isNotEmpty ?? false) ? profile!.nickname : '엄마';
    final summary = ref.watch(medicationSummaryProvider);
    final doses = ref.watch(todayDosesProvider);
    final doneCount = summary.completed;
    final total = summary.total;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.only(bottom: AppSizes.contentPaddingBottom),
          children: [
            const FirestoreStatusBanner(),
            if (profile != null &&
                profile.pregnancyStage == PregnancyStage.pregnant &&
                profile.dueDate == null)
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
                child: AppCard(
                  color: const Color(0xFFF4F0FE),
                  onTap: () => context.push(Routes.profileEdit),
                  child: Row(
                    children: [
                      Icon(Icons.edit_calendar_rounded,
                          color: const Color(0xFF7C5CD6), size: 22.sp),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          '$name님, 출산 예정일을 설정하면 D-day와 맞춤 케어가 더 정확해져요.',
                          style: const TextStyle(height: 1.5),
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: AppColors.textDisabled, size: 22.sp),
                    ],
                  ),
                ),
              ),
            // .home-top
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.menu_rounded, size: 26.sp),
                    style: IconButton.styleFrom(
                      minimumSize: Size(40.w, 40.w),
                    ),
                  ),
                  const Spacer(),
                  const ConnectedNotificationBell(),
                ],
              ),
            ),
            // .home-greet
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '안녕하세요, $name님 💕',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          '오늘도 건강한 하루 보내세요!',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  const _DdayChip(),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // .today-card
            AppContent(
              bottom: false,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AppCard(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '오늘의 케어',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                size: 14.sp, color: AppColors.textSecondary),
                            SizedBox(width: 4.w),
                            Text(
                              '2024.06.02 (일)',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 116.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '복약 알림',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '$doneCount',
                                      style: TextStyle(
                                        fontSize: 40.sp,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primaryStrong,
                                        height: 1,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' / $total 완료',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12.h),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999.r),
                                child: LinearProgressIndicator(
                                  value: total == 0 ? 0 : doneCount / total,
                                  minHeight: 8.h,
                                  backgroundColor: const Color(0xFFF3DDE4),
                                  color: AppColors.primaryStrong,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              GestureDetector(
                                onTap: () => switchMainTab(context, 1),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.primary),
                                    borderRadius: BorderRadius.circular(999.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '복약 관리',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primaryStrong,
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.chevron_right_rounded,
                                          size: 14.sp,
                                          color: AppColors.primaryStrong),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: doses.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  child: Text(
                                    '오늘 복용할 약이 없어요.\n약을 등록해보세요.',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.textSecondary,
                                      height: 1.5,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    for (var i = 0;
                                        i < doses.length && i < 3;
                                        i++) ...[
                                      if (i > 0)
                                        Divider(
                                            height: 20.h,
                                            color: AppColors.divider),
                                      _MedRow(
                                        name: doses[i].medication.name,
                                        dose: doses[i].medication.dosage,
                                        time: doses[i].time,
                                        done: doses[i].completed,
                                        onToggle: () => ref
                                            .read(medicationControllerProvider
                                                .notifier)
                                            .toggleDose(doses[i]),
                                      ),
                                    ],
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // .quick-menu
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  _Quick(
                    icon: Icons.medication_rounded,
                    label: '약 등록',
                    onTap: () => context.push(Routes.medicationRegister),
                  ),
                  SizedBox(width: 8.w),
                  _Quick(
                    icon: Icons.calendar_month_rounded,
                    label: '캘린더',
                    onTap: () => switchMainTab(context, 2),
                  ),
                  SizedBox(width: 8.w),
                  _Quick(
                    icon: Icons.smart_toy_rounded,
                    label: 'AI 케어',
                    color: const Color(0xFF7C5CD6),
                    onTap: () => switchMainTab(context, 3),
                  ),
                  SizedBox(width: 8.w),
                  _Quick(
                    icon: Icons.science_rounded,
                    label: '검사 일정',
                    onTap: () => context.push(Routes.checkup),
                  ),
                  SizedBox(width: 8.w),
                  _Quick(
                    icon: Icons.monitor_heart_rounded,
                    label: '건강 기록',
                    onTap: () => context.push(Routes.health),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // .home-duo
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: _ScheduleCard()),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.push(Routes.aiBriefing),
                      child: const _AiBriefingCard(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            AppContent(
              bottom: false,
              child: AppCard(
                child: Column(
                  children: [
                    SectionHeader(
                      title: '건강 기록 요약',
                      moreLabel: '더보기',
                      onMoreTap: () => context.push(Routes.health),
                      titleStyle: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    const Row(
                      children: [
                        _HealthStat(
                          icon: Icons.favorite_rounded,
                          bg: Color(0xFFFDEFF3),
                          iconColor: AppColors.primaryStrong,
                          label: '혈압',
                          value: '110/70',
                          unit: 'mmHg',
                        ),
                        _HealthStat(
                          icon: Icons.monitor_weight_rounded,
                          bg: AppColors.aiPurpleLight,
                          iconColor: Color(0xFF7C5CD6),
                          label: '체중',
                          value: '56.2',
                          unit: 'kg',
                        ),
                        _HealthStat(
                          icon: Icons.water_drop_rounded,
                          bg: Color(0xFFFDF3E4),
                          iconColor: AppColors.warning,
                          label: '혈당',
                          value: '92',
                          unit: 'mg/dL',
                        ),
                        _HealthStat(
                          icon: Icons.bedtime_rounded,
                          bg: Color(0xFFE9EFFC),
                          iconColor: Color(0xFF3B82F6),
                          label: '수면',
                          value: '7시간 30분',
                          unit: '좋음',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // .today-word
            AppContent(
              bottom: false,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBEAF0),
                  borderRadius: BorderRadius.circular(AppSizes.radiusCard),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: AppColors.surface,
                      child: Icon(Icons.lightbulb_rounded,
                          color: AppColors.warning, size: 22.sp),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '오늘의 한마디',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '규칙적인 복용과 휴식이 엄마와 아기 모두에게 큰 선물이에요 💝',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        color: AppColors.primaryStrong, size: 20.sp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DdayChip extends ConsumerWidget {
  const _DdayChip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final due = profile?.dueDate;
    final stage = profile?.pregnancyStage.label ?? '';
    final dday = due == null ? null : due.difference(DateTime.now()).inDays + 1;
    return Container(
      padding: EdgeInsets.fromLTRB(8.w, 8.h, 14.w, 8.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(999.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x14F47C9C),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.primaryLight,
            child: Text('👶', style: TextStyle(fontSize: 20.sp)),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                stage.isEmpty ? '임신 정보' : stage,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
              ),
              Text(
                dday == null ? '프로필 설정' : 'D-$dday일',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryStrong,
                ),
              ),
            ],
          ),
          SizedBox(width: 4.w),
          Icon(Icons.chevron_right_rounded,
              size: 18.sp, color: AppColors.textDisabled),
        ],
      ),
    );
  }
}

class _MedRow extends StatelessWidget {
  const _MedRow({
    required this.name,
    required this.time,
    required this.done,
    required this.onToggle,
    this.dose,
  });

  final String name;
  final String? dose;
  final String time;
  final bool done;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: name,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (dose != null)
                  TextSpan(
                    text: ' $dose',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Text(
          time,
          style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
        ),
        SizedBox(width: 10.w),
        MedCheckCircle(checked: done, onTap: onToggle),
      ],
    );
  }
}

class _Quick extends StatelessWidget {
  const _Quick({
    required this.icon,
    required this.label,
    this.color = AppColors.primaryStrong,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0x14F47C9C),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28.sp),
              SizedBox(height: 8.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: '다가오는 일정',
            moreLabel: '전체보기',
            titleStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12.h),
          const _SchedItem(
            icon: Icons.event_rounded,
            iconBg: AppColors.primaryLight,
            iconColor: AppColors.primaryStrong,
            title: '정기 검진',
            meta: '2024.06.10 (월) 10:30\n삼성산부인과',
          ),
          Divider(height: 20.h, color: AppColors.divider),
          const _SchedItem(
            icon: Icons.vaccines_rounded,
            iconBg: AppColors.aiPurpleLight,
            iconColor: Color(0xFF7C5CD6),
            title: '독감 예방접종',
            meta: '2024.06.15 (토) 14:00\n삼성산부인과',
          ),
        ],
      ),
    );
  }
}

class _SchedItem extends StatelessWidget {
  const _SchedItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.meta,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: iconColor, size: 20.sp),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 2.h),
              Text(
                meta,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AiBriefingCard extends ConsumerWidget {
  const _AiBriefingCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final briefing = ref.watch(latestAiBriefingProvider);
    final name = (profile?.nickname.isNotEmpty ?? false)
        ? profile!.nickname
        : '엄마';
    final body = briefing?.summary.isNotEmpty == true
        ? briefing!.summary
        : '$name님, 오늘의 AI 브리핑을 생성하면\n복약·건강에 맞춘 인사이트를 받을 수 있어요.';
    return AppCard(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: briefing?.title ?? 'AI 케어 브리핑',
            moreLabel: '더보기',
            titleStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF0F4),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              body,
              style: TextStyle(fontSize: 13.sp, height: 1.6),
            ),
          ),
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text('🤖', style: TextStyle(fontSize: 40.sp)),
          ),
        ],
      ),
    );
  }
}

class _HealthStat extends StatelessWidget {
  const _HealthStat({
    required this.icon,
    required this.bg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.unit,
  });

  final IconData icon;
  final Color bg;
  final Color iconColor;
  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: bg,
            child: Icon(icon, color: iconColor, size: 24.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
          ),
          Text(
            unit,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
