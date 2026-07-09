import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_frame.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/status_chip.dart';

const _purple = Color(0xFF7C5CD6);

/// 검진 상세 — 퍼블리싱 22_checkup_detail.html
class CheckupDetailPage extends StatefulWidget {
  const CheckupDetailPage({super.key});

  @override
  State<CheckupDetailPage> createState() => _CheckupDetailPageState();
}

class _CheckupDetailPageState extends State<CheckupDetailPage> {
  int _tab = 0;
  static const _tabs = ['검진 요약', '검사 결과', '추이 비교', '검진 정보'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: '검진 상세',
        actions: [
          IconButton(
            onPressed: () => context.go(Routes.home),
            icon: Icon(Icons.home_rounded, size: 26.sp),
          ),
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
                Container(
                  width: 68.w,
                  height: 68.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFE9FC),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.medical_services_rounded,
                      color: _purple, size: 30.sp),
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
                              '2024년 건강검진',
                              style: TextStyle(
                                fontSize: 19.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          StatusChip(
                            label: '정기검진',
                            height: 24.h,
                            backgroundColor: const Color(0xFFEFE9FC),
                            color: _purple,
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '검진일  2024.06.02 (일)  |  검진기관  삼성서울병원',
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _purple),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    minimumSize: Size(0, 46.h),
                  ),
                  icon: Icon(Icons.download_rounded, size: 17.sp, color: _purple),
                  label: Text(
                    '결과지\n다운로드',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: _purple,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _PurpleTabs(
            labels: _tabs,
            index: _tab,
            onChanged: (i) => setState(() => _tab = i),
          ),
          SizedBox(height: 16.h),
          AppContent(
            child: switch (_tab) {
              0 => const _SummaryPanel(),
              1 => const _ResultsPanel(),
              2 => const _TrendPanel(),
              _ => const _InfoPanel(),
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
                      fontSize: 14.sp,
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

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('검진 요약 ⓘ',
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.w800)),
                      Text('주요 검사 항목의 결과를 요약했어요.',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _purple),
                      minimumSize: Size(0, 40.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                    ),
                    icon: Icon(Icons.ios_share_rounded, size: 15.sp, color: _purple),
                    label: Text('요약 공유',
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: _purple)),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Row(
                children: const [
                  _SumItem(
                    icon: Icons.assignment_rounded,
                    bg: Color(0xFFEFE9FC),
                    iconColor: _purple,
                    label: '종합 소견',
                    value: '정상',
                    valueColor: _purple,
                    valueSize: 17,
                    sub: '이상 소견 없음',
                  ),
                  _SumItem(
                    emoji: '💚',
                    bg: Color(0xFFE8F5EC),
                    label: '정상 범위',
                    value: '24',
                    valueColor: Color(0xFF22A050),
                    sub: '/ 28 항목',
                    showBorder: true,
                  ),
                  _SumItem(
                    icon: Icons.priority_high_rounded,
                    bg: Color(0xFFFDF0DC),
                    iconColor: AppColors.warning,
                    label: '주의 범위',
                    value: '2',
                    valueColor: AppColors.warning,
                    sub: '/ 28 항목',
                    showBorder: true,
                  ),
                  _SumItem(
                    icon: Icons.block_rounded,
                    bg: Color(0xFFFDE8E8),
                    iconColor: AppColors.error,
                    label: '이상 범위',
                    value: '0',
                    valueColor: AppColors.error,
                    sub: '/ 28 항목',
                    showBorder: true,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F0FE),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  children: [
                    Text('🤖', style: TextStyle(fontSize: 26.sp)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI가 분석한 결과, 전반적으로 건강 상태가 양호해요!',
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF6D4FD0),
                            ),
                          ),
                          Text(
                            '주의 항목을 확인하고 생활 습관을 관리해보세요.',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: _purple, size: 22.sp),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        SectionHeader(title: '주요 주의 항목 ⓘ', moreLabel: '전체 결과 보기'),
        SizedBox(height: 12.h),
        AppCard(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
          child: Column(
            children: const [
              _WarnRow(
                icon: Icons.science_rounded,
                name: 'LDL 콜레스테롤',
                range: '기준치: 70 ~ 129 mg/dL',
                value: '134',
                unit: 'mg/dL',
              ),
              _WarnRow(
                icon: Icons.monitor_weight_rounded,
                name: '체질량지수 (BMI)',
                range: '기준치: 18.5 ~ 22.9 kg/m²',
                value: '23.7',
                unit: 'kg/m²',
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(Icons.info_outline_rounded,
                size: 15.sp, color: AppColors.textSecondary),
            SizedBox(width: 6.w),
            Text(
              '이상 및 주의 항목은 반드시 전문가와 상담하세요.',
              style: TextStyle(
                  fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        SectionHeader(title: '주요 정상 항목'),
        SizedBox(height: 12.h),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 8.w,
          childAspectRatio: 0.72,
          children: const [
            _NormCard(
              icon: Icons.water_drop_rounded,
              iconColor: Color(0xFF3B82F6),
              label: '공복혈당',
              value: '93',
              unit: 'mg/dL',
              range: '정상 (70~99)',
            ),
            _NormCard(
              emoji: '💚',
              label: '혈압',
              value: '118/72',
              unit: 'mmHg',
              range: '정상',
            ),
            _NormCard(
              icon: Icons.monitor_heart_rounded,
              label: '간기능 (AST)',
              value: '22',
              unit: 'U/L',
              range: '정상 (0~40)',
            ),
            _NormCard(
              icon: Icons.water_drop_rounded,
              iconColor: Color(0xFF3B82F6),
              label: '신장기능 (CRE)',
              value: '0.9',
              unit: 'mg/dL',
              range: '정상 (0.6~1.2)',
            ),
          ],
        ),
        SizedBox(height: 14.h),
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
        SectionHeader(title: '의사 소견'),
        SizedBox(height: 12.h),
        AppCard(
          color: const Color(0xFFF4F0FE),
          child: Row(
            children: [
              Text('🧑‍⚕️', style: TextStyle(fontSize: 30.sp)),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('홍길동 전문의',
                            style: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.w800)),
                        SizedBox(width: 8.w),
                        StatusChip(
                          label: '가정의학과',
                          height: 22.h,
                          backgroundColor: const Color(0xFFE5DDF8),
                          color: const Color(0xFF6D4FD0),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '전반적으로 검사 결과가 양호합니다.\nLDL 콜레스테롤과 BMI가 약간 높게 나왔으니,\n식습관과 운동을 통해 관리해보세요.',
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        color: AppColors.textSecondary,
                        height: 1.65,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _purple),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  minimumSize: Size(0, 42.h),
                ),
                child: Text('상세 소견 보기',
                    style: TextStyle(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                        color: _purple)),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        SectionHeader(title: '맞춤 건강 팁', moreLabel: '더 보기'),
        SizedBox(height: 12.h),
        Row(
          children: const [
            _TipCard(
              emoji: '🥗',
              name: '식단 관리',
              desc: '포화지방과 탄수화물 섭취를 줄이고 채소, 과일을 늘려보세요.',
            ),
            _TipCard(
              emoji: '🏃‍♀️',
              name: '유산소 운동',
              desc: '주 3~5회, 30분 이상 유산소 운동을 추천해요.',
            ),
            _TipCard(
              icon: Icons.monitor_weight_rounded,
              name: '체중 관리',
              desc: '적정 체중을 유지하면 건강에 도움이 돼요.',
            ),
          ],
        ),
        SizedBox(height: 20.h),
        _Disclaimer(),
      ],
    );
  }
}

class _ResultsPanel extends StatelessWidget {
  const _ResultsPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
          child: Column(
            children: const [
              _ResRow('혈압', '수축기/이완기', '110/70', 'mmHg', '정상', true),
              _ResRow('공복 혈당', 'Glucose', '92', 'mg/dL', '주의', false),
              _ResRow('총 콜레스테롤', 'Total', '205', 'mg/dL', '주의', false),
              _ResRow('HDL 콜레스테롤', '좋은', '58', 'mg/dL', '정상', true),
              _ResRow('LDL 콜레스테롤', '나쁜', '134', 'mg/dL', '주의', false),
              _ResRow('AST / ALT', '간 기능', '22 / 24', 'U/L', '정상', true),
              _ResRow('크레아티닌', '신장 기능', '0.9', 'mg/dL', '정상', true),
              _ResRow('혈색소', 'Hb', '12.5', 'g/dL', '정상', true),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(Icons.info_outline_rounded,
                size: 15.sp, color: AppColors.textSecondary),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                '총 28개 항목 중 주요 8개 항목이에요. 전체는 결과지에서 확인하세요.',
                style: TextStyle(
                    fontSize: 12.sp, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        const _Disclaimer(),
      ],
    );
  }
}

class _TrendPanel extends StatelessWidget {
  const _TrendPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('주요 지표 추이',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w800)),
                  StatusChip(
                    label: '최근 3회',
                    height: 28.h,
                    backgroundColor: const Color(0xFFEFE9FC),
                    color: _purple,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 12.w,
                children: [
                  _LegendDot(color: Color(0xFFF2547F), label: '총 콜레스테롤'),
                  _LegendDot(color: Color(0xFFF59E0B), label: '공복 혈당'),
                  _LegendDot(color: _purple, label: 'LDL'),
                ],
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 170.h,
                child: CustomPaint(
                  size: Size(double.infinity, 170.h),
                  painter: _TrendPainter(),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.trending_up_rounded,
                      size: 15.sp, color: AppColors.textSecondary),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      '콜레스테롤·LDL이 지난 검진보다 상승했어요. 식습관 관리가 필요해요.',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        const _Disclaimer(),
      ],
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
          child: Column(
            children: [
              _KvRow(
                Icons.local_hospital_rounded,
                '검진 기관',
                '삼성서울병원',
                onTap: () => context.push(Routes.hospitalDetail),
              ),
              _KvRow(Icons.event_rounded, '검진일', '2024.06.02 (일)'),
              _KvRow(Icons.medical_services_rounded, '검진의', '홍길동 · 가정의학과'),
              _KvRow(Icons.assignment_rounded, '검진 종류', '정기 종합검진'),
              _KvRow(Icons.checklist_rounded, '검사 항목', '총 28개 항목'),
              _KvRow(Icons.event_rounded, '다음 권장', '2024.12 (6개월 후)'),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        const _Disclaimer(),
      ],
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              size: 17.sp, color: AppColors.textSecondary),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '본 검진 결과는 참고용이며, 정확한 진단은 의료진과 상담이 필요합니다.',
              style: TextStyle(
                  fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _SumItem extends StatelessWidget {
  const _SumItem({
    this.icon,
    this.emoji,
    this.bg = AppColors.surface,
    this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
    this.valueSize = 20,
    required this.sub,
    this.showBorder = false,
  });

  final IconData? icon;
  final String? emoji;
  final Color bg;
  final Color? iconColor;
  final String label;
  final String value;
  final Color valueColor;
  final double valueSize;
  final String sub;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: showBorder
            ? const BoxDecoration(
                border: Border(left: BorderSide(color: AppColors.divider)))
            : null,
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Column(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Center(
                child: emoji != null
                    ? Text(emoji!, style: TextStyle(fontSize: 23.sp))
                    : Icon(icon, color: iconColor, size: 23.sp),
              ),
            ),
            SizedBox(height: 8.h),
            Text(label,
                style: TextStyle(
                    fontSize: 12.sp, color: AppColors.textSecondary)),
            Text(value,
                style: TextStyle(
                  fontSize: valueSize.sp,
                  fontWeight: FontWeight.w800,
                  color: valueColor,
                )),
            Text(sub,
                style: TextStyle(
                    fontSize: 10.5.sp, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _WarnRow extends StatelessWidget {
  const _WarnRow({
    required this.icon,
    required this.name,
    required this.range,
    required this.value,
    required this.unit,
  });

  final IconData icon;
  final String name;
  final String range;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFDF0DC),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, color: AppColors.primaryStrong, size: 22.sp),
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
                            fontSize: 15.sp, fontWeight: FontWeight.w700)),
                    SizedBox(width: 8.w),
                    StatusChip(
                      label: '주의',
                      height: 22.h,
                      backgroundColor: const Color(0xFFFEF3E2),
                      color: AppColors.warning,
                    ),
                  ],
                ),
                Text(range,
                    style: TextStyle(
                        fontSize: 12.sp, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.warning,
                  )),
              Text(unit,
                  style: TextStyle(
                      fontSize: 11.sp, color: AppColors.textSecondary)),
            ],
          ),
          Icon(Icons.chevron_right_rounded,
              color: AppColors.textDisabled, size: 20.sp),
        ],
      ),
    );
  }
}

