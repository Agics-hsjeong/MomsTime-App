import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/settings_widgets.dart';

/// 언어 및 지역 — 퍼블리싱 34_language_region.html
class LanguageRegionPage extends StatelessWidget {
  const LanguageRegionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MomsAppBar(title: '언어 및 지역'),
      body: ListView(
        padding: EdgeInsets.only(bottom: 32.h),
        children: [
          const SetLead('언어와 날짜·시간 표시 형식을 설정해요.'),
          SetSection(
            title: '언어',
            child: OptList(
              options: const ['한국어', 'English', '日本語', '中文 (简体)'],
            ),
          ),
          SetSection(
            title: '국가 / 지역',
            child: SetList(
              children: [
                SetRow(
                  title: '국가',
                  icon: Icons.public_rounded,
                  value: '대한민국',
                  onTap: () {},
                ),
                SetRow(
                  title: '시간대',
                  icon: Icons.schedule_rounded,
                  value: 'GMT+9 서울',
                  onTap: () {},
                  showDivider: false,
                ),
              ],
            ),
          ),
          SetSection(
            title: '날짜 형식',
            child: OptList(
              options: const [
                '2024. 06. 02',
                '06/02/2024',
                '02 Jun 2024',
              ],
            ),
          ),
          SetSection(
            title: '시간 형식',
            child: OptList(
              options: const ['오전 / 오후 (12시간)', '24시간'],
            ),
          ),
          SetSection(
            title: '주 시작 요일',
            child: OptList(
              options: const ['일요일', '월요일'],
            ),
          ),
          const SetNote('변경한 형식은 캘린더·복약 기록 등 앱 전체에 적용돼요.'),
        ],
      ),
    );
  }
}
