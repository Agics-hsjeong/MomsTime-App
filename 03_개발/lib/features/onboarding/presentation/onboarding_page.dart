import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/primary_button.dart';

/// 서비스 소개 3페이지 (퍼블리싱 03_onboarding 1~3).
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  static const _slides = <_Slide>[
    _Slide(
      step: 1,
      title: '복약과 건강을\n한 곳에서 관리해요',
      desc: '임신 준비부터 출산 후까지,\n매일의 복약과 건강 기록을 놓치지 않도록 도와드려요.',
      illustBg: Color(0xFFFFEDF2),
      illustEmoji: '🤰🏻',
      highlights: [
        (Icons.medication_rounded, Color(0xFFFFE7EE), '복약 관리',
            '약과 영양제를 등록하고 복용 시간을 알림으로 챙겨드려요.'),
        (Icons.calendar_month_rounded, Color(0xFFFDF0DC), '일정 관리',
            '병원 진료와 검사일을 캘린더로 한눈에 확인해요.'),
      ],
    ),
    _Slide(
      step: 2,
      title: 'AI가 매일\n건강을 챙겨드려요',
      desc: '복약과 건강 데이터를 분석해\n매일 맞춤 브리핑과 상담을 제공해드려요.',
      illustBg: Color(0xFFF3EEFF),
      illustEmoji: '🤖',
      highlights: [
        (Icons.smart_toy_rounded, Color(0xFFF3EEFF), 'AI 케어',
            '궁금한 건강 정보를 AI에게 물어봐요.'),
        (Icons.favorite_rounded, Color(0xFFFFE7EE), 'AI 하루 브리핑',
            '오늘의 컨디션과 주의사항을 정리해드려요.'),
      ],
    ),
    _Slide(
      step: 3,
      title: '소중한 가족과\n함께 건강하게',
      desc: '가족을 초대해 서로의 복약과 건강을 함께 관리하고,\n맞춤 리포트로 변화를 확인해요.',
      illustBg: Color(0xFFFFEDF2),
      illustEmoji: '👨‍👩‍👧',
      highlights: [
        (Icons.groups_rounded, Color(0xFFFFE7EE), '가족 공유',
            '복약 일정과 검진 결과를 함께 챙겨요.'),
        (Icons.bar_chart_rounded, Color(0xFFE4F5F2), '건강 리포트',
            '복약률과 건강 변화를 한눈에 확인해요.'),
      ],
    ),
  ];

  bool get _isLast => _index == _slides.length - 1;

  void _next() {
    if (_isLast) {
      context.go(Routes.login);
    } else {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(top: 6.h, right: 20.w),
                child: TextButton(
                  onPressed: () => context.go(Routes.login),
                  child: Text(
                    '건너뛰기',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => _SlideView(slide: _slides[i]),
              ),
            ),
            _Dots(count: _slides.length, index: _index),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
              child: PrimaryButton(
                label: _isLast ? '시작하기' : '다음',
                icon: _isLast ? null : Icons.chevron_right_rounded,
                onPressed: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Slide {
  const _Slide({
    required this.step,
    required this.title,
    required this.desc,
    required this.illustBg,
    required this.illustEmoji,
    required this.highlights,
  });
  final int step;
  final String title;
  final String desc;
  final Color illustBg;
  final String illustEmoji;
  final List<(IconData, Color, String, String)> highlights;
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});
  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${slide.step}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryStrong,
                  ),
                ),
                TextSpan(
                  text: ' / 3',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            slide.title,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            slide.desc,
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          SizedBox(height: 24.h),
          AspectRatio(
            aspectRatio: 16 / 11,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [slide.illustBg, const Color(0xFFFBD9E3)],
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusCard),
              ),
              child: Center(
                child: Text(
                  slide.illustEmoji,
                  style: TextStyle(fontSize: 96.sp),
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          for (final h in slide.highlights) ...[
            _Highlight(icon: h.$1, iconBg: h.$2, title: h.$3, desc: h.$4),
            SizedBox(height: 12.h),
          ],
        ],
      ),
    );
  }
}

class _Highlight extends StatelessWidget {
  const _Highlight({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.desc,
  });
  final IconData icon;
  final Color iconBg;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSizes.radiusButton),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, color: AppColors.primaryStrong, size: 24.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    color: AppColors.textSecondary,
                    height: 1.5,
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

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: active ? 20.w : 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: active ? AppColors.primaryStrong : const Color(0xFFF5C2D1),
            borderRadius: BorderRadius.circular(999.r),
          ),
        );
      }),
    );
  }
}
