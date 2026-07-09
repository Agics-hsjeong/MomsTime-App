import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/layout/app_frame.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/section_header.dart';
import '../../shell/presentation/main_shell.dart';

const _purple = Color(0xFF7C5CD6);

/// 병원 상세 — 퍼블리싱 23_hospital_detail.html
class HospitalDetailPage extends StatelessWidget {
  const HospitalDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: '병원 상세',
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share_rounded, size: 26.sp)),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite_rounded,
                size: 26.sp, color: AppColors.primaryStrong),
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
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 132.w,
                        height: 132.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFDCE7F5), Color(0xFFB9CCE4)],
                          ),
                        ),
                        child: Icon(Icons.local_hospital_rounded,
                            size: 52.sp, color: AppColors.primaryStrong),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '삼성서울병원',
                                    style: TextStyle(
                                      fontSize: 21.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Icon(Icons.verified_rounded,
                                    color: _purple, size: 20.sp),
                              ],
                            ),
                            Text(
                              '종합병원  |  상급종합병원',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Text('⭐', style: TextStyle(fontSize: 14.sp)),
                                Text(' 4.7 ',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700)),
                                Text('(1,235)',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: _purple,
                                      decoration: TextDecoration.underline,
                                    )),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(Icons.location_on_rounded, size: 16.sp),
                                Expanded(
                                  child: Text(
                                    '서울특별시 강남구 일원로 81',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: AppColors.textSecondary),
                                  ),
                                ),
                                Icon(Icons.chevron_right_rounded, size: 14.sp),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.call_rounded, size: 16.sp),
                                Text(' 02-3410-2114',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _purple),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999.r)),
                          minimumSize: Size(0, 40.h),
                        ),
                        icon: Icon(Icons.location_on_rounded,
                            size: 16.sp, color: _purple),
                        label: Text('지도',
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: _purple)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                AppContent(
                  child: Column(
                    children: [
                      AppCard(
                        child: Row(
                          children: const [
                            _Action(
                              icon: Icons.call_rounded,
                              bg: Color(0xFFE8F5EC),
                              color: Color(0xFF22A050),
                              label: '전화하기',
                            ),
                            _Action(
                              icon: Icons.assignment_rounded,
                              bg: Color(0xFFEFE9FC),
                              color: _purple,
                              label: '진료 예약',
                            ),
                            _Action(
                              icon: Icons.near_me_rounded,
                              bg: Color(0xFFE7F0FB),
                              color: Color(0xFF3B82F6),
                              label: '길찾기',
                            ),
                            _Action(
                              emoji: '🏠',
                              bg: Color(0xFFE4F5F2),
                              label: '홈페이지',
                            ),
                            _Action(
                              icon: Icons.share_rounded,
                              bg: Color(0xFFF4F4F5),
                              color: AppColors.textSecondary,
                              label: '공유하기',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('진료 정보',
                                style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w800)),
                            SizedBox(height: 16.h),
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 18.h,
                              crossAxisSpacing: 16.w,
                              childAspectRatio: 1.4,
                              children: const [
                                _ClinicItem(
                                  icon: Icons.schedule_rounded,
                                  bg: Color(0xFFE7F0FB),
                                  iconColor: Color(0xFF3B82F6),
                                  title: '진료 시간',
                                  desc:
                                      '평일 08:00 ~ 17:00\n토요일 08:00 ~ 12:30\n일요일/공휴일 휴진',
                                  closed: '일요일/공휴일 휴진',
                                ),
                                _ClinicItem(
                                  icon: Icons.medical_services_rounded,
                                  bg: Color(0xFFEFE9FC),
                                  iconColor: _purple,
                                  title: '진료 과목',
                                  desc: '총 43개 진료과',
                                  showChevron: true,
                                ),
                                _ClinicItem(
                                  icon: Icons.local_parking_rounded,
                                  bg: Color(0xFFE7F0FB),
                                  iconColor: Color(0xFF3B82F6),
                                  title: '주차 안내',
                                  desc:
                                      '외래 진료 시 4시간 무료\n이후 10분당 1,000원',
                                ),
                                _ClinicItem(
                                  icon: Icons.directions_bus_rounded,
                                  bg: Color(0xFFE4F5F2),
                                  iconColor: Color(0xFF14B8A6),
                                  title: '대중교통',
                                  desc:
                                      '· 지하철 3호선 대청역 2번 출구\n· 버스 3412, 3414, 4319 등',
                                  showChevron: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SectionHeader(title: '주요 진료과', moreLabel: '전체 보기'),
                      SizedBox(height: 12.h),
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 8.h,
                        crossAxisSpacing: 8.w,
                        childAspectRatio: 0.85,
                        children: const [
                          _DeptCard(Icons.favorite_rounded, Color(0xFFFDEFF3), '내과'),
                          _DeptCard(Icons.healing_rounded, Color(0xFFE7F0FB), '정형외과'),
                          _DeptCard(null, Color(0xFFE8F5EC), '소아청소년과', emoji: '👶'),
                          _DeptCard(null, Color(0xFFFDEFF3), '산부인과', emoji: '🤰'),
                          _DeptCard(Icons.psychology_rounded, Color(0xFFEFE9FC), '신경과'),
                          _DeptCard(Icons.sanitizer_rounded, Color(0xFFFDF3E4), '피부과'),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      SectionHeader(title: '이용자 리뷰', moreLabel: '전체 보기'),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 140.h,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: const [
                            _ReviewCard(
                              stars: '★★★★★ 5.0',
                              text:
                                  '의료진이 친절하고 시설이 깨끗해요.\n대기시간도 생각보다 길지 않았습니다.',
                              meta: '2024.05.28  |  내과 진료',
                            ),
                            _ReviewCard(
                              stars: '★★★☆☆ 4.0',
                              text: '진료는 만족스러웠어요\n주차가 조금 불편했어요.',
                              meta: '2024.05.20  |  정형외과 진료',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Dot(active: true),
                          SizedBox(width: 6.w),
                          _Dot(),
                          SizedBox(width: 6.w),
                          _Dot(),
                          SizedBox(width: 6.w),
                          _Dot(),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      SectionHeader(title: '진료 가능 보험'),
                      SizedBox(height: 12.h),
                      AppCard(
                        child: Row(
                          children: const [
                            _InsItem('🫶', Color(0xFFFDEFF3), '국민건강보험'),
                            _InsItem('📑', Color(0xFFE7F0FB), '실손보험'),
                            _InsItem('👷', Color(0xFFE8F5EC), '산재보험'),
                            _InsItem('🚗', Color(0xFFE4F5F2), '자동차보험'),
                            _InsItem(null, Color(0xFFFDF3E4), '보훈',
                                icon: Icons.spa_rounded),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SectionHeader(title: '병원 안내'),
                      SizedBox(height: 12.h),
                      AppCard(
                        color: const Color(0xFFF4F0FE),
                        child: Row(
                          children: [
                            Text('📢', style: TextStyle(fontSize: 21.sp)),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '병원 방문 시 신분증과 건강보험증을 지참해주세요.',
                                    style: TextStyle(
                                      fontSize: 13.5.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    '예약 변경 및 취소는 진료 예약 메뉴에서 가능합니다.',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded,
                                color: AppColors.textDisabled),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      minimumSize: Size.fromHeight(52.h),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusButton),
                      ),
                    ),
                    icon: Icon(Icons.star_rounded,
                        size: 19.sp, color: AppColors.primaryStrong),
                    label: Text('즐겨찾기',
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryStrong)),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  flex: 12,
                  child: PrimaryButton(
                    label: '진료 예약',
                    icon: Icons.edit_calendar_rounded,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9B7EF5), Color(0xFF7C5CD6)],
                    ),
                    onPressed: () => switchMainTab(context, 2),
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

class _Action extends StatelessWidget {
  const _Action({
    this.icon,
    this.emoji,
    required this.bg,
    this.color,
    required this.label,
  });

  final IconData? icon;
  final String? emoji;
  final Color bg;
  final Color? color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Center(
              child: emoji != null
                  ? Text(emoji!, style: TextStyle(fontSize: 23.sp))
                  : Icon(icon, color: color, size: 23.sp),
            ),
          ),
          SizedBox(height: 8.h),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ClinicItem extends StatelessWidget {
  const _ClinicItem({
    required this.icon,
    required this.bg,
    required this.iconColor,
    required this.title,
    required this.desc,
    this.closed,
    this.showChevron = false,
  });

  final IconData icon;
  final Color bg;
  final Color iconColor;
  final String title;
  final String desc;
  final String? closed;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 19.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF6D4FD0),
                  )),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        if (showChevron)
          Icon(Icons.chevron_right_rounded,
              color: AppColors.textDisabled, size: 18.sp),
      ],
    );
  }
}

class _DeptCard extends StatelessWidget {
  const _DeptCard(this.icon, this.bg, this.label, {this.emoji});

  final IconData? icon;
  final Color bg;
  final String label;
  final String? emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Center(
              child: emoji != null
                  ? Text(emoji!, style: TextStyle(fontSize: 19.sp))
                  : Icon(icon, color: _purple, size: 19.sp),
            ),
          ),
          SizedBox(height: 8.h),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.stars,
    required this.text,
    required this.meta,
  });

  final String stars;
  final String text;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.w,
      margin: EdgeInsets.only(right: 10.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FB),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(stars,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.warning)),
          SizedBox(height: 10.h),
          Text(text,
              style: TextStyle(fontSize: 13.sp, height: 1.6)),
          const Spacer(),
          Text(meta,
              style: TextStyle(
                  fontSize: 11.sp, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({this.active = false});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6.w,
      height: 6.w,
      decoration: BoxDecoration(
        color: active ? _purple : const Color(0xFFDDD6F0),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _InsItem extends StatelessWidget {
  const _InsItem(this.emoji, this.bg, this.label, {this.icon});

  final String? emoji;
  final Color bg;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Center(
              child: emoji != null
                  ? Text(emoji!, style: TextStyle(fontSize: 21.sp))
                  : Icon(icon, color: AppColors.primaryStrong, size: 21.sp),
            ),
          ),
          SizedBox(height: 8.h),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
