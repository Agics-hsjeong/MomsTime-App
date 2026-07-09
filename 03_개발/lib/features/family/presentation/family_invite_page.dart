import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_frame.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/status_chip.dart';

const _purple = Color(0xFF7C5CD6);

/// 가족 초대 — 퍼블리싱 25_family_invite.html
class FamilyInvitePage extends StatefulWidget {
  const FamilyInvitePage({super.key});

  @override
  State<FamilyInvitePage> createState() => _FamilyInvitePageState();
}

class _FamilyInvitePageState extends State<FamilyInvitePage> {
  int _method = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: '가족 초대',
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.info_outline_rounded, size: 26.sp),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 24.h),
              children: [
                AppContent(
                  child: Column(
                    children: [
                      AppCard(
                        color: const Color(0xFFF4F0FE),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '소중한 가족의 건강을\n함께 관리하세요!',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w800,
                                    height: 1.5,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                SizedBox(
                                  width: 240.w,
                                  child: Text(
                                    '가족으로 초대하면 서로의 복약, 검진, 기록을 공유하고 건강을 더 쉽게 관리할 수 있어요.',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.textSecondary,
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 18.h),
                                Row(
                                  children: const [
                                    _Feat(
                                      icon: Icons.medication_rounded,
                                      label: '복약 관리\n공유',
                                    ),
                                    _Feat(
                                      icon: Icons.assignment_rounded,
                                      iconColor: _purple,
                                      label: '검진 결과\n공유',
                                    ),
                                    _Feat(
                                      icon: Icons.favorite_rounded,
                                      iconColor: _purple,
                                      label: '건강 상태\n모니터링',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              right: 0,
                              top: 20.h,
                              child: Icon(Icons.groups_rounded,
                                  size: 84.sp, color: AppColors.primaryStrong),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SectionHeader(title: '초대 방법 선택'),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          _MethodCard(
                            icon: Icons.share_rounded,
                            bg: const Color(0xFFEFE9FC),
                            name: '초대 링크',
                            desc: '링크를 복사하여\n공유해 보세요',
                            active: _method == 0,
                            onTap: () => setState(() => _method = 0),
                          ),
                          SizedBox(width: 10.w),
                          _MethodCard(
                            emoji: '💬',
                            bg: const Color(0xFFE8F5EC),
                            name: '메시지 초대',
                            desc: '카카오톡, 문자 등으로\n초대 메시지 전송',
                            active: _method == 1,
                            onTap: () => setState(() => _method = 1),
                          ),
                          SizedBox(width: 10.w),
                          _MethodCard(
                            icon: Icons.mail_rounded,
                            bg: const Color(0xFFE7F0FB),
                            iconColor: const Color(0xFF3B82F6),
                            name: '이메일 초대',
                            desc: '이메일로 초대장을\n보내세요',
                            active: _method == 2,
                            onTap: () => setState(() => _method = 2),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      SectionHeader(title: '초대 링크'),
                      SizedBox(height: 12.h),
                      AppCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'https://momstime.app/invite/ABCD1234',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  _CopyBtn(label: '복사하기'),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: AppColors.divider),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18.w, vertical: 12.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.schedule_rounded,
                                          size: 16.sp, color: _purple),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '링크 유효기간: 2024.06.16 (일) 까지',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.refresh_rounded,
                                          size: 15.sp, color: _purple),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '새로 생성',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700,
                                          color: _purple,
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
                      SizedBox(height: 24.h),
                      SectionHeader(title: '초대 코드'),
                      SizedBox(height: 8.h),
                      Text(
                        '초대 코드를 상대방이 입력하여 가족으로 함께할 수 있어요.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBFAFF),
                          border: Border.all(
                            color: const Color(0xFFB7A5EC),
                            width: 1.5,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.card_giftcard_rounded,
                                color: AppColors.primaryStrong, size: 24.sp),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                'MOMT-ABCD-1234',
                                style: TextStyle(
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const _CopyBtn(label: '복사하기'),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SectionHeader(title: '초대된 가족', moreLabel: '초대 관리'),
                      SizedBox(height: 12.h),
                      AppCard(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 4.h),
                        child: Column(
                          children: const [
                            _InvFam(
                              emoji: '👩🏻',
                              name: '아내',
                              chip: '본인',
                              date: '2024.05.20 초대',
                              state: '관리자',
                              stateColor: _purple,
                            ),
                            _InvFam(
                              emoji: '👨🏻',
                              name: '아버지',
                              date: '2024.05.18 초대',
                              state: '수락 완료',
                              stateColor: Color(0xFF22A050),
                            ),
                            _InvFam(
                              emoji: '👵🏻',
                              name: '어머니',
                              date: '2024.05.18 초대',
                              state: '수락 완료',
                              stateColor: Color(0xFF22A050),
                            ),
                            _InvFam(
                              emoji: '👦🏻',
                              name: '동생',
                              date: '2024.06.01 초대',
                              state: '대기 중',
                              stateColor: AppColors.textDisabled,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F0FE),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.verified_user_rounded,
                                color: _purple, size: 26.sp),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                "Mom's Time은 가족의 정보를 안전하게 보호합니다.\n초대는 수락 전까지 상대방에게 노출되지 않습니다.",
                                style: TextStyle(
                                  fontSize: 12.5.sp,
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
                  flex: 9,
                  child: OutlinedButton.icon(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _purple),
                      minimumSize: Size.fromHeight(AppSizes.btnHeight),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusButton),
                      ),
                    ),
                    icon: Icon(Icons.list_rounded, size: 19.sp, color: _purple),
                    label: Text(
                      '초대 내역 보기',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: _purple,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  flex: 11,
                  child: PrimaryButton(
                    label: '가족 추가',
                    icon: Icons.person_add_rounded,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9B7EF5), Color(0xFF7C5CD6)],
                    ),
                    onPressed: () => context.go(Routes.family),
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

class _Feat extends StatelessWidget {
  const _Feat({
    required this.icon,
    required this.label,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                color: iconColor ?? AppColors.primaryStrong, size: 21.sp),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    this.icon,
    this.emoji,
    this.bg = AppColors.surface,
    this.iconColor,
    required this.name,
    required this.desc,
    required this.active,
    required this.onTap,
  });

  final IconData? icon;
  final String? emoji;
  final Color bg;
  final Color? iconColor;
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
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFF8F5FF) : AppColors.surface,
            border: Border.all(
              color: active ? _purple : AppColors.divider,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: active ? _purple : bg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: emoji != null
                      ? Text(emoji!, style: TextStyle(fontSize: 25.sp))
                      : Icon(icon,
                          color: active
                              ? Colors.white
                              : (iconColor ?? AppColors.textSecondary),
                          size: 25.sp),
                ),
              ),
              SizedBox(height: 10.h),
              Text(name,
                  style: TextStyle(
                      fontSize: 14.5.sp, fontWeight: FontWeight.w800)),
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

class _CopyBtn extends StatelessWidget {
  const _CopyBtn({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: _purple),
        minimumSize: Size(0, 40.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: _purple,
        ),
      ),
    );
  }
}

class _InvFam extends StatelessWidget {
  const _InvFam({
    required this.emoji,
    required this.name,
    this.chip,
    required this.date,
    required this.state,
    required this.stateColor,
  });

  final String emoji;
  final String name;
  final String? chip;
  final String date;
  final String state;
  final Color stateColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: const BoxDecoration(
              color: Color(0xFFF4F0FE),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(emoji, style: TextStyle(fontSize: 24.sp))),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name,
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w700)),
                    if (chip != null) ...[
                      SizedBox(width: 6.w),
                      StatusChip(
                        label: chip!,
                        height: 22.h,
                        backgroundColor: const Color(0xFFEFE9FC),
                        color: _purple,
                      ),
                    ],
                  ],
                ),
                Text(date,
                    style: TextStyle(
                        fontSize: 12.sp, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(state,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: stateColor,
              )),
          Icon(Icons.chevron_right_rounded,
              color: AppColors.textDisabled, size: 20.sp),
        ],
      ),
    );
  }
}
