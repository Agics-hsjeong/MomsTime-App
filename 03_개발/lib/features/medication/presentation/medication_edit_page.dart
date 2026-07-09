import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../../../core/layout/app_frame.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/primary_button.dart';
import '../application/medication_providers.dart';
import '../domain/medication.dart';

/// 복약 수정 — 퍼블리싱 19_medication_edit.html
class MedicationEditPage extends ConsumerStatefulWidget {
  const MedicationEditPage({super.key});

  @override
  ConsumerState<MedicationEditPage> createState() => _MedicationEditPageState();
}

class _MedicationEditPageState extends ConsumerState<MedicationEditPage> {
  int _mode = 0;
  final _nameCtrl = TextEditingController(text: '아목시실린정 250mg');
  final _amountCtrl = TextEditingController(text: '250');
  final _memoCtrl = TextEditingController();
  bool _alarmOn = true;
  final _alarmTypes = [true, true, false, false];
  final _timeEnabled = [true, false, true, false];
  final _timeValues = ['09:00', '', '19:00', ''];
  Medication? _med;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final med = ref.read(selectedMedicationProvider);
    _med = med;
    if (med != null) {
      _nameCtrl.text = med.name;
      _memoCtrl.text = med.memo;
      _alarmOn = med.isActive;
      // 등록된 시간을 아침/저녁 슬롯에 매핑.
      if (med.times.isNotEmpty) {
        _timeEnabled[0] = false;
        _timeEnabled[2] = false;
        for (final t in med.times) {
          final hour = int.tryParse(t.split(':').first) ?? 9;
          if (hour < 18) {
            _timeEnabled[0] = true;
            _timeValues[0] = t;
          } else {
            _timeEnabled[2] = true;
            _timeValues[2] = t;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    _memoCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    final med = _med;
    if (!firebaseReady || med == null) {
      if (mounted) context.pop();
      return;
    }
    final times = <String>[];
    for (var i = 0; i < 4; i++) {
      if (_timeEnabled[i] && _timeValues[i].isNotEmpty) {
        times.add(_timeValues[i]);
      }
    }
    final updated = Medication(
      id: med.id,
      name: _nameCtrl.text.trim().isEmpty ? med.name : _nameCtrl.text.trim(),
      category: med.category,
      dosage: med.dosage,
      frequency: times.isEmpty ? med.frequency : times.length,
      times: times.isEmpty ? med.times : times,
      beforeMeal: med.beforeMeal,
      startDate: med.startDate,
      endDate: med.endDate,
      memo: _memoCtrl.text.trim(),
      isActive: _alarmOn ? true : med.isActive,
    );
    setState(() => _saving = true);
    final ok = await ref
        .read(medicationControllerProvider.notifier)
        .edit(med.id, updated);
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('수정되었어요.')));
      context.pop();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('수정에 실패했어요.')));
    }
  }

  Future<void> _delete() async {
    final med = _med;
    if (!firebaseReady || med == null) {
      if (mounted) context.pop();
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('약 삭제'),
        content: Text('‘${med.name}’ 을(를) 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(medicationControllerProvider.notifier).delete(med.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: '복약 수정',
        actions: [
          IconButton(
            onPressed: _delete,
            icon: Icon(Icons.delete_rounded,
                size: 24.sp, color: AppColors.primaryStrong),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 24.h),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                  child: Text(
                    '약 정보와 복용 일정을 수정할 수 있습니다.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                AppContent(
                  child: Column(
                    children: [
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '약 정보',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 132.w,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 148.h,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFBE3EA),
                                          borderRadius:
                                              BorderRadius.circular(16.r),
                                        ),
                                        child: Icon(Icons.medication_rounded,
                                            size: 54.sp,
                                            color: AppColors.primaryStrong),
                                      ),
                                      SizedBox(height: 10.h),
                                      OutlinedButton.icon(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: AppColors.primary,
                                              width: 1.5),
                                          minimumSize: Size(double.infinity, 40.h),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(999.r),
                                          ),
                                        ),
                                        icon: Icon(Icons.photo_camera_rounded,
                                            size: 15.sp,
                                            color: AppColors.primaryStrong),
                                        label: Text(
                                          '사진 변경',
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
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    children: [
                                      _FieldGroup(
                                        label: '약품명',
                                        required: true,
                                        child: _InputField(
                                            controller: _nameCtrl),
                                      ),
                                      _FieldGroup(
                                        label: '약품 종류',
                                        child: _DropdownField(
                                            value: '항생제',
                                            items: const [
                                          '항생제',
                                          '진통제',
                                          '영양제'
                                        ]),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _FieldGroup(
                                              label: '제형 / 색상',
                                              child: _DropdownField(
                                                  value: '정제',
                                                  items: const [
                                                '정제',
                                                '캡슐',
                                                '시럽'
                                              ]),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Expanded(
                                            child: _FieldGroup(
                                              label: ' ',
                                              child: _DropdownField(
                                                  value: '⚪ 흰색',
                                                  items: const [
                                                '⚪ 흰색',
                                                '🟡 노란색',
                                                '🔴 분홍색'
                                              ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _FieldGroup(
                                              label: '1회 복용량',
                                              required: true,
                                              child: _DropdownField(
                                                  value: '1 정',
                                                  items: const [
                                                '1 정',
                                                '2 정'
                                              ]),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Expanded(
                                            child: _FieldGroup(
                                              label: '함량',
                                              child: _InputField(
                                                controller: _amountCtrl,
                                                suffix: 'mg',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '성분/함량: Amoxicillin 250mg (아목시실린 250mg)',
                                        style: TextStyle(
                                          fontSize: 11.5.sp,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '복용 설정',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                _ModeCard(
                                  icon: Icons.event_available_rounded,
                                  name: '정해진 기간 복용',
                                  desc: '시작일부터 종료일까지\n지정하여 복용',
                                  active: _mode == 0,
                                  onTap: () => setState(() => _mode = 0),
                                ),
                                SizedBox(width: 10.w),
                                _ModeCard(
                                  icon: Icons.sync_rounded,
                                  name: '반복 복용',
                                  desc: '매일 또는 요일을\n선택하여 반복',
                                  active: _mode == 1,
                                  onTap: () => setState(() => _mode = 1),
                                ),
                                SizedBox(width: 10.w),
                                _ModeCard(
                                  icon: Icons.event_note_rounded,
                                  name: '필요 시 복용',
                                  desc: '필요할 때만\n복용하는 약',
                                  active: _mode == 2,
                                  onTap: () => setState(() => _mode = 2),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '복용 시간',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            _TimeRow(
                              slot: '☀️ 아침',
                              enabled: _timeEnabled[0],
                              time: _timeValues[0],
                              onToggle: (v) =>
                                  setState(() => _timeEnabled[0] = v),
                            ),
                            _TimeRow(
                              slot: '🌤️ 점심',
                              enabled: _timeEnabled[1],
                              time: _timeValues[1],
                              onToggle: (v) =>
                                  setState(() => _timeEnabled[1] = v),
                            ),
                            _TimeRow(
                              slot: '🌇 저녁',
                              enabled: _timeEnabled[2],
                              time: _timeValues[2],
                              onToggle: (v) =>
                                  setState(() => _timeEnabled[2] = v),
                            ),
                            _TimeRow(
                              slot: '취침 전',
                              slotIcon: Icons.bedtime_rounded,
                              enabled: _timeEnabled[3],
                              time: _timeValues[3],
                              onToggle: (v) =>
                                  setState(() => _timeEnabled[3] = v),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Icon(Icons.info_outline_rounded,
                                    size: 15.sp, color: const Color(0xFF3B82F6)),
                                SizedBox(width: 6.w),
                                Text(
                                  '복용 시간을 체크하면 알림이 설정됩니다.',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '복용 기간',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Expanded(
                                  child: _DateField(
                                      label: '시작일',
                                      value: '2024.06.02 (일)'),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.w),
                                  child: Text('–',
                                      style: TextStyle(
                                          color: AppColors.textSecondary)),
                                ),
                                Expanded(
                                  child: _DateField(
                                      label: '종료일',
                                      value: '2024.06.08 (토)'),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(999.r),
                                  ),
                                  child: Text(
                                    '총 7일',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primaryStrong,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '알림 설정',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Container(
                                  width: 46.w,
                                  height: 46.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.notifications_rounded,
                                      color: AppColors.primaryStrong,
                                      size: 22.sp),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '알림 사용',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        '복용 시간에 알림을 받습니다.',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch.adaptive(
                                  value: _alarmOn,
                                  onChanged: (v) =>
                                      setState(() => _alarmOn = v),
                                  activeTrackColor: AppColors.primaryStrong,
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Wrap(
                              spacing: 16.w,
                              runSpacing: 8.h,
                              children: [
                                for (var i = 0; i < 4; i++)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 20.w,
                                        height: 20.w,
                                        child: Checkbox(
                                          value: _alarmTypes[i],
                                          onChanged: (v) => setState(
                                              () => _alarmTypes[i] = v ?? false),
                                          activeColor:
                                              AppColors.primaryStrong,
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        [
                                          '앱 알림',
                                          '푸시 알림',
                                          '이메일',
                                          '문자 메시지'
                                        ][i],
                                        style: TextStyle(fontSize: 13.sp),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                                children: [
                                  const TextSpan(text: '메모 '),
                                  TextSpan(
                                    text: '(선택사항)',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),
                            TextField(
                              controller: _memoCtrl,
                              maxLines: 4,
                              maxLength: 100,
                              decoration: InputDecoration(
                                hintText:
                                    '메모를 입력하세요 (예: 식후 복용, 물과 함께 복용 등)',
                                filled: true,
                                fillColor: AppColors.background,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: const BorderSide(
                                      color: AppColors.border),
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
          Container(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: SecondaryButton(
                    label: '취소',
                    onPressed: () => context.pop(),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  flex: 12,
                  child: PrimaryButton(
                    label: _saving ? '저장 중…' : '저장',
                    onPressed: _saving ? null : _save,
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

class _FieldGroup extends StatelessWidget {
  const _FieldGroup({
    required this.label,
    required this.child,
    this.required = false,
  });

  final String label;
  final Widget child;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.trim().isNotEmpty)
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                children: [
                  TextSpan(text: label),
                  if (required)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppColors.primaryStrong),
                    ),
                ],
              ),
            ),
          if (label.trim().isNotEmpty) SizedBox(height: 6.h),
          child,
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({required this.controller, this.suffix});

  final TextEditingController controller;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(fontSize: 14.sp),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (suffix != null)
            Text(suffix!,
                style: TextStyle(
                    fontSize: 13.sp, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({required this.value, required this.items});

  final String value;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.name,
    required this.desc,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String name;
  final String desc;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFFFF0F4) : AppColors.surface,
            border: Border.all(
              color: active ? AppColors.primaryStrong : AppColors.border,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 26.sp,
                  color: active
                      ? AppColors.primaryStrong
                      : AppColors.textSecondary),
              SizedBox(height: 8.h),
              Text(name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w800,
                    color: active
                        ? AppColors.primaryStrong
                        : AppColors.textPrimary,
                  )),
              SizedBox(height: 6.h),
              Text(desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({
    required this.slot,
    this.slotIcon,
    required this.enabled,
    required this.time,
    required this.onToggle,
  });

  final String slot;
  final IconData? slotIcon;
  final bool enabled;
  final String time;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 82.w,
            child: Row(
              children: [
                if (slotIcon != null)
                  Icon(slotIcon, size: 16.sp, color: const Color(0xFF3B82F6))
                else
                  Text(slot.split(' ').first, style: TextStyle(fontSize: 14.sp)),
                if (slotIcon != null) ...[
                  SizedBox(width: 4.w),
                  Text('취침 전',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w600)),
                ] else
                  SizedBox(width: 4.w),
                if (slotIcon == null)
                  Expanded(
                    child: Text(
                      slot.split(' ').skip(1).join(' '),
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            width: 22.w,
            height: 22.w,
            child: Checkbox(
              value: enabled,
              onChanged: (v) => onToggle(v ?? false),
              activeColor: AppColors.primaryStrong,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            flex: 14,
            child: Opacity(
              opacity: enabled ? 1 : 0.45,
              child: Container(
                height: 46.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        enabled ? time : '시간 선택',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                    Icon(Icons.schedule_rounded, size: 18.sp),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Opacity(
              opacity: enabled ? 1 : 0.45,
              child: Container(
                height: 46.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text('1 정', style: TextStyle(fontSize: 14.sp)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13.sp, color: AppColors.textSecondary)),
          SizedBox(width: 6.w),
          Icon(Icons.calendar_month_rounded, size: 18.sp),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(value,
                style: TextStyle(fontSize: 13.sp),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
