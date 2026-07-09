import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/status_chip.dart';
import '../application/medication_providers.dart';
import '../domain/medication.dart';
import '../domain/medication_register_data.dart';
import 'widgets/register_scaffold.dart';

/// 약 등록 4단계 위저드 — 퍼블리싱 07_register 1~4.
class MedicationRegisterPage extends ConsumerStatefulWidget {
  const MedicationRegisterPage({super.key, this.initialStep = 0});

  final int initialStep;

  @override
  ConsumerState<MedicationRegisterPage> createState() =>
      _MedicationRegisterPageState();
}

class _MedicationRegisterPageState
    extends ConsumerState<MedicationRegisterPage> {
  late int _step = widget.initialStep;
  final _data = MedicationRegisterData();
  final _nameCtrl = TextEditingController();
  final _makerCtrl = TextEditingController();
  final _memoCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _makerCtrl.dispose();
    _memoCtrl.dispose();
    super.dispose();
  }

  DateTime? _parseDot(String s) {
    final p = s.split('.');
    if (p.length != 3) return null;
    final y = int.tryParse(p[0]);
    final m = int.tryParse(p[1]);
    final d = int.tryParse(p[2]);
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d);
  }

  Medication _buildMedication() {
    final times = <String>[];
    if (_data.morningEnabled) times.add(_data.morningTime);
    if (_data.eveningEnabled) times.add(_data.eveningTime);
    return Medication(
      id: '',
      name: _data.name.isEmpty ? '이름 없는 약' : _data.name,
      category: _data.displayType == '영양제' ? 'supplement' : 'medicine',
      dosage: '${_data.doseAmount}${_data.doseUnit}',
      frequency: times.isEmpty ? 1 : times.length,
      times: times,
      beforeMeal: false,
      startDate: _parseDot(_data.periodStart) ?? DateTime.now(),
      endDate: _parseDot(_data.periodEnd),
      memo: _data.memo,
      isActive: true,
    );
  }

  Future<void> _next() async {
    if (_saving) return;
    if (_step < 3) {
      setState(() => _step++);
      return;
    }
    final name = _data.name.isEmpty ? '이름 없는 약' : _data.name;

    if (!firebaseReady) {
      _showDone(name);
      return;
    }

    setState(() => _saving = true);
    final id = await ref
        .read(medicationControllerProvider.notifier)
        .add(_buildMedication());
    if (!mounted) return;
    setState(() => _saving = false);
    if (id == null) {
      final err = ref.read(medicationControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err != null ? '등록 실패: $err' : '등록에 실패했어요.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    _showDone(name);
  }

  void _showDone(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name 등록이 완료되었어요!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.go(Routes.home);
  }

  void _prev() => setState(() => _step = (_step - 1).clamp(0, 3));

  Future<void> _openOcr() async {
    final result = await context.push<Map<String, String>>(Routes.medicationOcr);
    if (result != null && mounted) {
      _data.applyOcr(
        drugName: result['name'] ?? '',
        drugType: result['type'] ?? '영양제',
        maker: result['maker'],
      );
      _nameCtrl.text = _data.name;
      _makerCtrl.text = _data.manufacturer;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return RegisterScaffold(
      step: _step,
      showPrev: _step > 0,
      showDraft: _step < 3,
      nextLabel: _step == 3 ? '등록 완료' : '다음',
      nextIcon: _step == 3 ? Icons.check_circle_rounded : Icons.chevron_right_rounded,
      onNext: _next,
      onPrev: _prev,
      body: switch (_step) {
        0 => _StepBasic(
            data: _data,
            nameCtrl: _nameCtrl,
            makerCtrl: _makerCtrl,
            onOcr: _openOcr,
            onChanged: () => setState(() {}),
          ),
        1 => _StepIntake(data: _data, memoCtrl: _memoCtrl),
        2 => _StepAlarm(data: _data),
        _ => _StepConfirm(data: _data, onEditStep: (s) => setState(() => _step = s)),
      },
    );
  }
}

class _StepBasic extends StatelessWidget {
  const _StepBasic({
    required this.data,
    required this.nameCtrl,
    required this.makerCtrl,
    required this.onOcr,
    required this.onChanged,
  });

  final MedicationRegisterData data;
  final TextEditingController nameCtrl;
  final TextEditingController makerCtrl;
  final VoidCallback onOcr;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Text('🤖', style: TextStyle(fontSize: 48.sp)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '약 사진으로 등록하기 (OCR)',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      const StatusChip(label: '추천'),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '약 봉투나 박스, 약품 정보를 촬영하면\nAI가 정보를 자동으로 인식해요.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: onOcr,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 26.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7F9),
                        borderRadius: BorderRadius.circular(AppSizes.radiusButton),
                        border: Border.all(color: AppColors.primary, width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_camera_rounded,
                              size: 36.sp, color: AppColors.primaryStrong),
                          SizedBox(width: 14.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '사진 촬영하기',
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryStrong,
                                ),
                              ),
                              Text(
                                '또는 이미지 선택',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          size: 15.sp, color: AppColors.textDisabled),
                      SizedBox(width: 6.w),
                      Text(
                        '선명하게 촬영할수록 정확도가 높아져요.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const _FormTitle('기본 정보'),
        AppCard(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
          child: Column(
            children: [
              _FormRow(
                label: '약 이름',
                required: true,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nameCtrl,
                        onChanged: (v) => data.name = v,
                        style: TextStyle(fontSize: 14.sp),
                        decoration: InputDecoration(
                          hintText: '약 이름을 입력해주세요',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textDisabled,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onOcr,
                      child: Text(
                        'OCR 사용',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryStrong,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _FormRow(
                label: '약 종류',
                required: true,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: MedicationRegisterData.typeOptions.contains(data.type)
                        ? data.type
                        : null,
                    hint: Text('선택해주세요',
                        style: TextStyle(fontSize: 14.sp)),
                    isExpanded: true,
                    style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
                    items: [
                      for (final t in MedicationRegisterData.typeOptions)
                        DropdownMenuItem(value: t, child: Text(t)),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        data.type = v;
                        onChanged();
                      }
                    },
                  ),
                ),
              ),
              _FormRow(
                label: '제조사',
                child: TextField(
                  controller: makerCtrl,
                  onChanged: (v) => data.manufacturer = v,
                  style: TextStyle(fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: '제조사를 입력해주세요 (선택)',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textDisabled,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              _FormRow(
                label: '약 이미지',
                child: Row(
                  children: [
                    Container(
                      width: 96.w,
                      height: 96.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border, width: 1.5),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_rounded,
                              color: AppColors.textDisabled, size: 26.sp),
                          Text(
                            '이미지 추가',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textDisabled,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        '약 봉투나 약 박스 이미지를 추가하면 관리하기 쉬워요.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                          height: 1.6,
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
    );
  }
}

class _StepIntake extends StatefulWidget {
  const _StepIntake({required this.data, required this.memoCtrl});

  final MedicationRegisterData data;
  final TextEditingController memoCtrl;

  @override
  State<_StepIntake> createState() => _StepIntakeState();
}

class _StepIntakeState extends State<_StepIntake> {
  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FormTitle('복용 정보'),
        AppCard(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
          child: Column(
            children: [
              _FormRow(
                label: '복용 방법',
                required: true,
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    for (final m in MedicationRegisterData.intakeMethods)
                      _OptChip(
                        label: m,
                        selected: data.intakeMethod == m,
                        onTap: () => setState(() => data.intakeMethod = m),
                      ),
                  ],
                ),
              ),
              _FormRow(
                label: '1회 복용량',
                required: true,
                child: Row(
                  children: [
                    _QtyControl(
                      value: data.doseAmount,
                      onChanged: (v) => setState(() => data.doseAmount = v),
                    ),
                    SizedBox(width: 8.w),
                    SizedBox(
                      width: 110.w,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: data.doseUnit,
                          isExpanded: true,
                          style: TextStyle(fontSize: 14.sp),
                          items: [
                            for (final u in MedicationRegisterData.doseUnits)
                              DropdownMenuItem(value: u, child: Text(u)),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => data.doseUnit = v);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _FormRow(
                label: '복용 주기',
                required: true,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: data.frequency,
                    isExpanded: true,
                    style: TextStyle(fontSize: 14.sp),
                    items: [
                      for (final f in MedicationRegisterData.frequencies)
                        DropdownMenuItem(value: f, child: Text(f)),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => data.frequency = v);
                    },
                  ),
                ),
              ),
              _FormRow(
                label: '복용 기간',
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.periodStart,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text('–',
                        style: TextStyle(
                            fontSize: 14.sp, color: AppColors.textSecondary)),
                    Expanded(
                      child: Text(
                        data.periodEnd,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const _FormTitle('메모 (선택)'),
        TextField(
          controller: widget.memoCtrl,
          maxLines: 4,
          maxLength: 100,
          onChanged: (v) => data.memo = v,
          style: TextStyle(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: '메모를 입력해주세요 (예: 식후 30분, 물과 함께)',
            hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.textDisabled),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusInput),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
      ],
    );
  }
}

class _StepAlarm extends StatefulWidget {
  const _StepAlarm({required this.data});
  final MedicationRegisterData data;

  @override
  State<_StepAlarm> createState() => _StepAlarmState();
}

class _StepAlarmState extends State<_StepAlarm> {
  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.notifications_rounded,
                    color: AppColors.primaryStrong, size: 24.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '복약 알림 받기',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '복용 시간에 맞춰 알려드릴게요.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: data.alarmEnabled,
                activeThumbColor: AppColors.primaryStrong,
                onChanged: (v) => setState(() => data.alarmEnabled = v),
              ),
            ],
          ),
        ),
        const _FormTitle('복용 시간'),
        AppCard(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
          child: Column(
            children: [
              _TimeRow(
                slot: '☀️ 아침',
                enabled: data.morningEnabled,
                time: data.morningTime,
                onToggle: (v) => setState(() => data.morningEnabled = v),
              ),
              _TimeRow(
                slot: '🌇 저녁',
                enabled: data.eveningEnabled,
                time: data.eveningTime,
                onToggle: (v) => setState(() => data.eveningEnabled = v),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 16.sp, color: AppColors.textDisabled),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      '복용 시간을 체크하면 해당 시간에 알림이 울려요.',
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
        const _FormTitle('알림 옵션'),
        AppCard(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
          child: Column(
            children: [
              _FormRow(
                label: '복용 전 알림',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: data.beforeAlarm,
                    isExpanded: true,
                    style: TextStyle(fontSize: 14.sp),
                    items: const [
                      DropdownMenuItem(value: '정시', child: Text('정시')),
                      DropdownMenuItem(value: '10분 전', child: Text('10분 전')),
                      DropdownMenuItem(value: '30분 전', child: Text('30분 전')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => data.beforeAlarm = v);
                    },
                  ),
                ),
              ),
              _FormRow(
                label: '재알림',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: data.reAlarm,
                    isExpanded: true,
                    style: TextStyle(fontSize: 14.sp),
                    items: const [
                      DropdownMenuItem(value: '안 함', child: Text('안 함')),
                      DropdownMenuItem(value: '10분 후', child: Text('10분 후')),
                      DropdownMenuItem(value: '30분 후', child: Text('30분 후')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => data.reAlarm = v);
                    },
                  ),
                ),
              ),
              _FormRow(
                label: '알림 방식',
                child: Wrap(
                  spacing: 12.w,
                  children: [
                    _CheckLabel(
                      label: '앱 알림',
                      value: data.appNotification,
                      onChanged: (v) => setState(() => data.appNotification = v),
                    ),
                    _CheckLabel(
                      label: '푸시 알림',
                      value: data.pushNotification,
                      onChanged: (v) => setState(() => data.pushNotification = v),
                    ),
                    _CheckLabel(
                      label: '이메일',
                      value: data.emailNotification,
                      onChanged: (v) => setState(() => data.emailNotification = v),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepConfirm extends StatelessWidget {
  const _StepConfirm({required this.data, required this.onEditStep});

  final MedicationRegisterData data;
  final ValueChanged<int> onEditStep;

  String get _name => data.name.isEmpty ? '철분제' : data.name;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Row(
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(Icons.medication_rounded,
                    color: AppColors.primaryStrong, size: 32.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        StatusChip(label: data.displayType),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '아래 내용으로 등록할게요. 맞는지 확인해주세요.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        AppCard(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              _SumBlock(
                title: '기본 정보',
                onEdit: () => onEditStep(0),
                rows: [
                  ('약 이름', _name),
                  ('약 종류', data.displayType),
                  ('제조사', data.manufacturer.isEmpty ? '훼로바' : data.manufacturer),
                ],
              ),
              Divider(height: 28.h, color: AppColors.divider),
              _SumBlock(
                title: '복용 정보',
                onEdit: () => onEditStep(1),
                rows: [
                  ('복용 방법', data.intakeMethod),
                  ('1회 복용량', '${data.doseAmount}${data.doseUnit}'),
                  ('복용 주기', data.frequency),
                  ('복용 기간', '${data.periodStart} ~ ${data.periodEnd.split('.').last}'),
                ],
              ),
              Divider(height: 28.h, color: AppColors.divider),
              _SumBlock(
                title: '알림 설정',
                onEdit: () => onEditStep(2),
                rows: [
                  ('복용 시간', data.timesSummary),
                  ('복용 전 알림', data.beforeAlarm),
                  ('알림 방식', data.alarmMethods),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FormTitle extends StatelessWidget {
  const _FormTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 28.h, 0, 12.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _FormRow extends StatelessWidget {
  const _FormRow({
    required this.label,
    required this.child,
    this.required = false,
  });

  final String label;
  final Widget child;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88.w,
            child: Text.rich(
              TextSpan(
                text: label,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                children: [
                  if (required)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppColors.primaryStrong),
                    ),
                ],
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _OptChip extends StatelessWidget {
  const _OptChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected ? AppColors.primaryStrong : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.primaryStrong : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _QtyControl extends StatelessWidget {
  const _QtyControl({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => onChanged((value - 1).clamp(1, 99)),
            icon: Icon(Icons.remove_rounded, size: 20.sp),
          ),
          SizedBox(
            width: 32.w,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: () => onChanged(value + 1),
            icon: Icon(Icons.add_rounded, size: 20.sp),
          ),
        ],
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({
    required this.slot,
    required this.enabled,
    required this.time,
    required this.onToggle,
  });

  final String slot;
  final bool enabled;
  final String time;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          SizedBox(
            width: 72.w,
            child: Text(
              slot,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 24.w,
            height: 24.w,
            child: Checkbox(
              value: enabled,
              activeColor: AppColors.primaryStrong,
              onChanged: (v) => onToggle(v ?? false),
            ),
          ),
          Expanded(
            child: Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: enabled ? AppColors.surface : AppColors.divider,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      enabled ? time : '시간 선택',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: enabled
                            ? AppColors.textPrimary
                            : AppColors.textDisabled,
                      ),
                    ),
                  ),
                  Icon(Icons.schedule_rounded,
                      size: 18.sp, color: AppColors.textDisabled),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckLabel extends StatelessWidget {
  const _CheckLabel({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 24.w,
          height: 24.w,
          child: Checkbox(
            value: value,
            activeColor: AppColors.primaryStrong,
            onChanged: (v) => onChanged(v ?? false),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 13.sp)),
      ],
    );
  }
}

class _SumBlock extends StatelessWidget {
  const _SumBlock({
    required this.title,
    required this.onEdit,
    required this.rows,
  });

  final String title;
  final VoidCallback onEdit;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onEdit,
              child: Row(
                children: [
                  Icon(Icons.edit_rounded,
                      size: 16.sp, color: AppColors.primaryStrong),
                  Text(
                    ' 수정',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryStrong,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        for (final row in rows)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 88.w,
                  child: Text(
                    row.$1,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    row.$2,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
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
