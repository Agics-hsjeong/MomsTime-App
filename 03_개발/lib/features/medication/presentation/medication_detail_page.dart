import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_tabs.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/status_chip.dart';
import '../application/medication_providers.dart';
import '../domain/medication.dart';

/// 복약 상세 — 퍼블리싱 16_medication_detail.html
class MedicationDetailPage extends ConsumerStatefulWidget {
  const MedicationDetailPage({super.key});

  @override
  ConsumerState<MedicationDetailPage> createState() =>
      _MedicationDetailPageState();
}

class _MedicationDetailPageState extends ConsumerState<MedicationDetailPage> {
  int _tab = 0;

  static const _tabs = ['기본 정보', '복약 기록', '주의사항', '약물 정보'];

  Future<void> _showMenu(Medication? med) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('수정하기'),
              onTap: () => Navigator.pop(ctx, 'edit'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded, color: Colors.red),
              title: const Text('삭제하기',
                  style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(ctx, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (action == 'edit') {
      if (mounted) context.push(Routes.medicationEdit);
    } else if (action == 'delete') {
      await _confirmDelete(med);
    }
  }

  Future<void> _confirmDelete(Medication? med) async {
    if (med == null) {
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
    final done =
        await ref.read(medicationControllerProvider.notifier).delete(med.id);
    if (!mounted) return;
    if (done) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('삭제되었어요.')),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('삭제에 실패했어요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final med = ref.watch(selectedMedicationProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: '복약 상세',
        actions: [
          IconButton(
            onPressed: () => _showMenu(med),
            icon: Icon(Icons.more_vert_rounded, size: 24.sp),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 24.h),
              children: [
                _DrugHero(med: med),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DoseGrid(med: med),
                      SizedBox(height: 24.h),
                      AppTabs(
                        labels: _tabs,
                        index: _tab,
                        onChanged: (i) => setState(() => _tab = i),
                      ),
                      SizedBox(height: 16.h),
                      _TabPanel(index: _tab),
                      SizedBox(height: 16.h),
                      const _NextDoseCard(),
                      SizedBox(height: 16.h),
                      const _PhotoMemoCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _DetailCta(
            onEdit: () => context.push(Routes.medicationEdit),
            onDelete: () => _confirmDelete(med),
          ),
        ],
      ),
    );
  }
}

class _DrugHero extends StatelessWidget {
  const _DrugHero({this.med});
  final Medication? med;

  @override
  Widget build(BuildContext context) {
    final name = med?.name ?? '아목시실린정 250mg';
    final category = med == null
        ? '항생제'
        : (med!.isSupplement ? '영양제' : '복용약');
    final desc = med?.memo.isNotEmpty == true
        ? med!.memo
        : '복용 정보를 확인하세요.';
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 148.w,
            height: 186.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFBE3EA),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(Icons.medication_rounded,
                size: 64.sp, color: AppColors.primaryStrong),
          ),
          SizedBox(width: 18.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    '처방약',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryStrong,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Icon(Icons.star_outline_rounded,
                        color: AppColors.textDisabled, size: 22.sp),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryStrong,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                Divider(height: 24.h, color: AppColors.divider),
                const Row(
                  children: [
                    _DrugMeta(
                      icon: Icons.calendar_month_rounded,
                      label: '처방일',
                      value: '2024.06.02',
                    ),
                    SizedBox(width: 16),
                    _DrugMeta(emoji: '🧑‍⚕️', label: '처방의', value: '김하나 내과'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrugMeta extends StatelessWidget {
  const _DrugMeta({
    this.icon,
    this.emoji,
    required this.label,
    required this.value,
  });

  final IconData? icon;
  final String? emoji;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38.w,
          height: 38.w,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12.r),
          ),
          alignment: Alignment.center,
          child: icon != null
              ? Icon(icon, size: 18.sp, color: AppColors.primaryStrong)
              : Text(emoji!, style: TextStyle(fontSize: 18.sp)),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}

class _DoseGrid extends StatelessWidget {
  const _DoseGrid({this.med});
  final Medication? med;

  @override
  Widget build(BuildContext context) {
    final times = med == null
        ? '아침 · 저녁'
        : (med!.times.isEmpty ? '-' : med!.times.join(' · '));
    final dosage = med?.dosage.isNotEmpty == true ? med!.dosage : '1정';
    final freq = med?.frequency ?? 2;
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFDEFF3),
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      ),
      child: Row(
        children: [
          _DoseItem(
            icon: Icons.schedule_rounded,
            head: '복용 시간',
            value: times,
            sub: med?.beforeMeal == true ? '식전' : '식후',
          ),
          _DoseItem(
            icon: Icons.medication_rounded,
            head: '1회 복용량',
            value: dosage,
            sub: med?.isSupplement == true ? '(영양제)' : '(복용약)',
            showBorder: true,
          ),
          _DoseItem(
            icon: Icons.sync_rounded,
            head: '하루 복용',
            value: '$freq',
            unit: '회',
            sub: '(매일)',
            showBorder: true,
          ),
          _DoseItem(
            icon: Icons.event_rounded,
            head: '상태',
            value: med?.isActive == false ? '중지' : '복용중',
            sub: '',
            showBorder: true,
          ),
        ],
      ),
    );
  }
}

