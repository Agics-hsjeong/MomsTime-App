import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';

/// 디자인 토큰이 제대로 반영됐는지 확인하는 임시 쇼케이스 화면.
///
/// 실제 기능 화면(Splash/Home 등)이 준비되면 대체됩니다. (v0.4.x)
class DesignShowcasePage extends StatelessWidget {
  const DesignShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              children: [
                const SizedBox(height: AppSpacing.x3),
                Text("Mom's Time",
                    textAlign: TextAlign.center,
                    style: AppTypography.display
                        .copyWith(color: AppColors.primaryStrong)),
                const SizedBox(height: AppSpacing.sm),
                Text('엄마의 건강한 하루를 위한 동반자',
                    textAlign: TextAlign.center, style: AppTypography.caption),
                const SizedBox(height: AppSpacing.x3),

                // 컬러 토큰
                Text('Colors', style: AppTypography.subtitle),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: const [
                    _Swatch('primary', AppColors.primary),
                    _Swatch('strong', AppColors.primaryStrong),
                    _Swatch('light', AppColors.primaryLight),
                    _Swatch('AI', AppColors.aiPurple),
                    _Swatch('success', AppColors.success),
                    _Swatch('warning', AppColors.warning),
                    _Swatch('error', AppColors.error),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),

                // 카드 + 버튼
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('오늘의 케어', style: AppTypography.subtitle),
                        const SizedBox(height: AppSpacing.sm),
                        Text('디자인 시스템이 정상 적용됐어요.',
                            style: AppTypography.caption),
                        const SizedBox(height: AppSpacing.lg),
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius:
                                BorderRadius.circular(AppRadius.button),
                          ),
                          alignment: Alignment.center,
                          child: const Text('시작하기',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.chip),
            border: Border.all(color: AppColors.border),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.small),
      ],
    );
  }
}
