import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/layout/app_frame.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/settings_widgets.dart';

/// 앱 정보 — 퍼블리싱 36_app_info.html
class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MomsAppBar(title: '앱 정보'),
      body: ListView(
        padding: EdgeInsets.only(bottom: 32.h),
        children: [
          SizedBox(height: 24.h),
          Center(child: BrandLogo(size: 84)),
          SizedBox(height: 14.h),
          Center(
            child: Text(
              "Mom's Time",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryStrong,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Center(
            child: Text(
              '버전 1.0.0 (빌드 100)',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE9F7EA),
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded,
                      size: 15.sp, color: AppColors.success),
                  SizedBox(width: 4.w),
                  Text(
                    '최신 버전이에요',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          AppContent(
            bottom: false,
            child: SetList(
              children: [
                SetRow(
                  title: '업데이트 확인',
                  icon: Icons.system_update_rounded,
                  value: '자동 업데이트 켜짐',
                  onTap: () {},
                  showDivider: false,
                ),
              ],
            ),
          ),
          SetSection(
            title: '약관 및 정책',
            child: SetList(
              children: [
                SetRow(
                  title: '서비스 이용약관',
                  icon: Icons.description_rounded,
                  onTap: () {},
                ),
                SetRow(
                  title: '개인정보 처리방침',
                  icon: Icons.shield_rounded,
                  onTap: () {},
                ),
                SetRow(
                  title: '건강정보 활용 동의',
                  icon: Icons.health_and_safety_rounded,
                  onTap: () {},
                ),
                SetRow(
                  title: '오픈소스 라이선스',
                  icon: Icons.code_rounded,
                  onTap: () {},
                  showDivider: false,
                ),
              ],
            ),
          ),
          SetSection(
            title: '사업자 정보',
            child: AppCard(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
              child: Column(
                children: const [
                  _BizRow('상호', '(주) 맘스타임'),
                  _BizRow('대표', '김하나'),
                  _BizRow('사업자번호', '123-45-67890'),
                  _BizRow('주소', '서울특별시 강남구 테헤란로 123, 10층'),
                  _BizRow('고객센터', '1660-0000 (평일 09~18시)', showDivider: false),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
            child: Text(
              '본 앱이 제공하는 건강 정보는 참고용이며 의학적 진단을 대신하지 않습니다.\n© 2024 Mom\'s Time. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textDisabled,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BizRow extends StatelessWidget {
  const _BizRow(this.key_, this.value, {this.showDivider = true});
  final String key_;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 84.w,
                child: Text(
                  key_,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(fontSize: 13.sp),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}
