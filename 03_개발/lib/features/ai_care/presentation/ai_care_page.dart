import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_frame.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_tabs.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/connected_notification_bell.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../auth/application/auth_providers.dart';
import '../domain/ai_briefing.dart';
import '../application/ai_care_providers.dart';

/// AI 케어 — 퍼블리싱 09_ai_care.html
class AiCarePage extends ConsumerStatefulWidget {
  const AiCarePage({super.key});

  @override
  ConsumerState<AiCarePage> createState() => _AiCarePageState();
}

class _AiCarePageState extends ConsumerState<AiCarePage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final nickname =
        ref.watch(currentUserProfileProvider).value?.nickname ?? '엄마';
    final briefing = ref.watch(latestAiBriefingProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: 'AI 케어',
        leading: SizedBox(width: 40.w),
        actions: const [
          ConnectedNotificationBell(),
        ],
      ),
      body: Column(
        children: [
          AppTabs(
            labels: const ['AI 케어', 'AI 케어 히스토리'],
            index: _tab,
            onChanged: (i) => setState(() => _tab = i),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: AppSizes.contentPaddingBottom),
              children: _tab == 0 ? _carePanel(context, nickname, briefing) : _historyPanel(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _carePanel(
      BuildContext context, String nickname, AiBriefing? briefing) {
    return [
      AppContent(
        bottom: false,
        child: AppCard(
          padding: EdgeInsets.all(20.w),
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF3F6), Color(0xFFFCE3EB)],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusCard),
            ),
            padding: EdgeInsets.all(20.w),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: 220.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '안녕하세요, $nickname님 ❤️',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        '오늘 컨디션은 어떤가요?\nAI가 맞춤 케어를 도와드릴게요.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      GestureDetector(
                        onTap: () => context.push(Routes.aiChat),
                        child: Container(
                          height: 48.h,
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(999.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x4DF2547F),
                                blurRadius: 16.r,
                                offset: Offset(0, 6.h),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '✨ 오늘 컨디션 체크하기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Text('🤖', style: TextStyle(fontSize: 88.sp)),
                ),
              ],
            ),
          ),
        ),
      ),
      SizedBox(height: 24.h),
      AppContent(
        bottom: false,
        child: SectionHeader(title: '맞춤 케어 추천', moreLabel: '더보기'),
      ),
      SizedBox(height: 12.h),
      AppContent(
        bottom: false,
        child: AppCard(
          child: Row(
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: AppColors.aiPurpleLight,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(Icons.favorite_rounded,
                    color: const Color(0xFF7C5CD6), size: 30.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '입덧 완화를 위한 케어',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        StatusChip(
                          label: '추천',
                          color: AppColors.aiPurple,
                          backgroundColor: AppColors.aiPurpleLight,
                          height: 22.h,
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '입덧 완화에 도움이 되는 식사 팁과 생활 습관을 알려드릴게요.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40.h,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.aiPurple),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '확인하기',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.aiPurple,
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        size: 16.sp, color: AppColors.aiPurple),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 24.h),
      AppContent(
        bottom: false,
        child: SectionHeader(title: 'AI 케어 분석 리포트', moreLabel: '더보기'),
      ),
      SizedBox(height: 12.h),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: const Row(
          children: [
            _ReportCard(
              icon: Icons.favorite_rounded,
              iconColor: AppColors.primaryStrong,
              label: '종합 컨디션',
              state: '좋음 🙂',
              tone: _ReportTone.good,
              desc: '전반적으로 안정적인 상태예요.',
            ),
            SizedBox(width: 10),
            _ReportCard(
              icon: Icons.bedtime_rounded,
              iconColor: Color(0xFF3B82F6),
              label: '수면 분석',
              state: '보통 😐',
              tone: _ReportTone.soso,
              desc: '수면 시간이 조금 부족해요.',
            ),
            SizedBox(width: 10),
            _ReportCard(
              icon: Icons.restaurant_rounded,
              iconColor: AppColors.warning,
              label: '영양 상태',
              state: '주의 ⚠️',
              tone: _ReportTone.warn,
              desc: '철분과 엽산 섭취를 신경써주세요.',
            ),
          ],
        ),
      ),
      SizedBox(height: 24.h),
      AppContent(
        bottom: false,
        child: SectionHeader(title: 'AI 케어 팁'),
      ),
      SizedBox(height: 12.h),
      SizedBox(
        height: 210.h,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          children: const [
            _TipCard(
              emoji: '🍲',
              title: '입덧 완화 식단',
              desc: '소화가 잘 되는 식단으로 입덧을 완화해보세요.',
            ),
            SizedBox(width: 12),
            _TipCard(
              emoji: '🥛',
              title: '수분 섭취 팁',
              desc: '하루 1.5~2L의 물을 꾸준히 마셔주세요.',
            ),
            SizedBox(width: 12),
            _TipCard(
              emoji: '🧘🏻‍♀️',
              title: '임산부 스트레칭',
              desc: '가벼운 스트레칭으로 몸의 긴장을 풀어보세요.',
            ),
            SizedBox(width: 12),
            _TipCard(
              emoji: '🥗',
              title: '마음 챙김 루틴',
              desc: '하루 10분, 나를 위한 시간을 가져보세요.',
            ),
          ],
        ),
      ),
      SizedBox(height: 24.h),
      AppContent(
        bottom: false,
        child: SectionHeader(title: '오늘의 한마디'),
      ),
      SizedBox(height: 12.h),
      AppContent(
        bottom: false,
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFBE4EC),
            borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: 260.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '“',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryStrong,
                        height: 1,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '작은 습관이 건강한 임신을 만들어요.\n오늘도 당신을 응원합니다! 💕',
                      style: TextStyle(fontSize: 14.sp, height: 1.7),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Text('🤖', style: TextStyle(fontSize: 64.sp)),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _historyPanel() {
    return [
      AppContent(
        bottom: false,
        child: AppCard(
          padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 8.w),
          child: Row(
            children: [
              _HistSummaryItem(num: '28', label: '이번 달 케어'),
              _HistSummaryItem(num: '12', label: 'AI 상담', showBorder: true),
              _HistSummaryItem(num: '16', label: '하루 브리핑', showBorder: true),
            ],
          ),
        ),
      ),
      AppContent(
        bottom: false,
        child: _HistGroup(
          date: '오늘 · 06.02 (일)',
          items: const [
            _HistItem(
              icon: Icons.wb_sunny_rounded,
              iconBg: Color(0xFFF4F0FE),
              iconColor: Color(0xFF7C5CD6),
              type: 'AI 하루 브리핑',
              typeColor: Color(0xFF7C5CD6),
              title: '오늘의 건강 브리핑',
              summary: '복약 100% 완료 · 수면 양호 · 수분 섭취가 조금 부족해요.',
              time: '08:00',
            ),
            _HistItem(
              icon: Icons.forum_rounded,
              iconBg: AppColors.primaryLight,
              iconColor: AppColors.primaryStrong,
              type: 'AI 상담',
              typeColor: AppColors.primaryStrong,
              title: '임신 중 감기약 복용 문의',
              summary: '증상별로 안전하게 사용할 수 있는 약을 안내받았어요.',
              time: '10:30',
            ),
          ],
        ),
      ),
      AppContent(
        bottom: false,
        child: _HistGroup(
          date: '어제 · 06.01 (토)',
          items: const [
            _HistItem(
              icon: Icons.favorite_rounded,
              iconBg: Color(0xFFE8F5EC),
              iconColor: Color(0xFF22A050),
              type: '컨디션 체크',
              typeColor: Color(0xFF22A050),
              title: '오늘 컨디션: 좋음',
              summary: '전반적으로 안정적이에요. 가벼운 산책을 추천받았어요.',
              time: '09:15',
            ),
            _HistItem(
              icon: Icons.wb_sunny_rounded,
              iconBg: Color(0xFFF4F0FE),
              iconColor: Color(0xFF7C5CD6),
              type: 'AI 하루 브리핑',
              typeColor: Color(0xFF7C5CD6),
              title: '오늘의 건강 브리핑',
              summary: '수면 시간이 어제보다 30분 늘었어요. 좋은 변화예요!',
              time: '08:00',
            ),
          ],
        ),
      ),
      AppContent(
        bottom: false,
        child: _HistGroup(
          date: '05.31 (금)',
          items: const [
            _HistItem(
              icon: Icons.forum_rounded,
              iconBg: AppColors.primaryLight,
              iconColor: AppColors.primaryStrong,
              type: 'AI 상담',
              typeColor: AppColors.primaryStrong,
              title: '철분제 복용 후 속쓰림 문의',
              summary: '식후 복용과 수분 섭취로 완화하는 방법을 안내받았어요.',
              time: '21:40',
            ),
          ],
        ),
      ),
    ];
  }
}

