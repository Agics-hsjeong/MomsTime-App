import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_frame.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/section_header.dart';

const _purple = Color(0xFF6D4FD0);

/// 통계 상세 — 퍼블리싱 28_statistics_detail.html
class StatisticsDetailPage extends StatefulWidget {
  const StatisticsDetailPage({super.key});

  @override
  State<StatisticsDetailPage> createState() => _StatisticsDetailPageState();
}

class _StatisticsDetailPageState extends State<StatisticsDetailPage> {
  int _tab = 0;
  static const _tabs = ['종합', '복약', '검진', '활동', '영양', '수면'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: '통계 상세',
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit_calendar_rounded, size: 26.sp),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 32.h),
        children: [
          _PurpleTabs(
            labels: _tabs,
            index: _tab,
            onChanged: (i) => setState(() => _tab = i),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.chevron_left_rounded,
                      color: AppColors.textSecondary, size: 20.sp),
                ),
                Row(
                  children: [
                    Icon(Icons.calendar_month_rounded,
                        size: 20.sp, color: AppColors.primaryStrong),
                    SizedBox(width: 8.w),
                    Text(
                      '2024.05.13 ~ 2024.05.19 (최근 7일)',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.chevron_right_rounded,
                      color: AppColors.textSecondary, size: 20.sp),
                ),
              ],
            ),
          ),
          AppContent(
            child: _tab == 0
                ? const _SummaryPanel()
                : _SimpleTabPanel(title: _tabs[_tab]),
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
    return SizedBox(
      height: 48.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        children: [
          for (var i = 0; i < labels.length; i++)
            GestureDetector(
              onTap: () => onChanged(i),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: i == index ? _purple : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
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
        ],
      ),
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '이번 주 종합 건강 점수',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Icon(Icons.help_outline_rounded,
                            size: 15.sp, color: AppColors.textDisabled),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w800,
                          color: _purple,
                        ),
                        children: [
                          const TextSpan(text: '82점 '),
                          TextSpan(
                            text: '/ 100점',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          const TextSpan(text: '지난주보다 '),
                          TextSpan(
                            text: '8점 상승',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _purple,
                            ),
                          ),
                          const TextSpan(text: '했어요! 🎉'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 148.w,
                height: 148.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: Size(148.w, 148.w),
                      painter: _ScoreRingPainter(percent: 0.82),
                    ),
                    Text('😸', style: TextStyle(fontSize: 52.sp)),
                    Positioned(
                      top: 2.h,
                      right: -8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: _purple,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          'GOOD',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
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
        SectionHeader(title: '카테고리별 점수'),
        SizedBox(height: 12.h),
        SizedBox(
          height: 130.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _CatCard(
                icon: Icons.medication_rounded,
                bg: Color(0xFFEFE9FC),
                label: '복약',
                value: '90',
                diff: '↑ 10',
                up: true,
              ),
              _CatCard(
                icon: Icons.assignment_rounded,
                bg: Color(0xFFE7F0FB),
                iconColor: Color(0xFF7C5CD6),
                label: '검진',
                value: '75',
                diff: '↑ 5',
                up: true,
              ),
              _CatCard(
                icon: Icons.directions_run_rounded,
                bg: Color(0xFFE8F5EC),
                iconColor: Color(0xFF22A050),
                label: '활동',
                value: '80',
                diff: '↑ 8',
                up: true,
              ),
              _CatCard(
                icon: Icons.restaurant_rounded,
                bg: Color(0xFFFDF3E4),
                iconColor: AppColors.warning,
                label: '영양',
                value: '70',
                diff: '↓ 5',
                up: false,
              ),
              _CatCard(
                icon: Icons.bedtime_rounded,
                bg: Color(0xFFEFE9FC),
                iconColor: Color(0xFF3B82F6),
                label: '수면',
                value: '85',
                diff: '↑ 12',
                up: true,
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '주간 종합 점수 변화',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Container(
                    height: 38.h,
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '최근 7일',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Icon(Icons.expand_more_rounded, size: 16.sp),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 190.h,
                child: CustomPaint(
                  size: Size(double.infinity, 190.h),
                  painter: _WeeklyChartPainter(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SectionHeader(title: '주요 지표 요약'),
        SizedBox(height: 12.h),
        AppCard(
          padding: EdgeInsets.zero,
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              _MetricItem(
                icon: Icons.medication_rounded,
                bg: Color(0xFFEFE9FC),
                label: '복약 실천율',
                value: '92',
                unit: '%',
                diff: '↑ 5%',
                up: true,
              ),
              _MetricItem(
                icon: Icons.water_drop_rounded,
                bg: Color(0xFFE7F0FB),
                iconColor: Color(0xFF3B82F6),
                label: '수분 섭취',
                value: '1,300',
                unit: 'ml',
                diff: '↓ 200ml',
                up: false,
              ),
              _MetricItem(
                icon: Icons.bedtime_rounded,
                bg: Color(0xFFEFE9FC),
                iconColor: Color(0xFF3B82F6),
                label: '평균 수면',
                value: '7시간 30분',
                diff: '↑ 30분',
                up: true,
              ),
              _MetricItem(
                icon: Icons.directions_walk_rounded,
                bg: Color(0xFFE4F5F2),
                iconColor: Color(0xFF14B8A6),
                label: '걸음 수',
                value: '6,253',
                unit: '걸음',
                diff: '↑ 420',
                up: true,
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F0FE),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Text('📊', style: TextStyle(fontSize: 36.sp)),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '건강 리포트가 준비됐어요',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '이번 주 건강 데이터를 분석한 리포트를 확인해 보세요.',
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () => context.push(Routes.report),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _purple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  minimumSize: Size(0, 44.h),
                ),
                child: Text(
                  '리포트 보기',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: _purple,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          '* 통계는 참고용이며, 의학적 진단을 대체하지 않습니다.',
          style: TextStyle(fontSize: 12.sp, color: AppColors.textDisabled),
        ),
      ],
    );
  }
}

class _SimpleTabPanel extends StatelessWidget {
  const _SimpleTabPanel({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Text(
            '$title 상세 통계',
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 160.h,
            child: CustomPaint(
              size: Size(double.infinity, 160.h),
              painter: _WeeklyChartPainter(),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '최근 7일 $title 데이터를 요약했어요.',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CatCard extends StatelessWidget {
  const _CatCard({
    required this.icon,
    required this.bg,
    this.iconColor,
    required this.label,
    required this.value,
    required this.diff,
    required this.up,
  });

  final IconData icon;
  final Color bg;
  final Color? iconColor;
  final String label;
  final String value;
  final String diff;
  final bool up;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88.w,
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon,
                color: iconColor ?? AppColors.primaryStrong, size: 22.sp),
          ),
          SizedBox(height: 10.h),
          Text(label,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              children: [
                TextSpan(text: value),
                TextSpan(
                  text: '점',
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Text(
            diff,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: up ? AppColors.error : const Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.icon,
    required this.bg,
    this.iconColor,
    required this.label,
    required this.value,
    this.unit,
    required this.diff,
    required this.up,
  });

  final IconData icon;
  final Color bg;
  final Color? iconColor;
  final String label;
  final String value;
  final String? unit;
  final String diff;
  final bool up;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider),
          right: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon,
                color: iconColor ?? AppColors.primaryStrong, size: 21.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 12.5.sp,
                        color: AppColors.textSecondary)),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                    children: [
                      TextSpan(text: value),
                      if (unit != null)
                        TextSpan(
                          text: ' $unit',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            diff,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: up ? AppColors.error : const Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  _ScoreRingPainter({required this.percent});
  final double percent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 14;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFFEBE5F8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * percent,
      false,
      Paint()
        ..color = const Color(0xFF7C5CD6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) =>
      oldDelegate.percent != percent;
}

class _WeeklyChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = const Color(0xFFEFEBF8);
    for (var i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(32, size.height * (0.1 + i * 0.22)),
        Offset(size.width - 10, size.height * (0.1 + i * 0.22)),
        grid,
      );
    }
    final points = [
      Offset(size.width * 0.15, size.height * 0.55),
      Offset(size.width * 0.3, size.height * 0.45),
      Offset(size.width * 0.45, size.height * 0.5),
      Offset(size.width * 0.6, size.height * 0.38),
      Offset(size.width * 0.75, size.height * 0.42),
      Offset(size.width * 0.9, size.height * 0.35),
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
            const Color(0xFF7C5CD6).withValues(alpha: 0.22),
            const Color(0xFF7C5CD6).withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    final line = Paint()
      ..color = const Color(0xFF7C5CD6)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
