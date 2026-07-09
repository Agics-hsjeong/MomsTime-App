import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/layout/app_frame.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/connected_notification_bell.dart';
import '../../../shared/widgets/section_header.dart';
import '../../auth/application/auth_providers.dart';

/// 복약 리포트 — 퍼블리싱 13_report.html
class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  int _range = 1;
  static const _ranges = ['주', '월', '3개월', '6개월'];

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final name = (profile?.nickname.isNotEmpty ?? false)
        ? profile!.nickname
        : '엄마';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: '복약 리포트',
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
                        '나의 복약 습관과 건강 관리를 한눈에 확인해 보세요.',
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
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    minimumSize: Size(0, 44.h),
                  ),
                  icon: Icon(Icons.calendar_month_rounded,
                      size: 18.sp, color: AppColors.primaryStrong),
                  label: Row(
                    children: [
                      Text(
                        '2024년 6월',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryStrong,
                        ),
                      ),
                      Icon(Icons.expand_more_rounded,
                          size: 16.sp, color: AppColors.primaryStrong),
                    ],
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
                  color: const Color(0xFFFDEFF3),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 128.w,
                        height: 128.w,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: Size(128.w, 128.w),
                              painter: _DonutPainter(percent: 0.92),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryStrong,
                                ),
                                children: [
                                  const TextSpan(text: '92'),
                                  TextSpan(
                                    text: '%',
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '이번 달 복약률',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text('🤖', style: TextStyle(fontSize: 52.sp)),
                            Text(
                              '복약 잘 지키고 있어요!',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 11,
                        child: Container(
                          padding: EdgeInsets.only(left: 14.w),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFFF0CDDA),
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              _RateStat(
                                icon: Icons.check_circle_rounded,
                                iconColor: Color(0xFF22A050),
                                label: '복용 완료',
                                value: '55회',
                              ),
                              Divider(height: 1, color: Color(0xFFF7DEE8)),
                              _RateStat(
                                icon: Icons.schedule_rounded,
                                iconColor: Color(0xFF7C5CD6),
                                label: '복용 예정',
                                value: '5회',
                              ),
                              Divider(height: 1, color: Color(0xFFF7DEE8)),
                              _RateStat(
                                emoji: '❌',
                                label: '복용 놓침',
                                value: '3회',
                              ),
                              Divider(height: 1, color: Color(0xFFF7DEE8)),
                              _RateStat(
                                icon: Icons.calendar_month_rounded,
                                iconColor: AppColors.primaryStrong,
                                label: '총 복약 횟수',
                                value: '60회',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '복약률 추이',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Row(
                        children: [
                          for (var i = 0; i < _ranges.length; i++)
                            GestureDetector(
                              onTap: () => setState(() => _range = i),
                              child: Container(
                                height: 32.h,
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                decoration: BoxDecoration(
                                  color: _range == i
                                      ? AppColors.primaryLight
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(999.r),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _ranges[i],
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: _range == i
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    color: _range == i
                                        ? AppColors.primaryStrong
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                AppCard(
                  child: SizedBox(
                    height: 190.h,
                    child: CustomPaint(
                      painter: _TrendChartPainter(),
                      size: Size(double.infinity, 190.h),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                SectionHeader(title: '약물별 복약 현황', moreLabel: '전체 약 보기'),
                SizedBox(height: 12.h),
                AppCard(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                  child: Column(
                    children: const [
                      _DrugRow(
                        bg: Color(0xFFFDEFF3),
                        name: '엽산 400mcg',
                        sub: '1정 · 하루 1회 (아침)',
                        pct: 100,
                        color: Color(0xFFF2547F),
                        count: '30/30회',
                      ),
                      _DrugRow(
                        bg: Color(0xFFFDF3E4),
                        name: '철분제',
                        sub: '1정 · 하루 1회 (저녁)',
                        pct: 93,
                        color: Color(0xFFF59E0B),
                        count: '28/30회',
                      ),
                      _DrugRow(
                        bg: AppColors.aiPurpleLight,
                        name: '비타민 D',
                        sub: '1정 · 하루 1회 (식후)',
                        pct: 90,
                        color: Color(0xFFA78BFA),
                        count: '27/30회',
                      ),
                      _DrugRow(
                        bg: Color(0xFFE9EFFC),
                        name: '칼슘제',
                        sub: '1정 · 하루 1회 (취침 전)',
                        pct: 83,
                        color: Color(0xFF3B82F6),
                        count: '25/30회',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                AppCard(
                  color: const Color(0xFFFDEFF3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: 'AI 분석 인사이트',
                        moreLabel: '상세 분석 보기',
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('🤖', style: TextStyle(fontSize: 48.sp)),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '전반적으로 좋은 복약 습관을 유지하고 있어요! 💪',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  '복약률이 지난 달보다 5% 향상되었어요.\n놓친 복약 시간은 주로 저녁 시간대입니다.',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_rounded,
                                color: AppColors.warning, size: 18.sp),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                '알림 시간을 저녁 1시간 앞당기면 복약률을 더 높일 수 있어요!',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryStrong,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                SectionHeader(title: '복약 놓침 기록', moreLabel: '전체 보기'),
                SizedBox(height: 12.h),
                AppCard(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                  child: Column(
                    children: const [
                      _MissedRow(
                        date: '6.15 (토) 20:00',
                        name: '철분제',
                        tag: '저녁',
                        tagBg: Color(0xFFFDEFF3),
                        tagColor: AppColors.primaryStrong,
                        reason: '약 깜빡함',
                      ),
                      _MissedRow(
                        date: '6.11 (화) 21:30',
                        name: '비타민 D',
                        tag: '식후',
                        tagBg: AppColors.aiPurpleLight,
                        tagColor: Color(0xFF7C5CD6),
                        reason: '외출 중',
                      ),
                      _MissedRow(
                        date: '6.05 (수) 20:10',
                        name: '칼슘제',
                        tag: '취침 전',
                        tagBg: Color(0xFFE9EFFC),
                        tagColor: Color(0xFF3B82F6),
                        reason: '약 깜빡함',
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

class _RateStat extends StatelessWidget {
  const _RateStat({
    this.icon,
    this.iconColor,
    this.emoji,
    required this.label,
    required this.value,
  });

  final IconData? icon;
  final Color? iconColor;
  final String? emoji;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          if (emoji != null)
            Text(emoji!, style: TextStyle(fontSize: 16.sp))
          else
            Icon(icon, size: 16.sp, color: iconColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 13.sp, color: AppColors.textSecondary)),
          ),
          Text(value,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _DrugRow extends StatelessWidget {
  const _DrugRow({
    required this.bg,
    required this.name,
    required this.sub,
    required this.pct,
    required this.color,
    required this.count,
  });

  final Color bg;
  final String name;
  final String sub;
  final int pct;
  final Color color;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(Icons.medication_rounded,
                color: AppColors.primaryStrong, size: 21.sp),
          ),
          SizedBox(width: 12.w),
          SizedBox(
            width: 112.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.w700)),
                Text(sub,
                    style: TextStyle(
                        fontSize: 11.sp, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999.r),
              child: LinearProgressIndicator(
                value: pct / 100,
                minHeight: 6.h,
                backgroundColor: const Color(0xFFEFEFEF),
                color: color,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 46.w,
            child: Text(
              '$pct%',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
          SizedBox(
            width: 56.w,
            child: Text(
              count,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _MissedRow extends StatelessWidget {
  const _MissedRow({
    required this.date,
    required this.name,
    required this.tag,
    required this.tagBg,
    required this.tagColor,
    required this.reason,
  });

  final String date;
  final String name;
  final String tag;
  final Color tagBg;
  final Color tagColor;
  final String reason;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: [
          SizedBox(
            width: 108.w,
            child: Text(date,
                style: TextStyle(
                    fontSize: 13.sp, color: AppColors.textSecondary)),
          ),
          Text(name,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
          SizedBox(width: 6.w),
          Container(
            height: 22.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: tagBg,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              tag,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: tagColor,
              ),
            ),
          ),
          const Spacer(),
          Container(
            height: 26.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F5),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              reason,
              style: TextStyle(
                  fontSize: 11.sp, color: AppColors.textSecondary),
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: AppColors.textDisabled, size: 18.sp),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.percent});
  final double percent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 7;
    final bg = Paint()
      ..color = const Color(0xFFFBD5E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final fg = Paint()
      ..color = const Color(0xFFF2547F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bg);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * percent,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.percent != percent;
}

class _TrendChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = const Color(0xFFF3E3E8);
    for (var i = 0; i < 5; i++) {
      final y = size.height * (0.1 + i * 0.22);
      canvas.drawLine(Offset(36, y), Offset(size.width - 10, y), grid);
    }
    final points = [
      Offset(size.width * 0.15, size.height * 0.21),
      Offset(size.width * 0.3, size.height * 0.18),
      Offset(size.width * 0.45, size.height * 0.19),
      Offset(size.width * 0.6, size.height * 0.17),
      Offset(size.width * 0.75, size.height * 0.2),
      Offset(size.width * 0.92, size.height * 0.16),
    ];
    final fill = Path()
      ..moveTo(points.first.dx, points.first.dy)
      ..addPolygon(points, false)
      ..lineTo(points.last.dx, size.height * 0.84)
      ..lineTo(points.first.dx, size.height * 0.84)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFF2547F).withValues(alpha: 0.25),
            const Color(0xFFF2547F).withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    final line = Paint()
      ..color = const Color(0xFFF2547F)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, line);
    for (final p in points) {
      canvas.drawCircle(p, 3.5, Paint()..color = const Color(0xFFF2547F));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
