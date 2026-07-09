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
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../../shared/widgets/connected_notification_bell.dart';
import '../../auth/application/auth_providers.dart';

/// 프리미엄 — 퍼블리싱 14_premium.html
class PremiumPage extends ConsumerWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final name = (profile?.nickname.isNotEmpty ?? false)
        ? profile!.nickname
        : '엄마';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: '프리미엄',
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
              crossAxisAlignment: CrossAxisAlignment.end,
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
                        '더 스마트한 복약·건강 관리를 경험해 보세요.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    minimumSize: Size(0, 44.h),
                  ),
                  icon: Icon(Icons.card_giftcard_rounded,
                      size: 18.sp, color: AppColors.primaryStrong),
                  label: Text(
                    '선물하기',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryStrong,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppContent(
            bottom: false,
            child: AppCard(
              color: const Color(0xFFFFF3F6),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: '프리미엄으로\n'),
                            TextSpan(
                              text: '더 건강한 일상',
                              style: TextStyle(color: AppColors.primaryStrong),
                            ),
                            const TextSpan(text: '을 시작하세요!'),
                          ],
                        ),
                        style: TextStyle(
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      _heroBullet(
                          'AI 맞춤 케어와 다양한 프리미엄 기능을 무제한으로 이용할 수 있어요.'),
                      _heroBullet('언제든지 가입/해지할 수 있습니다.'),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Text('🤖', style: TextStyle(fontSize: 84.sp)),
                  ),
                ],
              ),
            ),
          ),
          AppContent(
            bottom: false,
            child: SectionHeader(
              title: '프리미엄 주요 혜택',
              moreLabel: '모든 혜택 보기',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Expanded(child: _Benefit(emoji: '🤖', bg: Color(0xFFFDEFF3), title: 'AI 맞춤 케어', desc: '나에게 딱 맞는 건강 관리 제안')),
                SizedBox(width: 8.w),
                Expanded(child: _Benefit(icon: Icons.calendar_month_rounded, bg: AppColors.aiPurpleLight, title: '캘린더 고급 기능', desc: '복약/검진 일정 무제한 등록')),
                SizedBox(width: 8.w),
                Expanded(child: _Benefit(icon: Icons.monitor_heart_rounded, bg: Color(0xFFFDF3E4), title: '상세 리포트', desc: '더 깊이 분석된 건강 리포트 제공')),
                SizedBox(width: 8.w),
                Expanded(child: _Benefit(icon: Icons.download_rounded, bg: Color(0xFFE4F5F2), iconColor: Color(0xFF14B8A6), title: '데이터보내기', desc: '건강 데이터를 파일로 저장')),
                SizedBox(width: 8.w),
                Expanded(child: _Benefit(icon: Icons.groups_rounded, bg: Color(0xFFE9EFFC), title: '가족 관리 확장', desc: '가족 맞춤 관리 무제한 추가')),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          AppContent(
            bottom: false,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        '프리미엄 요금제',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      const StatusChip(label: '7일 무료 체험'),
                    ],
                  ),
                ),
                Text(
                  '복원하기',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryStrong,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _PlanCard(
                    reco: true,
                    name: '월간 플랜',
                    price: '₩6,900',
                    unit: '/월',
                    note: '부가세 포함',
                    foot: '7일 무료 체험 후 결제',
                    filled: true,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _PlanCard(
                    name: '연간 플랜',
                    off: '25% 할인',
                    price: '₩62,000',
                    unit: '/년',
                    was: '₩82,800',
                    note: '월 평균 ₩5,166',
                    foot: '7일 무료 체험 후 결제',
                    outline: true,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _PlanCard(
                    name: '평생 플랜',
                    off: '60% 할인',
                    price: '₩149,000',
                    was: '₩372,000',
                    gray: true,
                  ),
                ),
              ],
            ),
          ),
          AppContent(
            child: AppCard(
              child: Row(
                children: [
                  Icon(Icons.verified_user_rounded,
                      color: const Color(0xFF7C5CD6), size: 22.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '안전한 결제',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '구독은 언제든지 취소할 수 있으며, 취소 시 다음 결제부터 적용됩니다.',
                          style: TextStyle(
                            fontSize: 12.sp,
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
            ),
          ),
          AppContent(
            bottom: false,
            child: SectionHeader(title: '기능 비교'),
          ),
          AppContent(
            child: AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: const _CompareTable(),
            ),
          ),
          AppContent(
            bottom: false,
            child: SectionHeader(title: '자주 묻는 질문', moreLabel: '더보기'),
          ),
          AppContent(
            child: Column(
              children: [
                _FaqBtn('구독을 취소하면 어떻게 되나요?'),
                SizedBox(height: 10.h),
                _FaqBtn('무료 체험 후 요금은 언제 결제되나요?'),
              ],
            ),
          ),
          AppContent(
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
                          '사랑하는 가족이나 친구에게 프리미엄을 선물해 보세요!',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '건강한 습관을 함께 만들어갈 수 있어요.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      minimumSize: Size(0, 42.h),
                    ),
                    child: Text(
                      '프리미엄 선물하기',
                      style: TextStyle(
                        fontSize: 12.sp,
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

  Widget _heroBullet(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded,
              size: 18.sp, color: AppColors.primaryStrong),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({
    required this.title,
    required this.desc,
    required this.bg,
    this.emoji,
    this.icon,
    this.iconColor,
  });

  final String title;
  final String desc;
  final Color bg;
  final String? emoji;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 6.w),
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
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: emoji != null
                ? Text(emoji!, style: TextStyle(fontSize: 21.sp))
                : Icon(icon,
                    size: 21.sp,
                    color: iconColor ?? AppColors.primaryStrong),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 4.h),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.name,
    required this.price,
    this.unit,
    this.note,
    this.was,
    this.off,
    this.foot,
    this.reco = false,
    this.filled = false,
    this.outline = false,
    this.gray = false,
  });

  final String name;
  final String price;
  final String? unit;
  final String? note;
  final String? was;
  final String? off;
  final String? foot;
  final bool reco;
  final bool filled;
  final bool outline;
  final bool gray;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, reco ? 20.h : 16.h, 10.w, 16.h),
      decoration: BoxDecoration(
        color: reco ? const Color(0xFFFFF7F9) : AppColors.surface,
        border: Border.all(
          color: reco || outline
              ? AppColors.primary
              : AppColors.divider,
          width: reco || outline ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      ),
      child: Column(
        children: [
          if (reco)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.primaryStrong,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                '추천',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          if (reco) SizedBox(height: 8.h),
          Text(name,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800)),
          if (off != null) ...[
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                off!,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryStrong,
                ),
              ),
            ),
          ],
          SizedBox(height: 12.h),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: price,
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (unit != null)
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (was != null)
            Text(
              was!,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textDisabled,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          if (note != null)
            Text(note!,
                style: TextStyle(
                    fontSize: 10.5.sp, color: AppColors.textSecondary)),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            height: 40.h,
            child: filled
                ? GestureDetector(
                    onTap: () => context.push(Routes.subscription),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Center(
                        child: Text(
                          '선택하기',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : OutlinedButton(
                    onPressed: () => context.push(Routes.subscription),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: outline
                            ? AppColors.primary
                            : AppColors.border,
                        width: outline ? 1.5 : 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                    child: Text(
                      '선택하기',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: outline
                            ? AppColors.primaryStrong
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
          ),
          if (foot != null) ...[
            SizedBox(height: 8.h),
            Text(
              foot!,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.primaryStrong,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CompareTable extends StatelessWidget {
  const _CompareTable();

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            const SizedBox(),
            _th('무료'),
            _th('프리미엄', pink: true),
          ],
        ),
        _cmpRow('🤖', 'AI 맞춤 케어', '개인 맞춤 건강 관리 및 케어 제안',
            '기본 케어', '고급 케어', true),
        _cmpRow(null, '캘린더 일정 등록', '복약, 검진, 병원 일정 등록',
            '최대 10개', '무제한', false, Icons.calendar_month_rounded),
        _cmpRow(null, '건강 리포트', '복약/건강 데이터 분석 리포트',
            '기본 리포트', '상세 리포트', false, Icons.monitor_heart_rounded),
      ],
    );
  }

  Widget _th(String text, {bool pink = false}) => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: pink ? AppColors.primaryStrong : AppColors.textPrimary,
          ),
        ),
      );

  TableRow _cmpRow(
    String? emoji,
    String title,
    String sub,
    String free,
    String prem,
    bool emojiIcon, [
    IconData? icon,
  ]) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: emoji != null
                    ? Text(emoji, style: TextStyle(fontSize: 17.sp))
                    : Icon(icon, size: 17.sp, color: AppColors.primaryStrong),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.w700)),
                    Text(sub,
                        style: TextStyle(
                            fontSize: 10.5.sp,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Text(
            free,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded,
                  size: 16.sp, color: AppColors.primaryStrong),
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  prem,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryStrong,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FaqBtn extends StatelessWidget {
  const _FaqBtn(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
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
          Text('Q.',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryStrong,
              )),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
          ),
          Icon(Icons.expand_more_rounded,
              color: AppColors.textDisabled, size: 22.sp),
        ],
      ),
    );
  }
}
