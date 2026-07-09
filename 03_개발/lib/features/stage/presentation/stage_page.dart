import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/app_user.dart';

/// 임신 단계 선택 (퍼블리싱 04_stage).
class StagePage extends ConsumerStatefulWidget {
  const StagePage({super.key});

  @override
  ConsumerState<StagePage> createState() => _StagePageState();
}

class _StagePageState extends ConsumerState<StagePage> {
  int _selected = 0;
  bool _saving = false;
  bool _inited = false;

  static const _stageKeys = [
    PregnancyStage.preparing,
    PregnancyStage.pregnant,
    PregnancyStage.postpartum,
  ];

  Future<void> _complete() async {
    if (firebaseReady) {
      final uid = ref.read(authStateProvider).value?.uid;
      if (uid != null) {
        setState(() => _saving = true);
        try {
          await ref.read(userRepositoryProvider).update(
            uid,
            {
              'pregnancyStage': _stageKeys[_selected].key,
              'stageCompleted': true,
            },
          );
        } catch (_) {
          // 저장 실패해도 진행.
        }
        if (mounted) setState(() => _saving = false);
      }
    }
    if (mounted) context.go(Routes.home);
  }

  static const _stages = <(IconData, String, String, bool)>[
    (
      Icons.self_improvement_rounded,
      '임신 준비 중',
      '건강한 임신을 위한 준비와\n영양 관리를 도와드려요.',
      true
    ),
    (
      Icons.pregnant_woman_rounded,
      '임신 중',
      '태아와 엄마의 건강을 위한\n맞춤 케어를 제공해드려요.',
      false
    ),
    (
      Icons.child_friendly_rounded,
      '출산 후',
      '산후 회복과 육아를 위한\n건강 관리를 도와드려요.',
      false
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentUserProfileProvider).value;
    if (!_inited && profile != null) {
      final idx = _stageKeys.indexOf(profile.pregnancyStage);
      if (idx >= 0) _selected = idx;
      _inited = true;
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: '',
        onBack: () =>
            context.canPop() ? context.pop() : context.go(Routes.login),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          children: [
            SizedBox(height: 8.h),
            Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: '현재 '),
                    TextSpan(
                      text: '단계',
                      style: TextStyle(color: AppColors.primaryStrong),
                    ),
                    const TextSpan(text: '를 선택해주세요'),
                  ],
                ),
                style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w800),
              ),
            ),
            SizedBox(height: 12.h),
            Center(
              child: Text(
                '선택한 단계에 맞춰 맞춤 케어를 제공해드려요.\n언제든지 마이페이지에서 변경할 수 있어요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            for (var i = 0; i < _stages.length; i++) ...[
              _StageCard(
                data: _stages[i],
                selected: _selected == i,
                onTap: () => setState(() => _selected = i),
              ),
              SizedBox(height: 16.h),
            ],
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFBEAF0),
                borderRadius: BorderRadius.circular(AppSizes.radiusCard),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.lightbulb_rounded,
                        color: AppColors.warning, size: 20.sp),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '정확한 단계 선택이 중요해요!',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '선택하신 단계에 맞는 정보와 알림이 제공됩니다.\n나의 건강한 여정을 함께 응원할게요 💗',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
          child: PrimaryButton(
            label: _saving ? '저장 중…' : '선택 완료',
            onPressed: _saving ? null : _complete,
          ),
        ),
      ),
    );
  }
}

class _StageCard extends StatelessWidget {
  const _StageCard({
    required this.data,
    required this.selected,
    required this.onTap,
  });
  final (IconData, String, String, bool) data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF0F4) : AppColors.surface,
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
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
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Icon(data.$1, size: 36.sp, color: AppColors.primaryStrong),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        data.$2,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: selected
                              ? AppColors.primaryStrong
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (data.$4) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            '추천',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryStrong,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    data.$3,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded,
                  color: AppColors.primaryStrong, size: 24.sp)
            else
              Icon(Icons.chevron_right_rounded,
                  color: AppColors.textDisabled, size: 24.sp),
          ],
        ),
      ),
    );
  }
}
