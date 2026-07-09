import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../../../core/layout/app_frame.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/connected_notification_bell.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../auth/application/auth_providers.dart';
import '../application/health_providers.dart';
import '../domain/health_record.dart';

/// 건강 기록 — 퍼블리싱 10_health.html
class HealthPage extends ConsumerStatefulWidget {
  const HealthPage({super.key});

  @override
  ConsumerState<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends ConsumerState<HealthPage> {
  int _tab = 0;
  static const _tabs = [
    (Icons.favorite_rounded, '요약'),
    (Icons.ads_click_rounded, '활력 징후'),
    (Icons.monitor_weight_rounded, '체중'),
    (Icons.science_rounded, '검사 결과'),
    (Icons.assignment_rounded, '기록 히스토리'),
  ];

  Future<void> _addRecord() async {
    if (!firebaseReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Firebase 설정 후 기록을 저장할 수 있어요.')),
      );
      return;
    }
    final record = await showModalBottomSheet<HealthRecord>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddHealthSheet(),
    );
    if (record == null) return;
    final ok = await ref.read(healthControllerProvider.notifier).add(record);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? '기록이 저장되었어요.' : '저장에 실패했어요.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final name = (profile?.nickname.isNotEmpty ?? false)
        ? profile!.nickname
        : '엄마';
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addRecord,
        backgroundColor: AppColors.primaryStrong,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('기록 추가',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700)),
      ),
      appBar: MomsAppBar(
        title: '건강 기록',
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
                        '안녕하세요, $name님 💕',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '오늘도 건강한 하루 보내세요!',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8.w, 8.h, 12.w, 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(999.r),
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
                      Text('👶', style: TextStyle(fontSize: 18.sp)),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '임신 17주 3일',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'D-159일',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryStrong,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          SizedBox(
            height: 44.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              children: [
                for (var i = 0; i < _tabs.length; i++)
                  Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: GestureDetector(
                      onTap: () => setState(() => _tab = i),
                      child: Container(
                        height: 44.h,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: _tab == i
                              ? const Color(0xFFFFF3F7)
                              : AppColors.surface,
                          border: Border.all(
                            color: _tab == i
                                ? AppColors.primaryStrong
                                : AppColors.border,
                          ),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Row(
                          children: [
                            Icon(_tabs[i].$1,
                                size: 18.sp,
                                color: _tab == i
                                    ? AppColors.primaryStrong
                                    : AppColors.textSecondary),
                            SizedBox(width: 5.w),
                            Text(
                              _tabs[i].$2,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: _tab == i
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: _tab == i
                                    ? AppColors.primaryStrong
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          const _RecentHealthCard(),
          if (_tab == 0) const _SummaryPanel() else _SimpleListPanel(tab: _tab),
        ],
      ),
    );
  }
}

/// 최근 저장한 건강 기록 목록.
class _RecentHealthCard extends ConsumerWidget {
  const _RecentHealthCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(healthRecordsProvider).value ?? const [];
    if (records.isEmpty) return const SizedBox.shrink();
    final recent = records.take(5).toList();
    return AppContent(
      bottom: false,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('최근 건강 기록',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800)),
            SizedBox(height: 12.h),
            for (final r in recent)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
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
                      child: Icon(_iconFor(r.type),
                          size: 18.sp, color: AppColors.primaryStrong),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(r.type.label,
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w600)),
                    ),
                    Text(
                      '${_fmt(r.value)} ${r.unit.isEmpty ? r.type.unit : r.unit}',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w800),
                    ),
                    if (r.recordedAt != null) ...[
                      SizedBox(width: 8.w),
                      Text(
                        '${r.recordedAt!.month}/${r.recordedAt!.day}',
                        style: TextStyle(
                            fontSize: 11.sp, color: AppColors.textDisabled),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String _fmt(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  static IconData _iconFor(HealthType t) {
    switch (t) {
      case HealthType.weight:
        return Icons.monitor_weight_rounded;
      case HealthType.bloodPressure:
        return Icons.favorite_rounded;
      case HealthType.bloodSugar:
        return Icons.bloodtype_rounded;
      case HealthType.water:
        return Icons.water_drop_rounded;
      case HealthType.exercise:
        return Icons.directions_run_rounded;
    }
  }
}

/// 건강 기록 추가 시트.
class _AddHealthSheet extends StatefulWidget {
  const _AddHealthSheet();

  @override
  State<_AddHealthSheet> createState() => _AddHealthSheetState();
}

class _AddHealthSheetState extends State<_AddHealthSheet> {
  HealthType _type = HealthType.weight;
  final _valueCtrl = TextEditingController();
  final _memoCtrl = TextEditingController();

  @override
  void dispose() {
    _valueCtrl.dispose();
    _memoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('건강 기록 추가',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800)),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final t in HealthType.values)
                GestureDetector(
                  onTap: () => setState(() => _type = t),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: _type == t
                          ? const Color(0xFFFFF3F7)
                          : AppColors.surface,
                      border: Border.all(
                        color: _type == t
                            ? AppColors.primaryStrong
                            : AppColors.border,
                      ),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(t.label,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: _type == t
                              ? AppColors.primaryStrong
                              : AppColors.textSecondary,
                        )),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: _valueCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: '측정값 (${_type.unit})',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _memoCtrl,
            decoration: InputDecoration(
              labelText: '메모 (선택)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryStrong,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              onPressed: () {
                final v = double.tryParse(_valueCtrl.text.trim());
                if (v == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('측정값을 숫자로 입력해주세요.')),
                  );
                  return;
                }
                Navigator.pop(
                  context,
                  HealthRecord(
                    id: '',
                    type: _type,
                    value: v,
                    unit: _type.unit,
                    memo: _memoCtrl.text.trim(),
                    recordedAt: DateTime.now(),
                  ),
                );
              },
              child: Text('저장',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700)),
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
    return AppContent(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.chevron_left_rounded, size: 24.sp),
              ),
              Row(
                children: [
                  Icon(Icons.calendar_month_rounded,
                      size: 20.sp, color: AppColors.primaryStrong),
                  SizedBox(width: 6.w),
                  Text(
                    '2024.06.02 (일)',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Icon(Icons.expand_more_rounded,
                      size: 18.sp, color: AppColors.textSecondary),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.chevron_right_rounded, size: 24.sp),
              ),
            ],
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
                      '오늘의 건강 요약',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 0),
                        minimumSize: Size(0, 36.h),
                      ),
                      icon: Icon(Icons.add_circle_rounded,
                          size: 15.sp, color: AppColors.primaryStrong),
                      label: Text(
                        '측정 기록 추가',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryStrong,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: const [
                    _VitalItem(
                      icon: Icons.favorite_rounded,
                      bg: Color(0xFFFDEFF3),
                      iconColor: AppColors.primaryStrong,
                      label: '혈압',
                      value: '110/70',
                      unit: 'mmHg',
                      badge: '정상',
                    ),
                    _VitalItem(
                      icon: Icons.water_drop_rounded,
                      bg: Color(0xFFFDF3E4),
                      iconColor: AppColors.warning,
                      label: '혈당',
                      value: '92',
                      unit: 'mg/dL',
                      badge: '정상',
                    ),
                    _VitalItem(
                      icon: Icons.monitor_weight_rounded,
                      bg: AppColors.aiPurpleLight,
                      iconColor: Color(0xFF7C5CD6),
                      label: '체중',
                      value: '56.2',
                      unit: 'kg',
                      badge: '정상',
                    ),
                    _VitalItem(
                      icon: Icons.thermostat_rounded,
                      bg: Color(0xFFE4F5F2),
                      iconColor: Color(0xFF14B8A6),
                      label: '체온',
                      value: '36.6',
                      unit: '°C',
                      badge: '정상',
                    ),
                    _VitalItem(
                      icon: Icons.bedtime_rounded,
                      bg: Color(0xFFE9EFFC),
                      iconColor: Color(0xFF3B82F6),
                      label: '수면',
                      value: '7시간 30분',
                      unit: '좋음',
                      badge: '좋음',
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDEFF3),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      Text('🌟', style: TextStyle(fontSize: 22.sp)),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          '전반적으로 안정적인 상태예요.\n꾸준한 관리로 건강한 임신 생활을 유지해요!',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: AppColors.primaryStrong, size: 22.sp),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '주요 변화 추이',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        minimumSize: Size(0, 36.h),
                      ),
                      child: Text(
                        '최근 7일',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  height: 120.h,
                  child: CustomPaint(
                    size: Size(double.infinity, 120.h),
                    painter: _ChartPainter(),
                  ),
                ),
                Center(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.chevron_right_rounded,
                        size: 18.sp, color: AppColors.primaryStrong),
                    label: Text(
                      '자세히 보기',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryStrong,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppCard(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: '최근 건강 기록', moreLabel: '더보기'),
                      SizedBox(height: 8.h),
                      const _RecentItem(
                        icon: Icons.vaccines_rounded,
                        bg: AppColors.aiPurpleLight,
                        iconColor: Color(0xFF7C5CD6),
                        title: '독감 예방접종',
                        meta: '2024.06.15 (토) 14:00\n삼성산부인과',
                      ),
                      const _RecentItem(
                        icon: Icons.science_rounded,
                        bg: Color(0xFFFDF0DC),
                        title: '정기 혈액검사',
                        meta: '2024.06.10 (월) 10:30\n삼성산부인과',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppCard(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '빠른 기록',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 8.h,
                        crossAxisSpacing: 8.w,
                        childAspectRatio: 1.1,
                        children: const [
                          _QuickCell(
                            icon: Icons.favorite_rounded,
                            bg: Color(0xFFFDEFF3),
                            label: '활력 징후 기록',
                          ),
                          _QuickCell(
                            icon: Icons.monitor_weight_rounded,
                            bg: AppColors.aiPurpleLight,
                            label: '체중 기록',
                          ),
                          _QuickCell(
                            icon: Icons.water_drop_rounded,
                            bg: Color(0xFFE4F5F2),
                            label: '혈당 기록',
                          ),
                          _QuickCell(
                            icon: Icons.bedtime_rounded,
                            bg: Color(0xFFE9EFFC),
                            label: '수면 기록',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFBEAF0),
              borderRadius: BorderRadius.circular(AppSizes.radiusCard),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_rounded,
                    color: AppColors.warning, size: 20.sp),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '건강 팁',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '철분이 풍부한 식품을 섭취하고, 하루 30분 가벼운 산책을 추천드려요.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: AppColors.primaryStrong, size: 22.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleListPanel extends StatelessWidget {
  const _SimpleListPanel({required this.tab});
  final int tab;

  static const _items = {
    1: [
      ('혈압', '110/70', '정상'),
      ('심박수', '72 bpm', '정상'),
      ('체온', '36.6°C', '정상'),
    ],
    2: [
      ('현재 체중', '56.2 kg', '정상'),
      ('임신 전 대비', '▲ 4.1kg', ''),
    ],
    3: [
      ('공복 혈당', '92', '주의'),
      ('혈색소', '12.5', '정상'),
      ('총 콜레스테롤', '205', '주의'),
    ],
    4: [
      ('체중 기록', '56.2kg', '06.02'),
      ('혈압 기록', '110/70', '06.02'),
      ('수면 기록', '7h 30m', '06.01'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final items = _items[tab] ?? [];
    return AppContent(
      child: AppCard(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
        child: Column(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        items[i].$1,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      items[i].$2,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (items[i].$3.isNotEmpty) ...[
                      SizedBox(width: 8.w),
                      StatusChip(
                        label: items[i].$3,
                        height: 22.h,
                        color: AppColors.primaryStrong,
                      ),
                    ],
                  ],
                ),
              ),
              if (i < items.length - 1)
                const Divider(height: 1, color: AppColors.divider),
            ],
          ],
        ),
      ),
    );
  }
}