class _DoseItem extends StatelessWidget {
  const _DoseItem({
    required this.icon,
    required this.head,
    required this.value,
    this.unit,
    required this.sub,
    this.showBorder = false,
  });

  final IconData icon;
  final String head;
  final String value;
  final String? unit;
  final String sub;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DecoratedBox(
        decoration: showBorder
            ? const BoxDecoration(
                border: Border(left: BorderSide(color: Color(0xFFF2CFDC))),
              )
            : const BoxDecoration(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 15.sp, color: AppColors.primaryStrong),
                SizedBox(width: 4.w),
                Flexible(
                  child: Text(
                    head,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
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
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              sub,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.5.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabPanel extends StatelessWidget {
  const _TabPanel({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return switch (index) {
      0 => const _BasicInfoPanel(),
      1 => const _RecordPanel(),
      2 => const _CautionPanel(),
      _ => const _DrugInfoPanel(),
    };
  }
}

class _BasicInfoPanel extends StatelessWidget {
  const _BasicInfoPanel();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      child: const Column(
        children: [
          _InfoRow(
            bg: Color(0xFFFDEFF3),
            icon: Icons.ads_click_rounded,
            label: '효능 · 효과',
            value: '중이염, 인후염, 피부 감염 등',
          ),
          _InfoRow(
            bg: Color(0xFFFDF3E4),
            icon: Icons.science_rounded,
            label: '성분 / 함량',
            value: 'Amoxicillin 250mg (아목시실린 250mg)',
          ),
          _InfoRow(
            bg: Color(0xFFE9EFFC),
            icon: Icons.medication_rounded,
            label: '제형 / 색상',
            value: '백색의 타원형 정제',
          ),
          _InfoRow(
            bg: AppColors.aiPurpleLight,
            icon: Icons.sanitizer_rounded,
            iconColor: Color(0xFF7C5CD6),
            label: '보관 방법',
            value: '실온(1~30℃) 보관, 직사광선을 피하세요.',
          ),
          _InfoRow(
            bg: Color(0xFFE4F5F2),
            icon: Icons.factory_rounded,
            label: '제조 / 판매',
            value: 'OO제약  /  대한민국',
          ),
        ],
      ),
    );
  }
}

class _RecordPanel extends StatelessWidget {
  const _RecordPanel();

  static const _logs = [
    ('5.24 (금)', '저녁 식후 · 오후 7:30', '복용 · 19:31', true),
    ('5.24 (금)', '아침 식후 · 오전 9:00', '복용 · 09:02', true),
    ('5.23 (목)', '저녁 식후 · 오후 7:30', '복용 · 19:40', true),
    ('5.23 (목)', '아침 식후 · 오전 9:00', '미복용', false),
    ('5.22 (수)', '저녁 식후 · 오후 7:30', '복용 · 19:25', true),
  ];

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 6.h),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '최근 복약 기록',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              const StatusChip(label: '이번 주 6 / 7'),
            ],
          ),
          SizedBox(height: 8.h),
          for (var i = 0; i < _logs.length; i++) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 13.h),
              child: Row(
                children: [
                  SizedBox(
                    width: 74.w,
                    child: Text(
                      _logs[i].$1,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _logs[i].$2,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _logs[i].$4
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        size: 16.sp,
                        color:
                            _logs[i].$4 ? AppColors.success : AppColors.error,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _logs[i].$3,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: _logs[i].$4
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (i < _logs.length - 1)
              const Divider(height: 1, color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _CautionPanel extends StatelessWidget {
  const _CautionPanel();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: const Color(0xFFEAF1FC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '복용 시 주의사항',
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.verified_user_rounded,
                  size: 40.sp, color: const Color(0xFF7C5CD6)),
              SizedBox(width: 14.w),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Bullet('항생제는 의사의 지시에 따라 끝까지 복용해야 합니다.'),
                    _Bullet('복용 중 설사, 발진, 알레르기 증상이 나타나면 복용을 중단하고 의사와 상담하세요.'),
                    _Bullet('다른 약과 함께 복용할 경우 약사 또는 의사와 상담하세요.'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(color: const Color(0xFF3B82F6), fontSize: 12.5.sp),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5.sp,
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

class _DrugInfoPanel extends StatelessWidget {
  const _DrugInfoPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '임부 안전 등급',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F7EA),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.verified_rounded,
                            size: 16.sp, color: AppColors.success),
                        SizedBox(width: 5.w),
                        Text(
                          '등급 B',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                '동물시험에서 태아에 대한 위험성이 확인되지 않았어요. 다만 임신 중에는 반드시 의사·약사와 상담한 뒤 복용하세요.',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        AppCard(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
          child: const Column(
            children: [
              _InfoRow(
                bg: Color(0xFFFDEFF3),
                icon: Icons.description_rounded,
                label: '용법·용량',
                value: '1일 2회, 1회 1정 · 식후 30분',
                showChevron: false,
              ),
              _InfoRow(
                bg: Color(0xFFFDF3E4),
                icon: Icons.warning_rounded,
                iconColor: AppColors.warning,
                label: '주요 부작용',
                value: '설사, 발진, 위장 장애 등',
                showChevron: false,
              ),
              _InfoRow(
                bg: Color(0xFFE9EFFC),
                icon: Icons.sync_problem_rounded,
                iconColor: Color(0xFF3B82F6),
                label: '상호작용',
                value: '일부 피임약·항응고제와 병용 주의',
                showChevron: false,
              ),
              _InfoRow(
                bg: Color(0xFFFDE8E8),
                icon: Icons.block_rounded,
                iconColor: AppColors.error,
                label: '금기',
                value: '페니실린계 알레르기 환자',
                showChevron: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.bg,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = AppColors.primaryStrong,
    this.showChevron = true,
  });

  final Color bg;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 18.sp, color: iconColor),
          ),
          SizedBox(width: 12.w),
          SizedBox(
            width: 84.w,
            child: Text(
              label,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          if (showChevron)
            Icon(Icons.chevron_right_rounded,
                color: AppColors.textDisabled, size: 20.sp),
        ],
      ),
    );
  }
}

class _NextDoseCard extends StatelessWidget {
  const _NextDoseCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: const Color(0xFFFDEFF3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '다음 복용 알림',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '저녁 식후',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '오후 7:30',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                width: 1,
                height: 72.h,
                color: const Color(0xFFF2CFDC),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '남은 복용 횟수',
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
                            text: '8 ',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextSpan(
                            text: '회',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '(4일 남음)',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 8.h),
                ),
                icon: Icon(Icons.notifications_rounded,
                    size: 17.sp, color: AppColors.primaryStrong),
                label: Text(
                  '알림\n수정',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryStrong,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhotoMemoCard extends StatelessWidget {
  const _PhotoMemoCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '사진 메모',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                '전체 보기',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryStrong,
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  size: 16.sp, color: AppColors.primaryStrong),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                width: 96.w,
                height: 96.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2E7DC),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(Icons.medication_rounded,
                    size: 38.sp, color: AppColors.primaryStrong),
              ),
              SizedBox(width: 10.w),
              Container(
                width: 96.w,
                height: 96.w,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded,
                        color: AppColors.textDisabled, size: 26.sp),
                    Text(
                      '사진 추가',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailCta extends StatelessWidget {
  const _DetailCta({required this.onEdit, required this.onDelete});
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onEdit,
              style: OutlinedButton.styleFrom(
                minimumSize: Size.fromHeight(52.h),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusButton),
                ),
              ),
              icon: Icon(Icons.edit_note_rounded, size: 18.sp),
              label: Text(
                '복약 계획 수정',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onDelete,
              style: OutlinedButton.styleFrom(
                minimumSize: Size.fromHeight(52.h),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusButton),
                ),
              ),
              icon: Icon(Icons.delete_outline_rounded, size: 18.sp),
              label: Text(
                '복약 삭제',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: SizedBox(
              height: 52.h,
              child: PrimaryButton(
                label: '알림 설정',
                icon: Icons.notifications_rounded,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
