import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/layout/app_frame.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/section_header.dart';

const _purple = Color(0xFF6D4FD0);

/// 쿠폰 — 퍼블리싱 31_coupon.html
class CouponPage extends StatefulWidget {
  const CouponPage({super.key});

  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  int _tab = 0;
  static const _tabs = ['사용 가능', '사용 내역', '만료'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MomsAppBar(title: '쿠폰'),
      body: ListView(
        padding: EdgeInsets.only(bottom: 32.h),
        children: [
          _PurpleTabs(
            labels: _tabs,
            index: _tab,
            onChanged: (i) => setState(() => _tab = i),
          ),
          SizedBox(height: 16.h),
          AppContent(
            child: switch (_tab) {
              0 => const _AvailablePanel(),
              1 => const _HistoryPanel(),
              _ => const _ExpiredPanel(),
            },
          ),
        ],
      ),
    );
  }
}

class _PurpleTabs extends StatelessWidget {
  const _PurpleTabs({
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
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: i == index ? _purple : Colors.transparent,
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
                      color: i == index ? _purple : AppColors.textDisabled,
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

class _AvailablePanel extends StatelessWidget {
  const _AvailablePanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          color: const Color(0xFFF4F0FE),
          child: Row(
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5DDF8),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.percent_rounded, color: _purple, size: 22.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('사용 가능한 쿠폰 3장',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w800)),
                    Text('구독 결제 시 바로 적용할 수 있어요.',
                        style: TextStyle(
                            fontSize: 12.5.sp,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        const _CouponCard(
          variant: _CouponVariant.purple,
          percent: '20',
          label: '할인',
          tag: 'Premium 전용',
          title: '프리미엄 첫 구독 20% 할인',
          desc: '첫 구독 결제 시 적용',
          min: '5,000원 이상',
          exp: '~ 2024.06.30',
        ),
        const _CouponCard(
          variant: _CouponVariant.pink,
          percent: '10',
          label: '할인',
          tag: '이벤트',
          title: '여름맞이 10% 할인 쿠폰',
          desc: '모든 플랜 적용 가능',
          min: '제한 없음',
          exp: '~ 2024.07.15',
        ),
        const _CouponCard(
          variant: _CouponVariant.green,
          free: true,
          label: '무료',
          tag: '신규 가입',
          title: '1개월 무료 체험 쿠폰',
          desc: '신규 회원 전용',
          min: '1개월 플랜',
          exp: '~ 2024.06.20',
        ),
        SizedBox(height: 24.h),
        SectionHeader(title: '쿠폰 사용 안내'),
        SizedBox(height: 12.h),
        AppCard(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
          child: Column(
            children: const [
              _GuideRow(Icons.receipt_long_rounded, '결제 화면에서 쿠폰을 선택해 적용할 수 있어요.'),
              _GuideRow(Icons.event_busy_rounded, '유효기간이 지난 쿠폰은 자동으로 만료 처리됩니다.'),
              _GuideRow(Icons.info_outline_rounded, '쿠폰은 중복 사용이 불가하며, 1회 결제에 1장만 적용됩니다.'),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        PrimaryButton(
          label: '쿠폰 코드 등록',
          gradient: const LinearGradient(
            colors: [Color(0xFF8B6FF0), Color(0xFF6D4FD0)],
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _HistoryPanel extends StatelessWidget {
  const _HistoryPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _HistCard('20%', '프리미엄 첫 구독 20% 할인', '2024.05.28 사용', '사용 완료', true),
        _HistCard('10%', '여름맞이 10% 할인', '2024.05.10 사용', '사용 완료', true),
      ],
    );
  }
}

class _ExpiredPanel extends StatelessWidget {
  const _ExpiredPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _HistCard('15%', '봄맞이 할인 쿠폰', '2024.04.30 만료', '만료', false),
      ],
    );
  }
}

enum _CouponVariant { purple, pink, green }

class _CouponCard extends StatelessWidget {
  const _CouponCard({
    required this.variant,
    this.percent,
    this.free = false,
    required this.label,
    required this.tag,
    required this.title,
    required this.desc,
    required this.min,
    required this.exp,
  });

  final _CouponVariant variant;
  final String? percent;
  final bool free;
  final String label;
  final String tag;
  final String title;
  final String desc;
  final String min;
  final String exp;

  Color get _leftBg => switch (variant) {
        _CouponVariant.purple => const Color(0xFFEFE9FC),
        _CouponVariant.pink => const Color(0xFFFDEFF3),
        _CouponVariant.green => const Color(0xFFE8F5EC),
      };

  Color get _accent => switch (variant) {
        _CouponVariant.purple => _purple,
        _CouponVariant.pink => AppColors.primaryStrong,
        _CouponVariant.green => const Color(0xFF22A050),
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 130.w,
              decoration: BoxDecoration(
                color: _leftBg,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.r),
                  bottomLeft: Radius.circular(18.r),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (free)
                    Text('🎁', style: TextStyle(fontSize: 34.sp))
                  else
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w800,
                          color: _accent,
                        ),
                        children: [
                          TextSpan(text: percent),
                          TextSpan(
                            text: '%',
                            style: TextStyle(fontSize: 17.sp),
                          ),
                        ],
                      ),
                    ),
                  Text(label,
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: _accent)),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: _leftBg,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(tag,
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w700,
                            color: _accent,
                          )),
                    ),
                    SizedBox(height: 10.h),
                    Text(title,
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w800)),
                    Text(desc,
                        style: TextStyle(
                            fontSize: 12.sp, color: AppColors.textSecondary)),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F4F5),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(min,
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textSecondary)),
                        ),
                        Text(exp,
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Center(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: _accent, width: 1.5),
                    minimumSize: Size(0, 40.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r)),
                  ),
                  child: Text('사용',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: _accent)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideRow extends StatelessWidget {
  const _GuideRow(this.icon, this.text);
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: const BoxDecoration(
              color: Color(0xFFEFE9FC),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _purple, size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 13.5.sp, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}

class _HistCard extends StatelessWidget {
  const _HistCard(this.disc, this.title, this.meta, this.state, this.done);

  final String disc;
  final String title;
  final String meta;
  final String state;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(16.w),
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
      child: Row(
        children: [
          SizedBox(
            width: 54.w,
            child: Text(
              disc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: done ? _purple : AppColors.textDisabled,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.w700)),
                Text(meta,
                    style: TextStyle(
                        fontSize: 12.sp, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(
            state,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: done ? const Color(0xFF22A050) : AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }
}
