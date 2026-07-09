import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/layout/app_frame.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/settings_widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/app_user.dart';

/// 프로필 수정 — 퍼블리싱 27_profile_edit.html
class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final _nameCtrl = TextEditingController();
  DateTime? _birth;
  DateTime? _due;
  PregnancyStage _stage = PregnancyStage.preparing;
  String _photo = '';
  bool _inited = false;
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  String _fmt(DateTime? d) {
    if (d == null) return '-';
    return DateFormat('yyyy.MM.dd', 'ko').format(d);
  }

  Future<void> _pickBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(now.year - 30, 1, 1),
      firstDate: DateTime(1900, 1, 1),
      lastDate: now,
    );
    if (picked != null) setState(() => _birth = picked);
  }

  Future<void> _pickDue() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _due ?? now.add(const Duration(days: 120)),
      firstDate: now.subtract(const Duration(days: 14)),
      lastDate: now.add(const Duration(days: 400)),
    );
    if (picked != null) setState(() => _due = picked);
  }

  Future<void> _save() async {
    final profile = ref.read(currentUserProfileProvider).value;
    if (profile == null) return;
    final nickname = _nameCtrl.text.trim();
    if (nickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이름(닉네임)을 입력해주세요.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(userRepositoryProvider).update(profile.uid, {
        'nickname': nickname,
        'birthDate': _birth,
        'dueDate': _due,
        'pregnancyStage': _stage.key,
        'stageCompleted': true,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장했어요.')),
      );
      context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final email = profile?.email ?? '';
    if (!_inited && profile != null) {
      _nameCtrl.text = profile.nickname;
      _birth = profile.birthDate;
      _due = profile.dueDate;
      _stage = profile.pregnancyStage;
      _photo = profile.profileImage;
      _inited = true;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MomsAppBar(title: '프로필 수정'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 24.h),
              children: [
                AppContent(
                  bottom: false,
                  child: AppCard(
                    child: Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 64.r,
                              backgroundColor: const Color(0xFFEFE9FC),
                              backgroundImage:
                                  _photo.isNotEmpty ? NetworkImage(_photo) : null,
                              child: _photo.isNotEmpty
                                  ? null
                                  : Text('👩🏻',
                                      style: TextStyle(fontSize: 62.sp)),
                            ),
                            Positioned(
                              right: 2.w,
                              bottom: 2.h,
                              child: Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x14F47C9C),
                                      blurRadius: 12.r,
                                      offset: Offset(0, 4.h),
                                    ),
                                  ],
                                ),
                                child: Icon(Icons.photo_camera_rounded,
                                    size: 20.sp, color: const Color(0xFF7C5CD6)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 24.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '프로필 사진',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                '나를 나타내는 사진을\n등록해 보세요.',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.textSecondary,
                                  height: 1.6,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              OutlinedButton.icon(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Color(0xFF7C5CD6), width: 1.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 18.w, vertical: 0),
                                  minimumSize: Size(0, 44.h),
                                ),
                                icon: Icon(Icons.image_rounded,
                                    size: 18.sp, color: const Color(0xFF7C5CD6)),
                                label: Text(
                                  '사진 변경',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF7C5CD6),
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
                SetSection(
                  title: '기본 정보',
                  child: AppCard(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                    child: Column(
                      children: [
                        _PfInputRow(label: '이름(닉네임)', controller: _nameCtrl),
                        _PfStageRow(
                          stage: _stage,
                          onChanged: (s) => setState(() => _stage = s),
                        ),
                        _PfActionRow(
                          label: '생년월일',
                          value: _fmt(_birth),
                          onTap: _pickBirth,
                        ),
                        _PfActionRow(
                          label: '출산 예정일',
                          value: _fmt(_due),
                          onTap: _pickDue,
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                ),
                SetSection(
                  title: '연락처 정보',
                  child: AppCard(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                    child: Column(
                      children: [
                        _PfRow(
                          label: '이메일',
                          value: email.isEmpty ? '-' : email,
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                ),
                SetSection(
                  title: '알림 및 설정',
                  child: AppCard(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                    child: Column(
                      children: [
                        _PfSetting(
                          icon: Icons.notifications_rounded,
                          title: '알림 설정',
                          desc: '복약, 검진, 예약 등 알림을 설정할 수 있어요.',
                          onTap: () => context.push(Routes.notificationSettings),
                        ),
                        _PfSetting(
                          icon: Icons.lock_rounded,
                          title: '비밀번호 변경',
                          desc: '안전한 서비스 이용을 위해 비밀번호를 변경하세요.',
                          onTap: () => context.push(Routes.accountSecurity),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 8.h),
            child: PrimaryButton(
              label: '저장하기',
              gradient: const LinearGradient(
                colors: [Color(0xFF8B6FF0), Color(0xFF6D4FD0)],
              ),
              onPressed: _saving ? null : _save,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
            child: SecondaryButton(
              label: '취소',
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PfRow extends StatelessWidget {
  const _PfRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: 12.5.sp, color: AppColors.textSecondary)),
                    SizedBox(height: 4.h),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}

class _PfInputRow extends StatelessWidget {
  const _PfInputRow({required this.label, required this.controller});
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      TextStyle(fontSize: 12.5.sp, color: AppColors.textSecondary)),
              SizedBox(height: 4.h),
              TextField(
                controller: controller,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}

class _PfActionRow extends StatelessWidget {
  const _PfActionRow({
    required this.label,
    required this.value,
    required this.onTap,
    this.showDivider = true,
  });
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: TextStyle(
                              fontSize: 12.5.sp, color: AppColors.textSecondary)),
                      SizedBox(height: 4.h),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.calendar_month_rounded,
                    color: AppColors.textDisabled, size: 22.sp),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}

class _PfStageRow extends StatelessWidget {
  const _PfStageRow({required this.stage, required this.onChanged});
  final PregnancyStage stage;
  final ValueChanged<PregnancyStage> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('임신 단계',
                  style: TextStyle(
                      fontSize: 12.5.sp, color: AppColors.textSecondary)),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  for (final s in PregnancyStage.values)
                    GestureDetector(
                      onTap: () => onChanged(s),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: stage == s
                              ? const Color(0xFFFFF3F7)
                              : AppColors.surface,
                          border: Border.all(
                            color: stage == s
                                ? AppColors.primaryStrong
                                : AppColors.border,
                          ),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          s.label,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: stage == s
                                ? AppColors.primaryStrong
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}

// `_PfHalfRow`는 현재 화면에서 사용하지 않아 제거했습니다.

class _PfSetting extends StatelessWidget {
  const _PfSetting({
    required this.icon,
    required this.title,
    required this.desc,
    required this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final String desc;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFE9FC),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: const Color(0xFF7C5CD6), size: 22.sp),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700)),
                      SizedBox(height: 2.h),
                      Text(desc,
                          style: TextStyle(
                              fontSize: 12.5.sp,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: AppColors.textDisabled, size: 22.sp),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}
