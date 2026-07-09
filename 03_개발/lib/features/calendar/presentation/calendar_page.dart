import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../../../core/layout/app_frame.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/status_chip.dart';
import '../application/schedule_providers.dart';
import '../domain/schedule.dart';

/// 캘린더 — 퍼블리싱 08_calendar.html
class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  bool _calendarView = true;

  Future<void> _addSchedule() async {
    if (!firebaseReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Firebase 설정 후 일정을 저장할 수 있어요.')),
      );
      return;
    }
    final day = ref.read(selectedDateProvider);
    final schedule = await showModalBottomSheet<Schedule>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddScheduleSheet(day: day),
    );
    if (schedule == null) return;
    final ok = await ref.read(scheduleControllerProvider.notifier).add(schedule);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? '일정이 추가되었어요.' : '추가에 실패했어요.')),
    );
  }

  static const _dows = ['일', '월', '화', '수', '목', '금', '토'];

  static final _cells = <_CalCell>[
    _CalCell('26', out: true),
    _CalCell('27', out: true),
    _CalCell('28', out: true),
    _CalCell('29', out: true),
    _CalCell('30', out: true),
    _CalCell('31', out: true),
    _CalCell('1'),
    _CalCell('2', sun: true),
    _CalCell('3', dots: [_Dot.med]),
    _CalCell('4'),
    _CalCell('5', dots: [_Dot.test]),
    _CalCell('6'),
    _CalCell('7'),
    _CalCell('8'),
    _CalCell('9', sun: true),
    _CalCell('10'),
    _CalCell('11'),
    _CalCell('12', ovul: true),
    _CalCell('13'),
    _CalCell('14', dots: [_Dot.med]),
    _CalCell('15'),
    _CalCell('16', sun: true),
    _CalCell('17'),
    _CalCell('18'),
    _CalCell('19', period: true, periodStart: true),
    _CalCell('20', period: true),
    _CalCell('21', period: true),
    _CalCell('22', period: true, periodEnd: true),
    _CalCell('23', sun: true),
    _CalCell('24'),
    _CalCell('25'),
    _CalCell('26', today: true, dots: [_Dot.white]),
    _CalCell('27', dots: [_Dot.etc]),
    _CalCell('28', dots: [_Dot.med]),
    _CalCell('29'),
    _CalCell('30', sun: true),
    _CalCell('1', out: true),
    _CalCell('2', out: true),
    _CalCell('3', out: true),
    _CalCell('4', out: true),
    _CalCell('5', out: true),
    _CalCell('6', out: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addSchedule,
        backgroundColor: AppColors.primaryStrong,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('일정 추가',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700)),
      ),
      appBar: MomsAppBar(
        title: '캘린더',
        leading: SizedBox(width: 40.w),
        actions: [
          TextButton(
            onPressed: () =>
                ref.read(selectedDateProvider.notifier).set(DateTime.now()),
            child: Text(
              '오늘',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryStrong,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: AppSizes.contentPaddingBottom),
        children: [
          AppContent(
            bottom: false,
            child: _ViewToggle(
              calendarView: _calendarView,
              onChanged: (v) => setState(() => _calendarView = v),
            ),
          ),
          if (_calendarView) ...[
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.chevron_left_rounded,
                        color: AppColors.textSecondary, size: 24.sp),
                  ),
                  Text(
                    '2024년 6월',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.chevron_right_rounded,
                        color: AppColors.textSecondary, size: 24.sp),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 0),
              child: Wrap(
                spacing: 12.w,
                runSpacing: 8.h,
                children: const [
                  _LegendDot(color: AppColors.primaryStrong, label: '생리 예정'),
                  _LegendDot(color: Color(0xFF7C5CD6), label: '배란 예정'),
                  _LegendDot(color: Color(0xFF34C759), label: '복약 일정'),
                  _LegendDot(color: AppColors.warning, label: '검사 일정'),
                  _LegendDot(color: Color(0xFF3B82F6), label: '기타 일정'),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            AppContent(
              bottom: false,
              child: AppCard(
                padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 20.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        for (var i = 0; i < 7; i++)
                          Expanded(
                            child: Text(
                              _dows[i],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: i == 0
                                    ? AppColors.primaryStrong
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: _cells.length,
                      itemBuilder: (_, i) => _CalCellWidget(cell: _cells[i]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            AppContent(
              bottom: false,
              child: AppCard(
                child: _DaySchedulePanel(onAdd: _addSchedule),
              ),
            ),
            SizedBox(height: 16.h),
            AppContent(
              bottom: false,
              child: AppCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.monitor_heart_rounded,
                            color: AppColors.primaryStrong, size: 20.sp),
                        SizedBox(width: 6.w),
                        Text(
                          '이번 달 요약',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '상세 보기',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryStrong,
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded,
                            size: 16.sp, color: AppColors.primaryStrong),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    const Row(
                      children: [
                        _MonthSummaryItem(
                          icon: Icons.bloodtype_rounded,
                          bg: AppColors.primaryLight,
                          label: '생리 예정',
                          value: '19일 ~ 22일',
                        ),
                        _MonthSummaryItem(
                          emoji: '⭕',
                          bg: AppColors.aiPurpleLight,
                          label: '배란 예정',
                          value: '12일',
                        ),
                        _MonthSummaryItem(
                          icon: Icons.medication_rounded,
                          bg: Color(0xFFE9F7EA),
                          label: '복약 일정',
                          value: '8일',
                        ),
                        _MonthSummaryItem(
                          icon: Icons.science_rounded,
                          bg: Color(0xFFFDF0DC),
                          label: '검사 일정',
                          value: '2일',
                        ),
                        _MonthSummaryItem(
                          icon: Icons.calendar_month_rounded,
                          bg: Color(0xFFE4EEFC),
                          label: '기타 일정',
                          value: '3일',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            SizedBox(height: 12.h),
            AppContent(
              bottom: false,
              child: _ListGroup(
                date: '06.03',
                dow: '(월)',
                items: [
                  _DayItem(
                    icon: Icons.medication_rounded,
                    iconBg: AppColors.primaryLight,
                    iconColor: AppColors.primaryStrong,
                    time: '09:00',
                    title: '엽산 400mcg',
                    meta: '1정  |  식후 30분',
                    done: true,
                    onTap: () => context.push(Routes.medicationDetail),
                  ),
                ],
              ),
            ),
            AppContent(
              bottom: false,
              child: _ListGroup(
                date: '06.26',
                dow: '(수)',
                today: true,
                items: [
                  _DayItem(
                    icon: Icons.medication_rounded,
                    iconBg: AppColors.primaryLight,
                    iconColor: AppColors.primaryStrong,
                    time: '09:00',
                    title: '엽산 400mcg',
                    meta: '1정  |  식후 30분',
                    done: true,
                    onTap: () => context.push(Routes.medicationDetail),
                  ),
                  _DayItem(
                    icon: Icons.science_rounded,
                    iconBg: const Color(0xFFFDF0DC),
                    iconColor: AppColors.warning,
                    time: '13:00',
                    timeColor: AppColors.warning,
                    title: '정기 혈액검사',
                    meta: '삼성산부인과',
                    chip: '예정',
                    chipWarning: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

String _two(int v) => v.toString().padLeft(2, '0');

IconData _scheduleIcon(ScheduleType t) {
  switch (t) {
    case ScheduleType.medication:
      return Icons.medication_rounded;
    case ScheduleType.checkup:
      return Icons.science_rounded;
    case ScheduleType.hospital:
      return Icons.local_hospital_rounded;
    case ScheduleType.personal:
      return Icons.event_rounded;
  }
}

Color _scheduleBg(ScheduleType t) {
  switch (t) {
    case ScheduleType.medication:
      return AppColors.primaryLight;
    case ScheduleType.checkup:
      return const Color(0xFFFDF0DC);
    case ScheduleType.hospital:
      return AppColors.aiPurpleLight;
    case ScheduleType.personal:
      return const Color(0xFFE4EEFC);
  }
}

Color _scheduleColor(ScheduleType t) {
  switch (t) {
    case ScheduleType.medication:
      return AppColors.primaryStrong;
    case ScheduleType.checkup:
      return AppColors.warning;
    case ScheduleType.hospital:
      return const Color(0xFF7C5CD6);
    case ScheduleType.personal:
      return const Color(0xFF3B82F6);
  }
}

/// 선택된 날짜의 일정 목록 패널.
class _DaySchedulePanel extends ConsumerWidget {
  const _DaySchedulePanel({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(selectedDateProvider);
    final items = ref.watch(schedulesForSelectedDayProvider);
    const dows = ['일', '월', '화', '수', '목', '금', '토'];
    final dateLabel =
        '${day.year}.${_two(day.month)}.${_two(day.day)} (${dows[day.weekday % 7]})';
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateLabel,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryStrong,
              ),
            ),
            GestureDetector(
              onTap: onAdd,
              child: const _OutlinePill(
                icon: Icons.add_circle_rounded,
                label: '일정 추가',
              ),
            ),
          ],
        ),
        if (items.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 28.h),
            child: Text(
              '등록된 일정이 없어요.\n일정을 추가해보세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          )
        else
          for (final s in items)
            _DayItem(
              icon: _scheduleIcon(s.type),
              iconBg: _scheduleBg(s.type),
              iconColor: _scheduleColor(s.type),
              time: s.date != null
                  ? '${_two(s.date!.hour)}:${_two(s.date!.minute)}'
                  : '-',
              timeColor: _scheduleColor(s.type),
              title: s.title,
              meta: s.memo.isEmpty ? s.type.label : s.memo,
              done: s.completed,
              onTap: () =>
                  ref.read(scheduleControllerProvider.notifier).toggle(s),
            ),
      ],
    );
  }
}

/// 일정 추가 시트.
class _AddScheduleSheet extends StatefulWidget {
  const _AddScheduleSheet({required this.day});
  final DateTime day;

  @override
  State<_AddScheduleSheet> createState() => _AddScheduleSheetState();
}

class _AddScheduleSheetState extends State<_AddScheduleSheet> {
  final _titleCtrl = TextEditingController();
  final _memoCtrl = TextEditingController();
  ScheduleType _type = ScheduleType.personal;
  TimeOfDay _time = const TimeOfDay(hour: 9, minute: 0);

  @override
  void dispose() {
    _titleCtrl.dispose();
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
          Text('일정 추가',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800)),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final t in ScheduleType.values)
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
            controller: _titleCtrl,
            decoration: InputDecoration(
              labelText: '일정 제목',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Text('시간: ${_time.format(context)}',
                    style: TextStyle(fontSize: 14.sp)),
              ),
              TextButton.icon(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _time,
                  );
                  if (picked != null) setState(() => _time = picked);
                },
                icon: const Icon(Icons.schedule_rounded),
                label: const Text('시간 선택'),
              ),
            ],
          ),
          SizedBox(height: 8.h),
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
                final title = _titleCtrl.text.trim();
                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('일정 제목을 입력해주세요.')),
                  );
                  return;
                }
                Navigator.pop(
                  context,
                  Schedule(
                    id: '',
                    title: title,
                    type: _type,
                    date: DateTime(widget.day.year, widget.day.month,
                        widget.day.day, _time.hour, _time.minute),
                    memo: _memoCtrl.text.trim(),
                  ),
                );
              },
              child: Text('추가',
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

enum _Dot { med, test, etc, white }

class _CalCell {
  const _CalCell(
    this.day, {
    this.out = false,
    this.sun = false,
    this.today = false,
    this.ovul = false,
    this.period = false,
    this.periodStart = false,
    this.periodEnd = false,
    this.dots,
  });

  final String day;
  final bool out;
  final bool sun;
  final bool today;
  final bool ovul;
  final bool period;
  final bool periodStart;
  final bool periodEnd;
  final List<_Dot>? dots;
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.calendarView, required this.onChanged});

  final bool calendarView;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          _ToggleBtn(
            label: '달력',
            icon: Icons.calendar_month_rounded,
            active: calendarView,
            onTap: () => onChanged(true),
          ),
          _ToggleBtn(
            label: '목록',
            icon: Icons.list_rounded,
            active: !calendarView,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  const _ToggleBtn({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52.h,
          decoration: BoxDecoration(
            color: active ? const Color(0xFFFFF7F9) : Colors.transparent,
            border: active
                ? Border(
                    bottom: BorderSide(
                      color: AppColors.primaryStrong,
                      width: 2.5,
                    ),
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: active
                    ? AppColors.primaryStrong
                    : AppColors.textSecondary,
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  color: active
                      ? AppColors.primaryStrong
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalCellWidget extends StatelessWidget {
  const _CalCellWidget({required this.cell});
  final _CalCell cell;

  Color _dotColor(_Dot d) => switch (d) {
        _Dot.med => const Color(0xFF34C759),
        _Dot.test => AppColors.warning,
        _Dot.etc => const Color(0xFF3B82F6),
        _Dot.white => Colors.white,
      };

  @override
  Widget build(BuildContext context) {
    if (cell.out) {
      return Opacity(
        opacity: 0.5,
        child: Column(
          children: [
            Text(
              cell.day,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textDisabled,
              ),
            ),
          ],
        ),
      );
    }

  final bgRadius = BorderRadius.horizontal(
      left: cell.periodStart ? Radius.circular(26.r) : Radius.zero,
      right: cell.periodEnd ? Radius.circular(26.r) : Radius.zero,
    );

    return Container(
      decoration: cell.period
          ? BoxDecoration(
              color: const Color(0xFFFBDEE7),
              borderRadius: bgRadius,
            )
          : null,
      child: Column(
        children: [
          SizedBox(height: 6.h),
          Container(
            width: 36.w,
            height: 36.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: cell.today
                  ? AppColors.primaryStrong
                  : cell.ovul
                      ? const Color(0xFFE7DEFA)
                      : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              cell.day,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: cell.today || cell.ovul
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: cell.today
                    ? Colors.white
                    : cell.ovul
                        ? const Color(0xFF7C5CD6)
                        : cell.sun
                            ? AppColors.primaryStrong
                            : AppColors.textPrimary,
              ),
            ),
          ),
          if (cell.dots != null) ...[
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final d in cell.dots!)
                  Container(
                    width: 5.w,
                    height: 5.w,
                    margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                    decoration: BoxDecoration(
                      color: _dotColor(d),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ],
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
        SizedBox(width: 5.w),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _OutlinePill extends StatelessWidget {
  const _OutlinePill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: AppColors.primaryStrong),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryStrong,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayItem extends StatelessWidget {
  const _DayItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.time,
    required this.title,
    required this.meta,
    this.timeColor = AppColors.primaryStrong,
    this.done = false,
    this.chip,
    this.chipWarning = false,
    this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String time;
  final Color timeColor;
  final String title;
  final String meta;
  final bool done;
  final String? chip;
  final bool chipWarning;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBFC),
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: timeColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    meta,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (done)
              Container(
                width: 28.w,
                height: 28.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF34C759),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_rounded, color: Colors.white, size: 16.sp),
              )
            else if (chip != null)
              StatusChip(
                label: chip!,
                color: chipWarning ? AppColors.warning : AppColors.success,
                backgroundColor:
                    chipWarning ? const Color(0xFFFEF3E2) : const Color(0xFFE9F7EA),
                height: 26.h,
              ),
            SizedBox(width: 6.w),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.textDisabled, size: 20.sp),
          ],
        ),
      ),
    );
  }
}

class _MonthSummaryItem extends StatelessWidget {
  const _MonthSummaryItem({
    required this.label,
    required this.value,
    required this.bg,
    this.icon,
    this.emoji,
  });

  final IconData? icon;
  final String? emoji;
  final Color bg;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: icon != null
                ? Icon(icon, color: AppColors.primaryStrong, size: 20.sp)
                : Text(emoji!, style: TextStyle(fontSize: 20.sp)),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _ListGroup extends StatelessWidget {
  const _ListGroup({
    required this.date,
    required this.dow,
    required this.items,
    this.today = false,
  });

  final String date;
  final String dow;
  final bool today;
  final List<_DayItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Row(
            children: [
              Text(
                '$date ',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800),
              ),
              Text(
                dow,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              if (today) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryStrong,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    '오늘',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        ...items,
      ],
    );
  }
}