enum _ReportTone { good, soso, warn }

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.state,
    required this.tone,
    required this.desc,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String state;
  final _ReportTone tone;
  final String desc;

  Color get _color => switch (tone) {
        _ReportTone.good => AppColors.primaryStrong,
        _ReportTone.soso => AppColors.aiPurple,
        _ReportTone.warn => AppColors.warning,
      };

  double get _barWidth => switch (tone) {
        _ReportTone.good => 0.72,
        _ReportTone.soso => 0.50,
        _ReportTone.warn => 0.40,
      };

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 16.sp),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              state,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: _color,
              ),
            ),
            SizedBox(height: 12.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(999.r),
              child: LinearProgressIndicator(
                value: _barWidth,
                minHeight: 6.h,
                backgroundColor: const Color(0xFFEFEFEF),
                color: _color,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              desc,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({
    required this.emoji,
    required this.title,
    required this.desc,
  });

  final String emoji;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168.w,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        boxShadow: [
          BoxShadow(
            color: const Color(0x14F47C9C),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 96.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFDF0F4),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Text(emoji, style: TextStyle(fontSize: 44.sp)),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 6.h),
          Text(
            desc,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Text(
                '자세히 보기',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryStrong,
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  size: 14.sp, color: AppColors.primaryStrong),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistSummaryItem extends StatelessWidget {
  const _HistSummaryItem({
    required this.num,
    required this.label,
    this.showBorder = false,
  });

  final String num;
  final String label;
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
        child: Column(
          children: [
            Text(
              num,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF7C5CD6),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistGroup extends StatelessWidget {
  const _HistGroup({required this.date, required this.items});

  final String date;
  final List<_HistItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 22.h),
        Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Text(
            date,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        ...items,
      ],
    );
  }
}

class _HistItem extends StatelessWidget {
  const _HistItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.type,
    required this.typeColor,
    required this.title,
    required this.summary,
    required this.time,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String type;
  final Color typeColor;
  final String title;
  final String summary;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.all(14.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: typeColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  summary,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }
}
