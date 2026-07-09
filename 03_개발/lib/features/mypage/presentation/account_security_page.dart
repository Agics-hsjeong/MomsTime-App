import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/settings_widgets.dart';

/// 계정 및 보안 — 퍼블리싱 33_account_security.html
class AccountSecurityPage extends StatefulWidget {
  const AccountSecurityPage({super.key});

  @override
  State<AccountSecurityPage> createState() => _AccountSecurityPageState();
}

class _AccountSecurityPageState extends State<AccountSecurityPage> {
  bool _bio = true;
  bool _pin = false;
  bool _autoLogout = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MomsAppBar(title: '계정 및 보안'),
      body: ListView(
        padding: EdgeInsets.only(bottom: 32.h),
        children: [
          const SetLead('로그인 정보와 보안 설정을 관리해요.'),
          SetSection(
            title: '로그인 정보',
            child: SetList(
              children: [
                SetRow(
                  title: '이메일',
                  icon: Icons.mail_rounded,
                  value: 'jihye.kim@email.com',
                  showDivider: true,
                ),
                SetRow(
                  title: '비밀번호 변경',
                  subtitle: '마지막 변경: 2024.03.12',
                  icon: Icons.lock_rounded,
                  onTap: () {},
                ),
                SetRow(
                  title: '소셜 계정 연결',
                  subtitle: 'Google · Apple · Kakao',
                  icon: Icons.link_rounded,
                  value: '1개 연결',
                  onTap: () {},
                  showDivider: false,
                ),
              ],
            ),
          ),
          SetSection(
            title: '보안',
            child: SetList(
              children: [
                SetSwitchRow(
                  title: '생체 인증',
                  subtitle: 'Face ID로 로그인 및 잠금 해제',
                  icon: Icons.fingerprint_rounded,
                  value: _bio,
                  onChanged: (v) => setState(() => _bio = v),
                ),
                SetSwitchRow(
                  title: '앱 잠금 (PIN)',
                  subtitle: '앱 실행 시 PIN 번호 요청',
                  icon: Icons.pin_rounded,
                  value: _pin,
                  onChanged: (v) => setState(() => _pin = v),
                ),
                SetSwitchRow(
                  title: '자동 로그아웃',
                  subtitle: '30분 미사용 시 자동 로그아웃',
                  icon: Icons.history_toggle_off_rounded,
                  value: _autoLogout,
                  onChanged: (v) => setState(() => _autoLogout = v),
                  showDivider: false,
                ),
              ],
            ),
          ),
          SetSection(
            title: '로그인된 기기',
            child: SetList(
              children: [
                _DeviceRow(
                  icon: Icons.smartphone_rounded,
                  name: 'iPhone 15 Pro',
                  meta: '서울 · 방금 활동',
                  badge: '현재 기기',
                ),
                _DeviceRow(
                  icon: Icons.tablet_mac_rounded,
                  name: 'iPad Air',
                  meta: '서울 · 3일 전 활동',
                  action: '로그아웃',
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SetDangerActions(),
          const SetNote('회원 탈퇴 시 모든 복약·건강 기록이 삭제되며 복구할 수 없어요.'),
        ],
      ),
    );
  }
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({
    required this.icon,
    required this.name,
    required this.meta,
    this.badge,
    this.action,
    this.showDivider = true,
  });

  final IconData icon;
  final String name;
  final String meta;
  final String? badge;
  final String? action;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 15.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: AppColors.primaryStrong, size: 22.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w700)),
                    Text(meta,
                        style: TextStyle(
                            fontSize: 12.sp, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (badge != null)
                Text(
                  badge!,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                )
              else if (action != null)
                Text(
                  action!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryStrong,
                  ),
                ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, color: AppColors.divider, indent: 72),
      ],
    );
  }
}