class _VitalItem extends StatelessWidget {
  const _VitalItem({
    required this.icon,
    required this.bg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.unit,
    required this.badge,
  });

  final IconData icon;
  final Color bg;
  final Color iconColor;
  final String label;
  final String value;
  final String unit;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22.sp, color: iconColor),
            SizedBox(height: 8.h),
            Text(label,
                style: TextStyle(
                    fontSize: 11.sp, color: AppColors.textSecondary)),
            SizedBox(height: 4.h),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
            ),
            Text(unit,
                style: TextStyle(
                    fontSize: 10.sp, color: AppColors.textSecondary)),
            SizedBox(height: 6.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentItem extends StatelessWidget {
  const _RecentItem({
    required this.icon,
    required this.bg,
    this.iconColor,
    required this.title,
    required this.meta,
  });

  final IconData icon;
  final Color bg;
  final Color? iconColor;
  final String title;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon,
                size: 17.sp,
                color: iconColor ?? AppColors.primaryStrong),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 13.sp, fontWeight: FontWeight.w700)),
                Text(meta,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickCell extends StatelessWidget {
  const _QuickCell({
    required this.icon,
    required this.bg,
    required this.label,
  });

  final IconData icon;
  final Color bg;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primaryStrong, size: 24.sp),
          SizedBox(height: 6.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF2547F)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(0, size.height * 0.4)
      ..lineTo(size.width * 0.15, size.height * 0.3)
      ..lineTo(size.width * 0.3, size.height * 0.35)
      ..lineTo(size.width * 0.45, size.height * 0.28)
      ..lineTo(size.width * 0.6, size.height * 0.3)
      ..lineTo(size.width * 0.75, size.height * 0.25)
      ..lineTo(size.width, size.height * 0.28);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
