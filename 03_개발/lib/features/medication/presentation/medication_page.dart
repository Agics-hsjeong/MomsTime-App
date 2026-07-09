import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_frame.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/med_check_circle.dart';
import '../../../shared/widgets/connected_notification_bell.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../shell/presentation/main_shell.dart';
import '../application/medication_providers.dart';
import '../domain/medication.dart';

/// 복약 관리 — 퍼블리싱 06_medication.html
class MedicationPage extends ConsumerWidget {
  const MedicationPage({super.key});

  static const _weekDays = [
    ('목', '30', false),
    ('금', '31', false),
    ('토', '1', false),
    ('오늘', '2', true),
    ('월', '3', false),
    ('화', '4', false),
    ('수', '5', false),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doses = ref.watch(todayDosesProvider);
    final summary = ref.watch(medicationSummaryProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.only(bottom: AppSizes.contentPaddingBottom),
          children: [
            // .med-top
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
              child: const Align(
                alignment: Alignment.centerRight,
                child: ConnectedNotificationBell(),
              ),
            ),
            // .med-head
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
                          '복약 관리 ❤️',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '약',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: ' 복용을 잊지 않도록 도와드릴게요.',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _AddPillButton(
                    onTap: () => context.push(Routes.medicationRegister),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            AppContent(
              bottom: false,
              child: AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_month_rounded,
                                  color: AppColors.primaryStrong, size: 20.sp),
                              SizedBox(width: 8.w),
                              Text(
                                '2024.06.02 (일)',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => switchMainTab(context, 2),
                            child: Row(
                              children: [
                                Text(
                                  '캘린더 보기',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryStrong,
                                  ),
                                ),
                                Icon(Icons.chevron_right_rounded,
                                    size: 16.sp,
                                    color: AppColors.primaryStrong),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.w, 14.h, 8.w, 18.h),
                      child: Row(
                        children: [
                          for (final d in _weekDays)
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    d.$1,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: d.$3
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      color: d.$3
                                          ? AppColors.primaryStrong
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Container(
                                    width: 40.w,
                                    height: 40.w,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: d.$3
                                          ? AppColors.primaryLight
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      d.$2,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: d.$3
                                            ? FontWeight.w800
                                            : FontWeight.w600,
                                        color: d.$3
                                            ? AppColors.primaryStrong
                                            : AppColors.textPrimary,
                                      ),
                                    ),
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
            ),
            SizedBox(height: 28.h),
            AppContent(
              bottom: false,
              child: Row(
                children: [
                  Text(
                    '오늘 복용할 약 ',
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  StatusChip(label: '${doses.length}개'),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.push(Routes.medicationComplete),
                    child: Row(
                      children: [
                        Text(
                          '복약 완료 확인',
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
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            AppContent(
              bottom: false,
              child: doses.isEmpty
                  ? _EmptyDoses(
                      onAdd: () => context.push(Routes.medicationRegister),
                    )
                  : Column(
                      children: [
                        for (var i = 0; i < doses.length; i++) ...[
                          if (i > 0) SizedBox(height: 12.h),
                          _DoseCard(
                            dose: doses[i],
                            onToggle: () => ref
                                .read(medicationControllerProvider.notifier)
                                .toggleDose(doses[i]),
                            onTap: () {
                              ref
                                  .read(selectedMedicationIdProvider.notifier)
                                  .set(doses[i].medication.id);
                              context.push(Routes.medicationDetail);
                            },
                          ),
                        ],
                      ],
                    ),
            ),
            SizedBox(height: 28.h),
            AppContent(
              bottom: false,
              child: SectionHeader(title: '복약 요약', moreLabel: '전체 보기'),
            ),
            SizedBox(height: 12.h),
            AppContent(
              bottom: false,
              child: AppCard(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  children: [
                    _SummaryItem(
                      icon: Icons.calendar_month_rounded,
                      label: '오늘 복약률',
                      value: '${summary.rate}',
                      unit: '%',
                      sub: '${summary.completed} / ${summary.total}',
                    ),
                    _SummaryItem(
                      icon: Icons.medication_rounded,
                      label: '등록된 약',
                      value: '${summary.medCount}',
                      unit: '개',
                      sub: '약 ${summary.medCount}종',
                      showBorder: true,
                    ),
                    _SummaryItem(
                      icon: Icons.alarm_rounded,
                      label: '오늘 남은 약',
                      value: '${summary.total - summary.completed}',
                      unit: '개',
                      sub: '복용 예정',
                      showBorder: true,
                    ),
                    _SummaryItem(
                      icon: Icons.check_circle_rounded,
                      iconColor: const Color(0xFF22A050),
                      label: '오늘 완료',
                      value: '${summary.completed}',
                      unit: '개',
                      sub: '복용 완료',
                      showBorder: true,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            AppContent(
              bottom: false,
              child: AppCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🤖', style: TextStyle(fontSize: 52.sp)),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI 복약 팁',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            '엽산은 임신 초기에 특히 중요해요!\n매일 꾸준히 복용하면 태아의 신경관 발달에 도움이 됩니다.',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          GestureDetector(
                            onTap: () => switchMainTab(context, 3),
                            child: Container(
                              height: 36.h,
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(999.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'AI 케어로 가기',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryStrong,
                                    ),
                                  ),
                                  Icon(Icons.chevron_right_rounded,
                                      size: 16.sp,
                                      color: AppColors.primaryStrong),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoseCard extends StatelessWidget {
  const _DoseCard({required this.dose, required this.onToggle, this.onTap});

  final MedicationDose dose;
  final VoidCallback onToggle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final med = dose.medication;
    final hour = int.tryParse(dose.time.split(':').first) ?? 9;
    final isEvening = hour >= 18;
    final ampm = isEvening ? '저녁' : (hour < 12 ? '☀️ 오전' : '☀️ 오후');
    final meta = [
      if (med.dosage.isNotEmpty) med.dosage,
      med.isSupplement ? '영양제' : '복용약',
    ].join('  |  ');
    return _MedItemCard(
      ampm: ampm,
      ampmIcon: isEvening ? Icons.bedtime_rounded : null,
      ampmIconColor: isEvening ? const Color(0xFF3B82F6) : null,
      time: dose.time.isEmpty ? '-' : dose.time,
      state: dose.completed ? '복용 완료' : '복용 예정',
      name: med.name,
      meta: meta,
      note: med.memo.isEmpty
          ? (med.beforeMeal ? '식전 복용' : '식후 복용')
          : med.memo,
      thumbBg:
          med.isSupplement ? AppColors.aiPurpleLight : AppColors.primaryLight,
      checked: dose.completed,
      onToggle: onToggle,
      onTap: onTap,
    );
  }
}

class _EmptyDoses extends StatelessWidget {
  const _EmptyDoses({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          SizedBox(height: 8.h),
          Icon(Icons.medication_outlined,
              size: 40.sp, color: AppColors.textDisabled),
          SizedBox(height: 10.h),
          Text('오늘 복용할 약이 없어요',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700)),
          SizedBox(height: 4.h),
          Text('약을 등록하면 여기에 표시돼요.',
              style:
                  TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
          SizedBox(height: 14.h),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(999.r),
              ),
              alignment: Alignment.center,
              child: Text('약 등록하기',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

class _AddPillButton extends StatelessWidget {
  const _AddPillButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Ink(
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
              Icon(Icons.add_rounded, color: Colors.white, size: 20.sp),
              SizedBox(width: 6.w),
              Text(
                '약 등록',
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
    );
  }
}

class _MedItemCard extends StatelessWidget {
  const _MedItemCard({
    required this.ampm,
    required this.time,
    required this.state,
    required this.name,
    required this.meta,
    required this.note,
    required this.thumbBg,
    required this.checked,
    required this.onToggle,
    this.onTap,
    this.ampmIcon,
    this.ampmIconColor,
  });

  final String ampm;
  final IconData? ampmIcon;
  final Color? ampmIconColor;
  final String time;
  final String state;
  final String name;
  final String meta;
  final String note;
  final Color thumbBg;
  final bool checked;
  final VoidCallback onToggle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 108.w,
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 8.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFDEFF3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radiusCard),
                  bottomLeft: Radius.circular(AppSizes.radiusCard),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (ampmIcon != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(ampmIcon, size: 14.sp, color: ampmIconColor),
                        SizedBox(width: 4.w),
                        Text(
                          ampm,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      ampm,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  SizedBox(height: 4.h),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      state,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryStrong,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Container(
                      width: 64.w,
                      height: 64.w,
                      decoration: BoxDecoration(
                        color: thumbBg,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        Icons.medication_rounded,
                        color: AppColors.primaryStrong,
                        size: 30.sp,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            meta,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                size: 14.sp,
                                color: AppColors.textDisabled,
                              ),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: Text(
                                  note,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textDisabled,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    MedCheckCircle(checked: checked, onTap: onToggle),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.sub,
    this.iconColor = AppColors.primaryStrong,
    this.showBorder = false,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String unit;
  final String sub;
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
          child: Column(
            children: [
              Icon(icon, color: iconColor, size: 26.sp),
              SizedBox(height: 8.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 4.h),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: unit,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                sub,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textDisabled,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
