import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../shared/widgets/primary_button.dart';
import '../application/auth_providers.dart';

/// 로그인 화면 (퍼블리싱 02_login).
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _keepLogin = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _login() async {
    // Firebase 미설정 시: 목업 흐름 유지.
    if (!firebaseReady) {
      context.go(Routes.stage);
      return;
    }
    if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      _toast('이메일과 비밀번호를 입력해주세요.');
      return;
    }
    final ok = await ref
        .read(authControllerProvider.notifier)
        .signIn(_email.text, _password.text);
    if (!ok) {
      _toast(_errorText());
    }
    // 성공 시 라우터 redirect 가 홈으로 이동.
  }

  Future<void> _google() async {
    if (!firebaseReady) {
      context.go(Routes.stage);
      return;
    }
    final ok =
        await ref.read(authControllerProvider.notifier).signInWithGoogle();
    if (!ok) _toast(_errorText());
  }

  Future<void> _signUp() async {
    if (!firebaseReady) {
      context.go(Routes.stage);
      return;
    }
    if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      _toast('이메일과 비밀번호를 입력해주세요.');
      return;
    }
    final nickname = await _askNickname();
    if (nickname == null) return;
    final ok = await ref
        .read(authControllerProvider.notifier)
        .signUp(_email.text, _password.text, nickname);
    if (!ok) {
      _toast(_errorText());
    } else if (mounted) {
      context.go(Routes.stage);
    }
  }

  Future<void> _resetPassword() async {
    if (!firebaseReady) return;
    if (_email.text.trim().isEmpty) {
      _toast('비밀번호를 재설정할 이메일을 입력해주세요.');
      return;
    }
    final ok = await ref
        .read(authControllerProvider.notifier)
        .sendPasswordReset(_email.text);
    _toast(ok ? '비밀번호 재설정 메일을 보냈어요.' : _errorText());
  }

  Future<String?> _askNickname() {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('닉네임 설정'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: '사용할 닉네임'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              final v = controller.text.trim();
              Navigator.pop(ctx, v.isEmpty ? '사용자' : v);
            },
            child: const Text('가입'),
          ),
        ],
      ),
    );
  }

  String _errorText() {
    final err = ref.read(authControllerProvider).error;
    return err?.toString() ?? '문제가 발생했어요. 다시 시도해주세요.';
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authControllerProvider).isLoading;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.6, 1.0],
            colors: [Color(0xFFFFF6F8), Color(0xFFFEEDF2), Color(0xFFFCE3EB)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  SizedBox(height: 72.h),
                  Center(child: BrandLockup(logoSize: 88, nameSize: 32)),
                  SizedBox(height: 40.h),

                  // 이메일 / 비밀번호
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusCard),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x14F47C9C),
                          blurRadius: 12.r,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _field(
                          controller: _email,
                          icon: Icons.person_outline_rounded,
                          hint: '이메일 주소를 입력해주세요',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const Divider(height: 1, color: AppColors.divider),
                        _field(
                          controller: _password,
                          icon: Icons.lock_outline_rounded,
                          hint: '비밀번호를 입력해주세요',
                          obscure: _obscure,
                          trailing: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              color: AppColors.textDisabled,
                              size: 22.sp,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  Row(
                    children: [
                      SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Checkbox(
                          value: _keepLogin,
                          onChanged: (v) =>
                              setState(() => _keepLogin = v ?? false),
                          activeColor: AppColors.primaryStrong,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '로그인 상태 유지',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _resetPassword,
                        child: Row(
                          children: [
                            Text(
                              '비밀번호 찾기',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded,
                                size: 18.sp, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  PrimaryButton(label: '로그인', onPressed: _login),
                  SizedBox(height: 24.h),

                  const _OrDivider(),
                  SizedBox(height: 24.h),

                  _social('Google로 계속하기', const Color(0xFF4285F4),
                      Icons.g_mobiledata_rounded, _google),
                  SizedBox(height: 12.h),
                  _social('Apple로 계속하기', Colors.black, Icons.apple_rounded,
                      _login),
                  SizedBox(height: 12.h),
                  _social('카카오로 계속하기', const Color(0xFF3C1E1E),
                      Icons.chat_bubble_rounded, _login,
                      bg: const Color(0xFFFEE500)),
                  SizedBox(height: 28.h),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '계정이 없으신가요?',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                          ),
                        ),
                        TextButton(
                          onPressed: _signUp,
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                              color: AppColors.primaryStrong,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
              if (loading)
                const Positioned.fill(
                  child: ColoredBox(
                    color: Color(0x33000000),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscure = false,
    Widget? trailing,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryStrong, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              style: TextStyle(fontSize: 16.sp),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textDisabled,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.symmetric(vertical: 20.h),
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }

  Widget _social(String label, Color fg, IconData icon, VoidCallback onTap,
      {Color? bg}) {
    return SizedBox(
      height: 56.h,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Container(
          width: 24.w,
          height: 24.w,
          alignment: Alignment.center,
          decoration: bg != null
              ? BoxDecoration(color: bg, shape: BoxShape.circle)
              : null,
          child: Icon(icon, color: fg, size: 20.sp),
        ),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusButton),
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            '또는',
            style: TextStyle(color: AppColors.textDisabled, fontSize: 13.sp),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}
