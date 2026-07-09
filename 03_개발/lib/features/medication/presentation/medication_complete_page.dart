import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/primary_button.dart';

/// 복약 완료 — 퍼블리싱 18_medication_complete.html
class MedicationCompletePage extends StatelessWidget {
  const MedicationCompletePage({super.key});

  static const _drugs = [
    ('1', '아목시실린정 250mg', '1 정', '오전 9:00', '오전 9:02'),
    ('2', '클라리트로마이신정 250mg', '1 정', '오후 1:00', '오후 1:01'),
    ('3', '베포타스틴정 10mg', '1 정', '저녁 7:30', '저녁 7:31'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: '복약 완료',
        actions: [
          IconButton(
            onPressed: () => context.go(Routes.home),
            icon: Icon(Icons.home_rounded, size: 24.sp),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 24.h),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 8.h),
                  child: Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Text('🤖', style: TextStyle(fontSize: 96.sp)),
                          Positioned(
                            right: -8.w,
                            bottom: 0,
                            child: Container(
                              width: 44.w,
                              height: 44.w,
                              decoration: BoxDecoration(
                                color: AppColors.primaryStrong,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.background, width: 4),
                              ),
                              child: Icon(Icons.check_rounded,
                                  color: Colors.white, size: 26.sp),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 18.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '오늘의 복약을\n모두 완료했어요! 🎉',
                              style: TextStyle(
                                fontSize: 23.sp,
                                fontWeight: FontWeight.w800,
                                height: 1.45,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              '정해진 시간에 잘 복용했어요.\n내일도 건강한 하루 보내세요!',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '복약 요약',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: const [
                                _SummaryItem(
                                  icon: Icons.event_available_rounded,
                                  label: '복용 날짜',
                                  value: '2024.06.02 (일)',
                                ),
                                _SummaryItem(
                                  icon: Icons.assignment_turned_in_rounded,
                                  label: '복용한 약',
                                  value: '3 / 3 개',
                                  showBorder: true,
                                ),
                                _SummaryItem(
                                  icon: Icons.schedule_rounded,
                                  label: '정시 복용률',
                                  value: '100%',
                                  pink: true,
                                  showBorder: true,
                                ),
                                _SummaryItem(
                                  icon: Icons.star_rounded,
                                  label: '연속 복약일',
                                  value: '12일',
                                  pink: true,
                                  showBorder: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        '복약 완료 약물',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      AppCard(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 4.h),
                        child: Column(
                          children: [
                            for (var i = 0; i < _drugs.length; i++) ...[
                              _DoneDrugRow(
                                no: _drugs[i].$1,
                                name: _drugs[i].$2,
                                dose: _drugs[i].$3,
                                timeTag: _drugs[i].$4,
                                at: _drugs[i].$5,
                                onTap: () =>
                                    context.push(Routes.medicationDetail),
                              ),
                              if (i < _drugs.length - 1)
                                const Divider(
                                    height: 1, color: AppColors.divider),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AppCard(
                        color: const Color(0xFFFDEFF3),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 32.r,
                              backgroundColor: AppColors.primaryStrong,
                              child: Icon(Icons.emoji_events_rounded,
                                  color: Colors.white, size: 32.sp),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '정말 잘하고 있어요! 👏',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '꾸준한 복약 습관이 건강을 지키는 가장 좋은 방법입니다.',
                                    style: TextStyle(
                                      fontSize: 12.5.sp,
                                      color: AppColors.textSecondary,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Icon(Icons.insights_rounded,
                                    color: AppColors.primaryStrong, size: 30.sp),
                                SizedBox(height: 4.h),
                                Text(
                                  '이번 주 복약률',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  '98%',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryStrong,
                                  ),
                                ),
                                Text(
                                  '(7일 중 6일 완료)',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AppCard(
                        color: const Color(0xFFEAF1FC),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 26.r,
                              backgroundColor: const Color(0xFF3B82F6),
                              child: Icon(Icons.event_rounded,
                                  color: Colors.white, size: 24.sp),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '내일(06.03) 복약 예정',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    '총 3개 약물  |  3회 복용',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () => context.go(Routes.home),
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: Color(0xFF3B82F6)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999.r),
                                ),
                              ),
                              child: Text(
                                '내일 일정 보기',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF3B82F6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBE4EC),
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusCard),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_rounded,
                                color: AppColors.primaryStrong, size: 32.sp),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '건강 TIP',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primaryStrong,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    '충분한 수분 섭취와 휴식은 약의 효과를 높여줘요.',
                                    style: TextStyle(
                                      fontSize: 12.5.sp,
                                      color: AppColors.textSecondary,
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
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
            child: PrimaryButton(
              label: '확인',
              onPressed: () => context.go(Routes.home),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    this.pink = false,
    this.showBorder = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool pink;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: showBorder
            ? const BoxDecoration(
                border: Border(left: BorderSide(color: AppColors.divider)),
              )
            : null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primaryStrong, size: 30.sp),
              SizedBox(height: 10.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color:
                      pink ? AppColors.primaryStrong : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoneDrugRow extends StatelessWidget {
  const _DoneDrugRow({
    required this.no,
    required this.name,
    required this.dose,
    required this.timeTag,
    required this.at,
    required this.onTap,
  });

  final String no;
  final String name;
  final String dose;
  final String timeTag;
  final String at;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15.r,
              backgroundColor: AppColors.primaryLight,
              child: Text(
                no,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryStrong,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Icon(Icons.medication_rounded,
                color: AppColors.primaryStrong, size: 30.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        dose,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          timeTag,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryStrong,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryStrong,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_rounded,
                      color: Colors.white, size: 18.sp),
                ),
                SizedBox(height: 2.h),
                Text(
                  '복용 완료',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryStrong,
                  ),
                ),
                Text(
                  at,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(width: 8.w),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.textDisabled, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
