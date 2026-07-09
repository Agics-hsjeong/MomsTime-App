import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/layout/app_frame.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/settings_widgets.dart';

/// 도움말 및 문의 — 퍼블리싱 35_help.html
class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  int _cat = 0;
  static const _cats = ['전체', '복약', '건강 기록', '결제 · 구독', '계정'];

  static const _faqs = [
    (
      '복약 알림이 오지 않아요.',
      '휴대폰 설정 > 알림에서 Mom\'s Time 알림이 켜져 있는지 확인해주세요. 앱 내 [마이페이지 > 알림 설정]에서 복약 알림도 함께 켜야 정상적으로 울려요.',
    ),
    (
      'OCR로 약을 인식하는 팁이 있나요?',
      '밝은 곳에서 약 봉투나 처방전 전체가 보이도록, 글자가 흔들리지 않게 정면에서 촬영하면 인식 정확도가 높아져요.',
    ),
    (
      '가족을 몇 명까지 초대할 수 있나요?',
      '무료 플랜은 최대 3명, 프리미엄은 무제한으로 가족을 초대해 복약·검진 정보를 함께 관리할 수 있어요.',
    ),
    (
      '구독을 해지하면 데이터가 사라지나요?',
      '아니요. 구독을 해지해도 기록은 그대로 남아요. 다만 프리미엄 전용 기능(상세 리포트, 데이터보내기 등)은 이용할 수 없어요.',
    ),
    (
      '기기를 바꾸면 기록을 옮길 수 있나요?',
      '같은 계정으로 로그인하면 모든 기록이 자동으로 동기화돼요. 별도의 백업 없이 새 기기에서 이어서 사용할 수 있어요.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MomsAppBar(title: '도움말 및 문의'),
      body: ListView(
        padding: EdgeInsets.only(bottom: 32.h),
        children: [
          AppContent(
            bottom: false,
            child: Container(
              height: 52.h,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppSizes.radiusButton),
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded,
                      color: AppColors.textDisabled, size: 22.sp),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '궁금한 점을 검색해보세요',
                        hintStyle: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.textDisabled,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 42.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              children: [
                for (var i = 0; i < _cats.length; i++) ...[
                  GestureDetector(
                    onTap: () => setState(() => _cat = i),
                    child: Container(
                      height: 38.h,
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _cat == i
                            ? const Color(0xFFFFF3F7)
                            : AppColors.surface,
                        border: Border.all(
                          color: _cat == i
                              ? AppColors.primaryStrong
                              : AppColors.border,
                        ),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        _cats[i],
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight:
                              _cat == i ? FontWeight.w700 : FontWeight.w600,
                          color: _cat == i
                              ? AppColors.primaryStrong
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SetSection(
            title: '자주 묻는 질문',
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var i = 0; i < _faqs.length; i++)
                    _FaqTile(
                      question: _faqs[i].$1,
                      answer: _faqs[i].$2,
                      initiallyExpanded: i == 0,
                      showDivider: i < _faqs.length - 1,
                    ),
                ],
              ),
            ),
          ),
          SetSection(
            title: '문의하기',
            child: Row(
              children: [
                Expanded(
                  child: _ContactCard(
                    icon: Icons.chat_rounded,
                    bg: AppColors.primaryLight,
                    iconColor: AppColors.primaryStrong,
                    title: '1:1 문의',
                    sub: '평일 09~18시',
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _ContactCard(
                    icon: Icons.forum_rounded,
                    bg: Color(0xFFFEF6D8),
                    iconColor: Color(0xFFE5A400),
                    title: '카카오 채널',
                    sub: 'momstime',
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _ContactCard(
                    icon: Icons.mail_rounded,
                    bg: Color(0xFFE7F0FB),
                    iconColor: Color(0xFF3B82F6),
                    title: '이메일',
                    sub: 'help@momstime.app',
                  ),
                ),
              ],
            ),
          ),
          AppContent(
            child: SetList(
              children: [
                SetRow(
                  title: '공지사항',
                  subtitle: '서비스 소식과 업데이트 안내',
                  icon: Icons.campaign_rounded,
                  onTap: () {},
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  const _FaqTile({
    required this.question,
    required this.answer,
    this.initiallyExpanded = false,
    this.showDivider = true,
  });

  final String question;
  final String answer;
  final bool initiallyExpanded;
  final bool showDivider;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  late bool _open = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
            child: Row(
              children: [
                Text('Q',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryStrong,
                    )),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    widget.question,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  _open ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                  color: AppColors.textDisabled,
                  size: 22.sp,
                ),
              ],
            ),
          ),
        ),
        if (_open)
          Padding(
            padding: EdgeInsets.fromLTRB(40.w, 0, 18.w, 16.h),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.answer,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
              ),
            ),
          ),
        if (widget.showDivider)
          const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.bg,
    required this.iconColor,
    required this.title,
    required this.sub,
  });

  final IconData icon;
  final Color bg;
  final Color iconColor;
  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 22.sp),
          ),
          SizedBox(height: 10.h),
          Text(title,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
          SizedBox(height: 2.h),
          Text(sub,
              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
