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

/// 가족 관리 — 퍼블리싱 12_family.html
class FamilyPage extends ConsumerWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final name = (profile?.nickname.isNotEmpty ?? false)
        ? profile!.nickname
        : '엄마';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: '가족 관리',
        leading: SizedBox(width: 48.w),
        actions: [
          const ConnectedNotificationBell(),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 32.h),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '안녕하세요, $name님 ❤️',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '우리 가족의 건강을 함께 관리해요.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.push(Routes.familyInvite),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    minimumSize: Size(0, 40.h),
                  ),
                  icon: Icon(Icons.group_add_rounded,
                      size: 18.sp, color: AppColors.primaryStrong),
                  label: Text(
                    '가족 초대하기',
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
          SizedBox(height: 16.h),
          AppContent(
            child: Column(
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: '우리 가족',
                        moreLabel: '＋ 가족 추가',
                        onMoreTap: () => context.push(Routes.familyInvite),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 150.h,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _MemberCard(
                              emoji: '👩🏻',
                              name: '혜선',
                              rel: '본인',
                              badge: '내 정보',
                              isMe: true,
                            ),
                            _MemberCard(
                              emoji: '👨🏻',
                              name: '민준',
                              rel: '남편 · 32세',
                              badge: '정상',
                              badgeColor: Color(0xFF22A050),
                            ),
                            _MemberCard(
                              emoji: '👵🏻',
                              name: '어머니',
                              rel: '59세',
                              badge: '주의',
                              badgeColor: AppColors.warning,
                            ),
                            _MemberCard(
                              emoji: '👦🏻',
                              name: '준우',
                              rel: '8세',
                              badge: '정상',
                              badgeColor: Color(0xFF22A050),
                            ),
                            _AddMemberCard(
                              onTap: () => context.push(Routes.familyInvite),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDEFF3),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.favorite_rounded,
                                color: AppColors.primaryStrong, size: 20.sp),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                '가족을 추가하면 복약 일정, 검진 결과, 알림을 함께 관리할 수 있어요.',
                                style: TextStyle(fontSize: 12.sp, height: 1.5),
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded,
                                color: AppColors.primaryStrong, size: 20.sp),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: '가족 요약', moreLabel: '전체 보기'),
                      SizedBox(height: 12.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowHeight: 36.h,
                          dataRowMinHeight: 80.h,
                          dataRowMaxHeight: 100.h,
                          columnSpacing: 16.w,
                          headingTextStyle: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                          columns: const [
                            DataColumn(label: Text('이름')),
                            DataColumn(label: Text('복약 관리')),
                            DataColumn(label: Text('건강 상태')),
                            DataColumn(label: Text('최근 검진')),
                            DataColumn(label: Text('알림')),
                          ],
                          rows: [
                            _SummaryRow(
                              emoji: '👩🏻',
                              name: '혜선',
                              sub: '본인',
                              rate: '92%',
                              rateCaption: '잘 지키고 있어요',
                              health: '💚 좋음',
                              score: '종합 점수 85점',
                              checkup: '2024.06.02',
                              checkupType: '정기 검진',
                              alerts: '2건',
                            ),
                            _SummaryRow(
                              emoji: '👨🏻',
                              name: '민준',
                              sub: '남편 · 32세',
                              rate: '88%',
                              rateCaption: '잘 지키고 있어요',
                              health: '💚 좋음',
                              score: '종합 점수 80점',
                              checkup: '2024.05.15',
                              checkupType: '정기 검진',
                              alerts: '1건',
                            ),
                            _SummaryRow(
                              emoji: '👵🏻',
                              name: '어머니',
                              sub: '59세',
                              rate: '75%',
                              rateCaption: '주의가 필요해요',
                              health: '⚠️ 주의',
                              score: '종합 점수 68점',
                              checkup: '2024.04.20',
                              checkupType: '종합 검진',
                              alerts: '3건',
                              isWarn: true,
                            ),
                            _SummaryRow(
                              emoji: '👦🏻',
                              name: '준우',
                              sub: '8세',
                              rate: '—',
                              rateCaption: '해당 없음',
                              health: '💚 좋음',
                              score: '종합 점수 90점',
                              checkup: '2024.03.10',
                              checkupType: '성장 검진',
                              alerts: '0건',
                              noRate: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: '가족 알림', moreLabel: '모두 보기'),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 130.h,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            const _AlertCard(
                              bg: Color(0xFFFDEFF3),
                              icon: Icons.medication_rounded,
                              who: '👨🏻',
                              title: '민준님의 약 복용 시간이에요',
                              meta: '혈압약 1정\n오전 9:00',
                            ),
                            const _AlertCard(
                              bg: Color(0xFFFEF3E2),
                              icon: Icons.calendar_month_rounded,
                              who: '👵🏻',
                              title: '어머니의 검사 예정일',
                              meta: '정기 혈액검사\n2024.06.10 (월)',
                            ),
                            _AlertCard(
                              bg: AppColors.aiPurpleLight,
                              icon: Icons.favorite_rounded,
                              iconColor: Color(0xFF7C5CD6),
                              who: '👩🏻',
                              title: '$name님의 약 리필 필요',
                              meta: '엽산 400mcg 외 1종\n3일 남음',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.aiPurpleLight,
                    borderRadius: BorderRadius.circular(AppSizes.radiusCard),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('🤖', style: TextStyle(fontSize: 54.sp)),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI가 우리 가족의 건강을 지켜드려요',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '가족의 건강 데이터를 분석해 맞춤 관리 팁과 예방 알림을 제공해드려요.',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () => context.push(Routes.report),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'AI 가족 건강 리포트 보기',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF7C5CD6),
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded,
                                  size: 16.sp, color: const Color(0xFF7C5CD6)),
                            ],
                          ),
                        ),
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