class _NormCard extends StatelessWidget {
  const _NormCard({
    this.icon,
    this.emoji,
    this.iconColor,
    required this.label,
    required this.value,
    required this.unit,
    required this.range,
  });

  final IconData? icon;
  final String? emoji;
  final Color? iconColor;
  final String label;
  final String value;
  final String unit;
  final String range;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F4FB),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: emoji != null
                  ? Text(emoji!, style: TextStyle(fontSize: 20.sp))
                  : Icon(icon, color: iconColor, size: 20.sp),
            ),
          ),
          SizedBox(height: 8.h),
          Text(label,
              style: TextStyle(
                  fontSize: 11.5.sp, color: AppColors.textSecondary)),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF22A050),
              ),
              children: [
                TextSpan(text: value),
                TextSpan(
                  text: ' $unit',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Text(range,
              style: TextStyle(
                  fontSize: 10.sp, color: AppColors.textSecondary)),
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

class _TipCard extends StatelessWidget {
  const _TipCard({
    this.emoji,
    this.icon,
    required this.name,
    required this.desc,
  });

  final String? emoji;
  final IconData? icon;
  final String name;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            emoji != null
                ? Text(emoji!, style: TextStyle(fontSize: 24.sp))
                : Icon(icon, color: _purple, size: 24.sp),
            SizedBox(height: 6.h),
            Text(name,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800)),
            SizedBox(height: 4.h),
            Text(desc,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                  height: 1.5,
                )),
          ],
        ),
      ),
    );
  }
}

