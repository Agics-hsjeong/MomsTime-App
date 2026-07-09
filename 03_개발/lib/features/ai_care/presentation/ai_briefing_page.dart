import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../../../core/layout/app_frame.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/firestore_status_banner.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/section_header.dart';
import '../../auth/application/auth_providers.dart';
import '../../medication/application/medication_providers.dart';
import '../application/ai_care_providers.dart';
import '../domain/ai_briefing.dart';
import '../../shell/presentation/main_shell.dart';

/// AI 브리핑 — 퍼블리싱 21_ai_briefing.html
class AiBriefingPage extends ConsumerStatefulWidget {
  const AiBriefingPage({super.key});

  @override
  ConsumerState<AiBriefingPage> createState() => _AiBriefingPageState();
}

class _AiBriefingPageState extends ConsumerState<AiBriefingPage> {
  int _briefingIndex = 0;

  Future<void> _generate() async {
    if (!firebaseReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Firebase 설정 후 브리핑을 생성할 수 있어요.')),
      );
      return;
    }
    final ok =
        await ref.read(aiCareControllerProvider.notifier).generateBriefing();
    if (!mounted) return;
    if (ok) setState(() => _briefingIndex = 0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? '오늘의 브리핑이 생성되었어요.' : '브리핑 생성에 실패했어요.'),
      ),
    );
  }

  void _pickBriefing(List<AiBriefing> list) {
    if (list.isEmpty) return;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 24.h),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              child: Text(
                '브리핑 기록',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
              ),
            ),
            for (var i = 0; i < list.length; i++)
              ListTile(
                title: Text(
                  list[i].title,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
                ),
                subtitle: list[i].generatedAt == null
                    ? null
                    : Text(
                        DateFormat('yyyy.MM.dd (E) a h:mm', 'ko')
                            .format(list[i].generatedAt!),
                      ),
                trailing: _briefingIndex == i
                    ? Icon(Icons.check_rounded,
                        color: AppColors.primaryStrong, size: 22.sp)
                    : null,
                onTap: () {
                  setState(() => _briefingIndex = i);
                  Navigator.pop(ctx);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _share(AiBriefing briefing) async {
    final buffer = StringBuffer()
      ..writeln(briefing.title)
      ..writeln()
      ..writeln(briefing.summary);
    if (briefing.tips.isNotEmpty) {
      buffer.writeln();
      for (final t in briefing.tips) {
        buffer.writeln('• $t');
      }
    }
    if (briefing.warnings.isNotEmpty) {
      buffer.writeln();
      for (final w in briefing.warnings) {
        buffer.writeln('⚠️ $w');
      }
    }
    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('브리핑 내용을 복사했어요.')),
    );
  }

  String _formatDoseTime(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return hhmm;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    return DateFormat('a h:mm', 'ko')
        .format(DateTime(2000, 1, 1, h, m));
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final briefings = ref.watch(aiBriefingsProvider).value ?? const [];
    final generating = ref.watch(aiCareControllerProvider).isLoading;
    final hasError = ref.watch(aiCareControllerProvider).hasError;
    final summary = ref.watch(medicationSummaryProvider);
    final doses = ref.watch(todayDosesProvider);

    final idx = briefings.isEmpty
        ? 0
        : _briefingIndex.clamp(0, briefings.length - 1);
    final briefing = briefings.isEmpty ? null : briefings[idx];

    final nickname =
        profile?.nickname.isNotEmpty == true ? profile!.nickname : '엄마';
    final stageLabel = profile?.pregnancyStage.label ?? '';
    final todayLabel = DateFormat('yyyy.MM.dd (E)', 'ko').format(DateTime.now());
    final dateLabel = briefing?.generatedAt == null
        ? todayLabel
        : DateFormat('yyyy.MM.dd (E)', 'ko').format(briefing!.generatedAt!);
    final updatedAt = briefing?.generatedAt == null
        ? '아직 생성되지 않았어요'
        : '마지막 업데이트: ${DateFormat('M월 d일 a h:mm', 'ko').format(briefing!.generatedAt!)}';

    final medRate = summary.total == 0 ? 0 : summary.rate;
    final medStatus = summary.total == 0
        ? '없음'
        : (summary.completed >= summary.total ? '완료' : '진행 중');
    final lifestyleScore = summary.total == 0 ? '-' : '${medRate.clamp(0, 100)}점';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: 'AI 브리핑',
        actions: [
          IconButton(
            onPressed: generating ? null : _generate,
            icon: Icon(
              generating ? Icons.hourglass_top_rounded : Icons.auto_awesome_rounded,
              size: 26.sp,
            ),
            tooltip: '브리핑 생성',
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 32.h),
        children: [
          const FirestoreStatusBanner(compact: true),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed:
                        briefings.isEmpty ? null : () => _pickBriefing(briefings),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      minimumSize: Size(0, 46.h),
                    ),
                    icon: Icon(Icons.calendar_month_rounded, size: 18.sp),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dateLabel,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Icon(Icons.expand_more_rounded, size: 17.sp),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                OutlinedButton.icon(
                  onPressed: briefing == null ? null : () => _share(briefing),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF7C5CD6)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    minimumSize: Size(0, 46.h),
                  ),
                  icon: Icon(Icons.share_rounded,
                      size: 16.sp, color: const Color(0xFF7C5CD6)),
                  label: Text(
                    '공유하기',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF7C5CD6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          AppContent(
            child: Column(
              children: [
                AppCard(
                  color: const Color(0xFFF4F0FE),
                  child: Row(
                    children: [
                      Text('🤖', style: TextStyle(fontSize: 76.sp)),
                      SizedBox(width: 18.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                                children: [
                                  TextSpan(text: '$nickname님의 '),
                                  const TextSpan(
                                    text: '건강 브리핑',
                                    style: TextStyle(color: Color(0xFF7C5CD6)),
                                  ),
                                  const TextSpan(text: '이에요!'),
                                ],
                              ),
                            ),
                            if (stageLabel.isNotEmpty) ...[
                              SizedBox(height: 4.h),
                              Text(
                                stageLabel,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                            SizedBox(height: 8.h),
                            Text(
                              '오늘의 복약, 건강 상태, 생활 습관을\nAI가 분석해 맞춤 인사이트를 제공해드려요.',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    size: 16.sp,
                                    color: const Color(0xFF7C5CD6)),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    updatedAt,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF7C5CD6),
                                    ),
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
                if (briefing == null) ...[
                  SizedBox(height: 16.h),
                  AppCard(
                    child: Column(
                      children: [
                        Text(
                          '아직 브리핑이 없어요',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '우측 상단 ✨ 버튼을 눌러\n오늘의 맞춤 브리핑을 생성해보세요.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        PrimaryButton(
                          label: generating ? '생성 중…' : '오늘의 브리핑 생성',
                          onPressed: generating ? null : _generate,
                        ),
                      ],
                    ),
                  ),
                ],
                if (hasError) ...[
                  SizedBox(height: 12.h),
                  AppCard(
                    color: const Color(0xFFFFF0F4),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline_rounded,
                            color: AppColors.primaryStrong, size: 22.sp),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            '브리핑 생성에 실패했어요. 네트워크를 확인한 뒤 다시 시도해주세요.',
                            style: TextStyle(fontSize: 13.sp, height: 1.5),
                          ),
                        ),
                        TextButton(
                          onPressed: generating ? null : _generate,
                          child: const Text('재시도'),
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 16.h),
                SectionHeader(title: '오늘의 한눈에 보기'),
                SizedBox(height: 12.h),
                AppCard(
                  child: Row(
                    children: [
                      _Glance4(
                        icon: Icons.medication_rounded,
                        bg: const Color(0xFFEFE9FC),
                        label: '복약 완료율',
                        value: summary.total == 0 ? '-' : '$medRate%',
                        valueColor: const Color(0xFF7C5CD6),
                        sub: summary.total == 0
                            ? '등록 없음'
                            : '${summary.completed} / ${summary.total}',
                      ),
                      _Glance4(
                        icon: Icons.calendar_month_rounded,
                        bg: const Color(0xFFE8F5EC),
                        label: '복약 일정',
                        value: medStatus,
                        valueColor: const Color(0xFF22A050),
                        sub: summary.medCount == 0
                            ? '약 없음'
                            : '약 ${summary.medCount}종',
                        showBorder: true,
                      ),
                      _Glance4(
                        icon: Icons.favorite_rounded,
                        bg: const Color(0xFFFDF0DC),
                        label: '케어 단계',
                        value: stageLabel.isEmpty ? '-' : stageLabel,
                        valueColor: AppColors.warning,
                        sub: '맞춤 케어',
                        showBorder: true,
                      ),
                      _Glance4(
                        icon: Icons.water_drop_rounded,
                        bg: const Color(0xFFE7F0FB),
                        label: '오늘 점수',
                        value: lifestyleScore,
                        valueColor: const Color(0xFF3B82F6),
                        sub: '복약 기반',
                        showBorder: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                AppCard(
                  color: const Color(0xFFF4F0FE),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            briefing?.title ?? '✨ AI 인사이트',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF7C5CD6),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            briefing?.summary.isNotEmpty == true
                                ? briefing!.summary
                                : '브리핑 생성 버튼을 눌러 오늘의 맞춤 인사이트를 받아보세요.',
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          if (briefing != null)
                            for (final tip in briefing.tips)
                              _InsightItem(tip),
                          if (briefing != null)
                            for (final warning in briefing.warnings)
                              _InsightItem('⚠️ $warning'),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Icon(Icons.assignment_rounded,
                            size: 64.sp,
                            color:
                                const Color(0xFF7C5CD6).withValues(alpha: 0.85)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                SectionHeader(
                  title: '복약 요약',
                  moreLabel: '전체 보기',
                  onMoreTap: () => switchMainTab(context, 1),
                ),
                SizedBox(height: 12.h),
                AppCard(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                  child: doses.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: Text(
                            '오늘 예정된 복약이 없어요.\n복약 탭에서 약을 등록해보세요.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            for (final dose in doses.take(5))
                              _MedRow(
                                name: dose.medication.name,
                                meta:
                                    '${dose.medication.dosage}  |  ${_formatDoseTime(dose.time)}',
                                time: dose.completed ? '완료' : '대기',
                                completed: dose.completed,
                              ),
                          ],
                        ),
                ),
                if (briefing != null && briefing.tips.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  SectionHeader(title: '오늘의 추천'),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      for (var i = 0; i < briefing.tips.length && i < 3; i++)
                        _RecoCard(
                          bg: _recoBg(i),
                          icon: _recoIcon(i),
                          iconColor: _recoColor(i),
                          title: '추천 ${i + 1}',
                          desc: briefing.tips[i],
                          moreColor: _recoColor(i),
                        ),
                    ],
                  ),
                ],
                SizedBox(height: 20.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
                          '이 브리핑은 AI 분석 기반으로 제공되며, 의학적 진단이나 치료를 대체하지 않습니다.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
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
    );
  }

  static Color _recoBg(int i) => switch (i) {
        0 => const Color(0xFFEFE9FC),
        1 => const Color(0xFFE7F0FB),
        _ => const Color(0xFFE8F5EC),
      };

  static IconData _recoIcon(int i) => switch (i) {
        0 => Icons.bedtime_rounded,
        1 => Icons.water_drop_rounded,
        _ => Icons.directions_walk_rounded,
      };

  static Color _recoColor(int i) => switch (i) {
        0 => const Color(0xFF7C5CD6),
        1 => const Color(0xFF3B82F6),
        _ => const Color(0xFF22A050),
      };
}

class _Glance4 extends StatelessWidget {
  const _Glance4({
    required this.icon,
    required this.bg,
    required this.label,
    required this.value,
    required this.valueColor,
    required this.sub,
    this.showBorder = false,
  });

  final IconData icon;
  final Color bg;
  final String label;
  final String value;
  final Color valueColor;
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
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w),
        child: Column(
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.primaryStrong, size: 24.sp),
            ),
            SizedBox(height: 10.h),
            Text(label,
                style: TextStyle(
                    fontSize: 12.sp, color: AppColors.textSecondary)),
            SizedBox(height: 4.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: valueColor,
                  )),
            ),
            Text(sub,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10.sp, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _InsightItem extends StatelessWidget {
  const _InsightItem(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded,
              size: 18.sp, color: const Color(0xFF7C5CD6)),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MedRow extends StatelessWidget {
  const _MedRow({
    required this.name,
    required this.meta,
    required this.time,
    required this.completed,
  });

  final String name;
  final String meta;
  final String time;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final color = completed ? const Color(0xFF34C759) : AppColors.textDisabled;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        children: [
          Icon(Icons.medication_rounded,
              color: AppColors.primaryStrong, size: 30.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        fontSize: 15.sp, fontWeight: FontWeight.w700)),
                Text(meta,
                    style: TextStyle(
                        fontSize: 12.sp, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: completed ? color : AppColors.divider,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  completed ? Icons.check_rounded : Icons.schedule_rounded,
                  color: completed ? Colors.white : AppColors.textSecondary,
                  size: 17.sp,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecoCard extends StatelessWidget {
  const _RecoCard({
    required this.bg,
    this.icon,
    this.iconColor,
    required this.title,
    required this.desc,
    required this.moreColor,
  });

  final Color bg;
  final IconData? icon;
  final Color? iconColor;
  final String title;
  final String desc;
  final Color moreColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(icon, color: iconColor, size: 21.sp),
              ),
            ),
            SizedBox(height: 10.h),
            Text(title,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800)),
            SizedBox(height: 6.h),
            Text(desc,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  height: 1.55,
                )),
          ],
        ),
      ),
    );
  }
}