class _MemberCard extends StatelessWidget {
  const _MemberCard({
    required this.emoji,
    required this.name,
    required this.rel,
    required this.badge,
    this.badgeColor,
    this.isMe = false,
  });

  final String emoji;
  final String name;
  final String rel;
  final String badge;
  final Color? badgeColor;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88.w,
      margin: EdgeInsets.only(right: 10.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFFFFF3F7) : AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        border: isMe
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.4))
            : null,
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Text(emoji, style: TextStyle(fontSize: 36.sp)),
              if (isMe)
                Positioned(
                  right: -4.w,
                  top: -4.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryStrong,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      '나',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(name,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
          Text(rel,
              style: TextStyle(
                  fontSize: 10.sp, color: AppColors.textSecondary)),
          SizedBox(height: 4.h),
          StatusChip(
            label: badge,
            height: 24.h,
            backgroundColor: badgeColor != null
                ? badgeColor!.withValues(alpha: 0.12)
                : const Color(0xFFFFF3F7),
            color: badgeColor ?? AppColors.primaryStrong,
          ),
        ],
      ),
    );
  }
}

class _AddMemberCard extends StatelessWidget {
  const _AddMemberCard({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: 88.w,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add_rounded,
                color: AppColors.textSecondary, size: 22.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            '가족 추가',
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
      ),
    );
  }
}

class _SummaryRow extends DataRow {
  _SummaryRow({
    required String emoji,
    required String name,
    required String sub,
    required String rate,
    required String rateCaption,
    required String health,
    required String score,
    required String checkup,
    required String checkupType,
    required String alerts,
    bool isWarn = false,
    bool noRate = false,
  }) : super(
          cells: [
            DataCell(Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(emoji, style: TextStyle(fontSize: 18.sp)),
                    SizedBox(width: 6.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.w700)),
                        Text(sub,
                            style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ],
            )),
            DataCell(Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  rate,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: noRate ? AppColors.textDisabled : null,
                  ),
                ),
                Text(rateCaption,
                    style: TextStyle(
                        fontSize: 10.sp, color: AppColors.textSecondary)),
              ],
            )),
            DataCell(Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(health,
                    style: TextStyle(
                        fontSize: 12.sp, fontWeight: FontWeight.w700)),
                Text(score,
                    style: TextStyle(
                        fontSize: 10.sp, color: AppColors.textSecondary)),
              ],
            )),
            DataCell(Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(checkup,
                    style: TextStyle(
                        fontSize: 12.sp, fontWeight: FontWeight.w700)),
                Text(checkupType,
                    style: TextStyle(
                        fontSize: 10.sp, color: AppColors.textSecondary)),
              ],
            )),
            DataCell(Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🔔', style: TextStyle(fontSize: 14.sp)),
                Text(alerts,
                    style: TextStyle(
                        fontSize: 10.sp, color: AppColors.textSecondary)),
              ],
            )),
          ],
        );
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.bg,
    required this.icon,
    this.iconColor,
    required this.who,
    required this.title,
    required this.meta,
  });

  final Color bg;
  final IconData icon;
  final Color? iconColor;
  final String who;
  final String title;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 10.w),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon,
                  size: 20.sp,
                  color: iconColor ?? AppColors.primaryStrong),
              Text(who, style: TextStyle(fontSize: 18.sp)),
            ],
          ),
          SizedBox(height: 8.h),
          Text(title,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
          SizedBox(height: 4.h),
          Text(meta,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              )),
        ],
      ),
    );
  }
}