class _ResRow extends StatelessWidget {
  const _ResRow(
    this.name,
    this.sub,
    this.val,
    this.unit,
    this.status,
    this.isNormal,
  );

  final String name;
  final String sub;
  final String val;
  final String unit;
  final String status;
  final bool isNormal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: [
          Expanded(
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
          Text('$val $unit',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800)),
          SizedBox(width: 8.w),
          StatusChip(
            label: status,
            height: 24.h,
            backgroundColor: isNormal
                ? const Color(0xFFE8F5EC)
                : const Color(0xFFFEF3E2),
            color: isNormal ? const Color(0xFF22A050) : AppColors.warning,
          ),
        ],
      ),
    );
  }
}

class _KvRow extends StatelessWidget {
  const _KvRow(this.icon, this.keyLabel, this.value, {this.onTap});

  final IconData icon;
  final String keyLabel;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xFFEFE9FC),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: _purple, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          SizedBox(
            width: 84.w,
            child: Text(keyLabel,
                style: TextStyle(
                    fontSize: 13.sp, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 14.sp, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4.w),
        Text(label,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _TrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = const Color(0xFFEFEBF8);
    for (var i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(20, size.height * (0.12 + i * 0.28)),
        Offset(size.width - 10, size.height * (0.12 + i * 0.28)),
        grid,
      );
    }
    void line(Color c, List<Offset> pts) {
      final p = Paint()
        ..color = c
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final pt in pts.skip(1)) {
        path.lineTo(pt.dx, pt.dy);
      }
      canvas.drawPath(path, p);
      for (final pt in pts) {
        canvas.drawCircle(pt, 3.5, Paint()..color = c);
      }
    }

    line(const Color(0xFFF2547F), [
      Offset(size.width * 0.17, size.height * 0.41),
      Offset(size.width * 0.52, size.height * 0.34),
      Offset(size.width * 0.84, size.height * 0.28),
    ]);
    line(const Color(0xFFF59E0B), [
      Offset(size.width * 0.17, size.height * 0.56),
      Offset(size.width * 0.52, size.height * 0.53),
      Offset(size.width * 0.84, size.height * 0.49),
    ]);
    line(_purple, [
      Offset(size.width * 0.17, size.height * 0.62),
      Offset(size.width * 0.52, size.height * 0.56),
      Offset(size.width * 0.84, size.height * 0.42),
    ]);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
