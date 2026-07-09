import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_frame.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/section_header.dart';

const _purple = Color(0xFF6D4FD0);

/// 구독 멤버십 — 퍼블리싱 29_subscription.html
class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int _plan = 0;

  static const _plans = [
    ('1개월 플랜', '매월 자동 결제', '5,900원', '/월', null, null, null),
    ('6개월 플랜', '6개월마다 자동 결제', '31,900원', '', '35,400원', '10% 할인', '(월 5,317원)'),
    ('12개월 플랜', '12개월마다 자동 결제', '56,900원', '', '70,800원', '20% 할인', '(월 4,742원)'),
  ];

  @override
  Widget build(BuildContext context) {
    final selected = _plans[_plan];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: '구독 멤버십',
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('복원',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: _purple)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 24.h),
              children: [
                AppContent(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppCard(
                        color: const Color(0xFFF5F1FE),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                      height: 1.5,
                                    ),
                                    children: const [
                                      TextSpan(text: "Mom's Time Premium으로\n"),
                                      TextSpan(
                                        text: '더 건강한 하루를 시작하세요!',
                                        style: TextStyle(color: _purple),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                SizedBox(
                                  width: 240.w,
                                  child: Text(
                                    '복약 관리부터 AI 브리핑까지, 모든 기능을 제한 없이 이용할 수 있어요.',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.textSecondary,
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 0,
                              top: 20.h,
                              child: Text('💎', style: TextStyle(fontSize: 76.sp)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SectionHeader(title: '멤버십 혜택'),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          _Benefit(Icons.medication_rounded, '복약 알림\n무제한', '약 복용 시간 놓치지 않기'),
                          _Benefit(Icons.assignment_rounded, '검진 결과\n관리', '결과 보관 및 추이 확인'),
                          _Benefit(Icons.favorite_rounded, 'AI 건강\n브리핑', '맞춤 건강 인사이트 제공'),
                          _Benefit(Icons.analytics_rounded, '상세 통계\n분석', '건강 데이터 심층 분석'),
                          _Benefit(Icons.groups_rounded, '가족 공유\n확대', '최대 10명까지 초대'),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      SectionHeader(title: '멤버십 플랜 선택'),
                      SizedBox(height: 12.h),
                      for (var i = 0; i < _plans.length; i++)
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _PlanRow(
                            name: _plans[i].$1,
                            cycle: _plans[i].$2,
                            price: _plans[i].$3,
                            suffix: _plans[i].$4,
                            was: _plans[i].$5,
                            off: _plans[i].$6,
                            month: _plans[i].$7,
                            selected: _plan == i,
                            onTap: () => setState(() => _plan = i),
                          ),
                        ),
                      SizedBox(height: 16.h),
                      AppCard(
                        color: const Color(0xFFF4F0FE),
                        child: Row(
                          children: [
                            Container(
                              width: 44.w,
                              height: 44.w,
                              decoration: const BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.verified_user_rounded,
                                  color: _purple, size: 20.sp),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('안심하고 이용하세요',
                                      style: TextStyle(
                                          fontSize: 13.5.sp,
                                          fontWeight: FontWeight.w800,
                                          color: _purple)),
                                  Text(
                                    '구독은 언제든지 취소할 수 있으며, 취소 후에도 남은 기간 동안 서비스가 유지됩니다.',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.textSecondary,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text('구독 정책 보기 ›',
                                style: TextStyle(
                                    fontSize: 12.5.sp,
                                    fontWeight: FontWeight.w700,
                                    color: _purple)),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SectionHeader(title: '결제 정보'),
                      SizedBox(height: 12.h),
                      AppCard(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                        child: Column(
                          children: [
                            _PayRow(
                              icon: Icons.credit_card_rounded,
                              title: '카카오페이',
                              sub: 'kakaopay@example.com',
                              onTap: () => context.push(Routes.payment),
                            ),
                            _PayRow(
                              icon: Icons.percent_rounded,
                              title: '쿠폰 사용',
                              trailing: '사용 가능한 쿠폰이 있어요 ›',
                              onTap: () => context.push(Routes.coupon),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SectionHeader(title: '결제 금액'),
                      SizedBox(height: 12.h),
                      AppCard(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                        child: Column(
                          children: [
                            _TotalRow('선택한 플랜', selected.$1),
                            Divider(color: AppColors.divider, height: 24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('결제 금액',
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w800)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(selected.$3,
                                        style: TextStyle(
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w800,
                                          color: _purple,
                                        )),
                                    Text('부가세 포함',
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            color: AppColors.textSecondary)),
                                  ],
                                ),
                              ],
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
          Container(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Column(
              children: [
                PrimaryButton(
                  label: '${selected.$3}으로 구독 시작하기',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B6FF0), Color(0xFF6D4FD0)],
                  ),
                  onPressed: () => context.push(Routes.payment),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_rounded,
                        size: 15.sp, color: AppColors.textDisabled),
                    SizedBox(width: 6.w),
                    Text(
                      '결제는 안전하게 처리되며, 구독 정보는 암호화되어 보호됩니다.',
                      style: TextStyle(
                          fontSize: 11.5.sp, color: AppColors.textDisabled),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit(this.icon, this.title, this.desc);
  final IconData icon;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: const BoxDecoration(
              color: Color(0xFFEFE9FC),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryStrong, size: 22.sp),
          ),
          SizedBox(height: 8.h),
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w800)),
          Text(desc,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10.sp, color: AppColors.textSecondary, height: 1.45)),
        ],
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow({
    required this.name,
    required this.cycle,
    required this.price,
    required this.suffix,
    this.was,
    this.off,
    this.month,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String cycle;
  final String price;
  final String suffix;
  final String? was;
  final String? off;
  final String? month;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF8F5FF) : AppColors.surface,
          border: Border.all(
            color: selected ? _purple : AppColors.divider,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? _purple : AppColors.border,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: const BoxDecoration(
                          color: _purple,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(name,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w800)),
                      if (off != null) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDE7EF),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(off!,
                              style: TextStyle(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryStrong,
                              )),
                        ),
                      ],
                    ],
                  ),
                  Text(cycle,
                      style: TextStyle(
                          fontSize: 12.sp, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (was != null)
                  Text(was!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textDisabled,
                        decoration: TextDecoration.lineThrough,
                      )),
                Text(price,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: selected && was == null
                          ? _purple
                          : (was != null
                              ? AppColors.primaryStrong
                              : AppColors.textPrimary),
                    )),
                if (suffix.isNotEmpty)
                  Text(suffix,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800)),
                if (month != null)
                  Text(month!,
                      style: TextStyle(
                          fontSize: 11.5.sp,
                          color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PayRow extends StatelessWidget {
  const _PayRow({
    required this.icon,
    required this.title,
    this.sub,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? sub;
  final String? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: const Color(0xFFEFE9FC),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: _purple, size: 22.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w700)),
                  if (sub != null)
                    Text(sub!,
                        style: TextStyle(
                            fontSize: 12.5.sp,
                            color: AppColors.textSecondary)),
                ],
              ),
            ),
            if (trailing != null)
              Text(trailing!,
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: _purple))
            else
              Icon(Icons.chevron_right_rounded,
                  color: AppColors.textDisabled),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14.sp, color: AppColors.textSecondary)),
          Text(value,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
