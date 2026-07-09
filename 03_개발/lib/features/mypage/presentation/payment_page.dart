import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_frame.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/status_chip.dart';

const _purple = Color(0xFF6D4FD0);

/// 결제하기 — 퍼블리싱 30_payment.html
class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _method = 0;
  final _agreeAll = true;
  final _agrees = [true, true, true];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: '결제하기',
        actions: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.close_rounded, size: 26.sp),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppCard(
                        color: const Color(0xFFF4F0FE),
                        child: Row(
                          children: [
                            Container(
                              width: 72.w,
                              height: 72.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE7DEFB),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                  child: Text('💎', style: TextStyle(fontSize: 34.sp))),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      StatusChip(
                                        label: 'Premium',
                                        height: 22.h,
                                        backgroundColor: const Color(0xFFE5DDF8),
                                        color: _purple,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text('1개월 플랜',
                                          style: TextStyle(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w800)),
                                    ],
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    '다음 결제일 2024.06.20\n매월 자동 결제됩니다.',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.textSecondary,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('5,900원',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w800,
                                      color: _purple,
                                    )),
                                Text('/월',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.textSecondary)),
                                Text('부가세 포함',
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28.h),
                      Text('1. 결제 수단 선택',
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.w800)),
                      SizedBox(height: 12.h),
                      AppCard(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                        child: Column(
                          children: [
                            _MethodRow(
                              logo: '카카오',
                              logoBg: const Color(0xFFFEE500),
                              logoColor: const Color(0xFF191919),
                              name: '카카오페이',
                              tag: '최근 사용',
                              selected: _method == 0,
                              onTap: () => setState(() => _method = 0),
                            ),
                            _MethodRow(
                              logo: 'NAVER',
                              logoBg: const Color(0xFF03C75A),
                              logoColor: Colors.white,
                              name: '네이버페이',
                              selected: _method == 1,
                              onTap: () => setState(() => _method = 1),
                            ),
                            _MethodRow(
                              logo: 'SAMSUNG',
                              logoBg: AppColors.surface,
                              logoColor: const Color(0xFF1428A0),
                              name: '삼성페이',
                              selected: _method == 2,
                              onTap: () => setState(() => _method = 2),
                            ),
                            _MethodRow(
                              logo: 'CARD',
                              logoBg: const Color(0xFFF1F1F3),
                              logoColor: AppColors.textSecondary,
                              name: '신용/체크카드',
                              selected: _method == 3,
                              onTap: () => setState(() => _method = 3),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28.h),
                      Text('2. 결제 정보 확인',
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.w800)),
                      SizedBox(height: 12.h),
                      AppCard(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                        child: Column(
                          children: [
                            _InfoRow('상품 금액', '5,900원'),
                            _InfoRow('할인', '- 0원'),
                            Divider(height: 24.h, color: AppColors.divider),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('총 결제 금액',
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w800)),
                                Text('5,900원',
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w800,
                                      color: _purple,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AppCard(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                        child: Column(
                          children: [
                            _DetailRow('카카오페이', 'kakaopay@example.com'),
                            _DetailRow('쿠폰', '적용 안 함', isValue: true),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F0FE),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          children: [
                            Text('🔒', style: TextStyle(fontSize: 22.sp)),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 12.5.sp,
                                    color: AppColors.textSecondary,
                                    height: 1.6,
                                  ),
                                  children: const [
                                    TextSpan(text: '결제 정보는 '),
                                    TextSpan(
                                      text: 'SSL 암호화',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: _purple,
                                      ),
                                    ),
                                    TextSpan(text: '로 안전하게 보호됩니다.'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28.h),
                      Text('3. 약관 동의',
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.w800)),
                      SizedBox(height: 12.h),
                      AppCard(
                        child: Column(
                          children: [
                            _AgreeRow(
                              title: '전체 동의',
                              bold: true,
                              checked: _agreeAll,
                            ),
                            const Divider(color: AppColors.divider),
                            _AgreeRow(
                              title: '정기 결제 및 자동 갱신에 동의합니다.',
                              required: true,
                              checked: _agrees[0],
                            ),
                            _AgreeRow(
                              title: '전자금융거래 이용약관에 동의합니다.',
                              required: true,
                              checked: _agrees[1],
                            ),
                            _AgreeRow(
                              title: '개인정보 수집 및 이용에 동의합니다.',
                              required: true,
                              checked: _agrees[2],
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
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Column(
              children: [
                PrimaryButton(
                  label: '5,900원 결제하기',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B6FF0), Color(0xFF6D4FD0)],
                  ),
                  onPressed: () => context.pop(),
                ),
                SizedBox(height: 12.h),
                Text(
                  '결제 완료 후 구독이 즉시 시작됩니다.',
                  style: TextStyle(
                      fontSize: 12.sp, color: AppColors.textDisabled),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodRow extends StatelessWidget {
  const _MethodRow({
    required this.logo,
    required this.logoBg,
    required this.logoColor,
    required this.name,
    this.tag,
    required this.selected,
    required this.onTap,
  });

  final String logo;
  final Color logoBg;
  final Color logoColor;
  final String name;
  final String? tag;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            _Radio(selected: selected),
            SizedBox(width: 14.w),
            Container(
              width: 52.w,
              height: 32.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: logoBg,
                borderRadius: BorderRadius.circular(8.r),
                border: logoBg == AppColors.surface
                    ? Border.all(color: AppColors.border)
                    : null,
              ),
              child: Text(logo,
                  style: TextStyle(
                      fontSize: logo.length > 5 ? 8.sp : 11.sp,
                      fontWeight: FontWeight.w800,
                      color: logoColor)),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(name,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            ),
            if (tag != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE9FC),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(tag!,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: _purple,
                    )),
              ),
          ],
        ),
      ),
    );
  }
}

class _Radio extends StatelessWidget {
  const _Radio({required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22.w,
      height: 22.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? _purple : AppColors.border,
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 11.w,
                height: 11.w,
                decoration: const BoxDecoration(
                  color: _purple,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14.sp, color: AppColors.textSecondary)),
          Text(value,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.title, this.value, {this.isValue = false});
  final String title;
  final String value;
  final bool isValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: [
          if (!isValue)
            Container(
              width: 44.w,
              height: 28.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE500),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text('카카오',
                  style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF191919))),
            ),
          if (!isValue) SizedBox(width: 12.w),
          Expanded(
            child: Text(title,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isValue ? 14.sp : 13.sp,
              fontWeight: isValue ? FontWeight.w400 : FontWeight.w700,
              color: isValue ? AppColors.textSecondary : _purple,
            ),
          ),
          if (!isValue) ...[
            SizedBox(width: 8.w),
            Text('변경',
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: _purple)),
          ],
        ],
      ),
    );
  }
}

class _AgreeRow extends StatelessWidget {
  const _AgreeRow({
    required this.title,
    this.bold = false,
    this.required = false,
    required this.checked,
  });

  final String title;
  final bool bold;
  final bool required;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: bold ? 28.w : 22.w,
            height: bold ? 28.w : 22.w,
            decoration: BoxDecoration(
              color: checked ? _purple : Colors.transparent,
              shape: BoxShape.circle,
              border: checked ? null : Border.all(color: AppColors.border),
            ),
            child: checked
                ? Icon(Icons.check_rounded, color: Colors.white, size: 15.sp)
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: bold ? 15.sp : 13.5.sp,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w400,
              ),
            ),
          ),
          if (required)
            Text('(필수)',
                style: TextStyle(
                    fontSize: 12.sp, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
