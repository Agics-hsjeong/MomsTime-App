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
import '../../shell/presentation/main_shell.dart';

/// 마이페이지 — 퍼블리싱 15_my_page.html
class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final nickname = (profile?.nickname.isNotEmpty ?? false)
        ? profile!.nickname
        : '엄마';
    final due = profile?.dueDate;
    final dday =
        due == null ? null : due.difference(DateTime.now()).inDays + 1;
    final pregnancyLabel = profile == null
        ? ''
        : (profile.pregnancyStage.label);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: '마이페이지',
        leading: SizedBox(width: 40.w),
        actions: [
          IconButton(
            onPressed: () => context.push(Routes.accountSecurity),
            icon: Icon(Icons.settings_rounded, size: 24.sp),
          ),
          const ConnectedNotificationBell(),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: AppSizes.contentPaddingBottom),
        children: [
          AppContent(
            bottom: false,
            child: AppCard(
              color: const Color(0xFFFDEFF3),
              onTap: () => context.push(Routes.profileEdit),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 44.r,
                        backgroundColor: AppColors.surface,
                        backgroundImage: (profile?.profileImage.isNotEmpty ??
                                false)
                            ? NetworkImage(profile!.profileImage)
                            : null,
                        child: (profile?.profileImage.isNotEmpty ?? false)
                            ? null
                            : Text('👩🏻', style: TextStyle(fontSize: 46.sp)),
                      ),
                      Positioned(
                        right: -2.w,
                        bottom: -2.h,
                        child: Container(
                          width: 28.w,
                          height: 28.w,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x14F47C9C),
                                blurRadius: 12.r,
                                offset: Offset(0, 4.h),
                              ),
                            ],
                          ),
                          child: Icon(Icons.photo_camera_rounded,
                              size: 15.sp, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '안녕하세요, $nickname님 💕',
                                style: TextStyle(
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded,
                                color: AppColors.textDisabled, size: 24.sp),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '맘케어와 함께 건강한 하루 보내세요!',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // (동적) 임신 정보 배지
                        if (due != null)
                          Row(
                            children: [
                              Expanded(
                                child: _ProfileBadge(
                                  emoji: '👶',
                                  label: pregnancyLabel.isEmpty
                                      ? '임신 정보'
                                      : pregnancyLabel,
                                  value: dday == null ? '-' : 'D-$dday일',
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: _ProfileBadge(
                                  icon: Icons.calendar_month_rounded,
                                  label: '출산 예정일',
                                  value:
                                      '${due.year}.${due.month.toString().padLeft(2, '0')}.${due.day.toString().padLeft(2, '0')}',
                                ),
                              ),
                            ],
                          )
                        else
                          _ProfileBadge(
                            emoji: '👶',
                            label: pregnancyLabel.isEmpty
                                ? '임신 단계'
                                : pregnancyLabel,
                            value: '프로필에서 설정',
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          AppContent(
            bottom: false,
            child: Row(
              children: [
                Expanded(
                  child: _PremiumCard(
                    onTap: () => context.push(Routes.premium),
                  ),
                ),
                SizedBox(width: 12.w),
                const Expanded(child: _PointCard()),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          AppContent(
            bottom: false,
            child: SectionHeader(title: '바로가기', moreLabel: '편집'),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: GridView.count(
              crossAxisCount: 6,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8.h,
              crossAxisSpacing: 8.w,
              childAspectRatio: 0.72,
              children: [
                _Shortcut(
                  icon: Icons.medication_rounded,
                  label: '복약 관리',
                  onTap: () => switchMainTab(context, 1),
                ),
                _Shortcut(
                  icon: Icons.calendar_month_rounded,
                  label: '캘린더',
                  onTap: () => switchMainTab(context, 2),
                ),
                _Shortcut(
                  emoji: '🤖',
                  label: 'AI 케어',
                  onTap: () => switchMainTab(context, 3),
                ),
                _Shortcut(
                  emoji: '💙',
                  label: '건강 기록',
                  onTap: () => context.push(Routes.health),
                ),
                _Shortcut(
                  icon: Icons.science_rounded,
                  label: '검사/검진',
                  onTap: () => context.push(Routes.checkup),
                ),
                _Shortcut(
                  icon: Icons.groups_rounded,
                  label: '가족 관리',
                  onTap: () => context.push(Routes.family),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          AppContent(
            bottom: false,
            child: SectionHeader(title: '나의 정보'),
          ),
          SizedBox(height: 12.h),
          AppContent(
            bottom: false,
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _MenuItem(
                    lead: '👤',
                    title: '내 정보',
                    subtitle: '개인 정보를 확인하고 수정할 수 있어요.',
                    onTap: () => context.push(Routes.profileEdit),
                  ),
                  _MenuItem(
                    icon: Icons.verified_user_rounded,
                    iconColor: const Color(0xFF7C5CD6),
                    title: '계정 및 보안',
                    subtitle: '비밀번호 변경, 생체인증, 로그인 관리',
                    onTap: () => context.push(Routes.accountSecurity),
                  ),
                  _MenuItem(
                    lead: '🔔',
                    title: '알림 설정',
                    subtitle: '앱 알림 및 푸시 알림 설정',
                    onTap: () => context.push(Routes.notificationSettings),
                  ),
                  _MenuItem(
                    lead: '🌐',
                    title: '언어 및 지역',
                    subtitle: '언어, 날짜/시간 형식 설정',
                    onTap: () => context.push(Routes.languageRegion),
                  ),
                  _MenuItem(
                    lead: '💬',
                    title: '도움말 및 문의',
                    subtitle: '자주 묻는 질문, 1:1 문의',
                    onTap: () => context.push(Routes.help),
                  ),
                  _MenuItem(
                    lead: 'ℹ️',
                    title: '앱 정보',
                    subtitle: '버전, 이용약관, 개인정보처리방침',
                    onTap: () => context.push(Routes.appInfo),
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          AppContent(
            bottom: false,
            child: SectionHeader(
              title: '이번 주 건강 요약',
              moreLabel: '더보기',
              onMoreTap: () => context.push(Routes.statistics),
            ),
          ),
          SizedBox(height: 12.h),
          AppContent(
            bottom: false,
            child: AppCard(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: const [
                  _WeekStat(
                    icon: Icons.favorite_rounded,
                    bg: Color(0xFFFDEFF3),
                    iconColor: AppColors.primaryStrong,
                    label: '복약 실천율',
                    value: '92',
                    unit: '%',
                    goal: '7/7회',
                  ),
                  _WeekStat(
                    icon: Icons.water_drop_rounded,
                    bg: Color(0xFFE9EFFC),
                    iconColor: Color(0xFF3B82F6),
                    label: '수분 섭취',
                    value: '1,300',
                    unit: 'ml',
                    goal: '목표 1,500ml',
                  ),
                  _WeekStat(
                    icon: Icons.bedtime_rounded,
                    bg: AppColors.aiPurpleLight,
                    iconColor: Color(0xFF3B82F6),
                    label: '평균 수면',
                    value: '7시간 30분',
                    goal: '목표 7~8시간',
                  ),
                  _WeekStat(
                    icon: Icons.directions_walk_rounded,
                    bg: Color(0xFFE4F5F2),
                    iconColor: Color(0xFF14B8A6),
                    label: '걸음 수',
                    value: '6,253',
                    unit: '걸음',
                    goal: '목표 8,000걸음',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          AppContent(
            bottom: false,
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFBE4EC),
                borderRadius: BorderRadius.circular(AppSizes.radiusCard),
              ),
              child: Row(
                children: [
                  Text('🎁', style: TextStyle(fontSize: 44.sp)),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '소중한 사람에게 맘케어를 선물해보세요!',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '프리미엄 이용권을 선물할 수 있어요.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 42.h,
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '선물하기',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryStrong,
                      ),
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

class _ProfileBadge extends StatelessWidget {
  const _ProfileBadge({
    required this.label,
    required this.value,
    this.emoji,
    this.icon,
  });

  final String? emoji;
  final IconData? icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          if (emoji != null)
            Text(emoji!, style: TextStyle(fontSize: 20.sp))
          else
            Icon(icon, color: AppColors.primaryStrong, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
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

class _PremiumCard extends StatelessWidget {
  const _PremiumCard({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(16.w),
      onTap: onTap,
      child: Row(
        children: [
          Icon(Icons.favorite_rounded,
              color: AppColors.primaryStrong, size: 32.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '맘케어 프리미엄',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    StatusChip(label: '사용 중', height: 20.h),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  '다음 결제일 2024.07.02',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: AppColors.textDisabled, size: 20.sp),
        ],
      ),
    );
  }
}

class _PointCard extends StatelessWidget {
  const _PointCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Text('⭐', style: TextStyle(fontSize: 32.sp)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '온기 ⓘ',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '1,250',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: ' P',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: AppColors.textDisabled, size: 20.sp),
        ],
      ),
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({
    required this.label,
    this.icon,
    this.emoji,
    this.onTap,
  });

  final IconData? icon;
  final String? emoji;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x14F47C9C),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (emoji != null)
            Text(emoji!, style: TextStyle(fontSize: 22.sp))
          else
            Icon(icon, color: AppColors.primaryStrong, size: 22.sp),
          SizedBox(height: 6.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.title,
    required this.subtitle,
    this.lead,
    this.icon,
    this.iconColor,
    this.onTap,
    this.showDivider = true,
  });

  final String? lead;
  final IconData? icon;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
          child: Row(
            children: [
              if (lead != null)
                Text(lead!, style: TextStyle(fontSize: 22.sp))
              else
                Icon(icon, color: iconColor, size: 22.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: AppColors.textDisabled, size: 20.sp),
            ],
          ),
        ),
        ),
        if (showDivider)
          const Divider(height: 1, color: AppColors.divider, indent: 52),
      ],
    );
  }
}

class _WeekStat extends StatelessWidget {
  const _WeekStat({
    required this.icon,
    required this.bg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.goal,
    this.unit,
  });

  final IconData icon;
  final Color bg;
  final Color iconColor;
  final String label;
  final String value;
  final String? unit;
  final String goal;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 2.h),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: unit != null ? 16.sp : 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (unit != null)
                  TextSpan(
                    text: unit,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            goal,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.sp, color: AppColors.textDisabled),
          ),
        ],
      ),
    );
  }
}
