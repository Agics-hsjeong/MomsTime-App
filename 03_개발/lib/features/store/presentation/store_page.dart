import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_frame.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/section_header.dart';

const _purple = Color(0xFF6D4FD0);

/// 스토어 — 퍼블리싱 32_store.html
class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(bottom: 32.h),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 0),
              child: Row(
                children: [
                  SizedBox(width: 40.w),
                  Expanded(
                    child: Text(
                      'Mom\'s Store',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.shopping_cart_rounded, size: 26.sp),
                      ),
                      Positioned(
                        right: 4.w,
                        top: 4.h,
                        child: Container(
                          constraints: BoxConstraints(minWidth: 18.w),
                          height: 18.w,
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            color: _purple,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '2',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppContent(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 52.h,
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded,
                            color: AppColors.textDisabled, size: 22.sp),
                        SizedBox(width: 10.w),
                        Text(
                          '영양제, 건강식품 검색',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.textDisabled,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AppCard(
                    color: const Color(0xFFF0EAFC),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: _purple,
                                borderRadius: BorderRadius.circular(999.r),
                              ),
                              child: Text(
                                'NEW',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              '임산부 맞춤\n영양제 컬렉션',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            SizedBox(
                              width: 220.w,
                              child: Text(
                                '전문가가 엄선한 임신·출산 필수 영양제를 만나보세요.',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.textSecondary,
                                  height: 1.6,
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: _purple, width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999.r),
                                ),
                                minimumSize: Size(0, 42.h),
                              ),
                              child: Text(
                                '컬렉션 보기 ›',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: _purple,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Text('💊', style: TextStyle(fontSize: 76.sp)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8.h,
                    crossAxisSpacing: 8.w,
                    childAspectRatio: 0.85,
                    children: const [
                      _Cat(Icons.water_drop_rounded, Color(0xFFE7F0FB), '오메가3'),
                      _Cat(Icons.favorite_rounded, Color(0xFFFDEFF3), '엽산·철분'),
                      _Cat(Icons.brightness_5_rounded, Color(0xFFFDF3E4), '비타민'),
                      _Cat(Icons.child_care_rounded, Color(0xFFE8F5EC), '임산부'),
                      _Cat(Icons.bedtime_rounded, Color(0xFFEFE9FC), '수면·휴식'),
                      _Cat(Icons.restaurant_rounded, Color(0xFFE4F5F2), '건강식품'),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  SectionHeader(title: '인기 상품', moreLabel: '전체 보기'),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 220.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _ProductCard(
                          badge: 'BEST',
                          badgeColor: const Color(0xFFFDF3E4),
                          badgeTextColor: AppColors.warning,
                          emoji: '💊',
                          name: '닥터웰 오메가3\nrTG 1200',
                          price: '25,600원',
                          rate: '4.8',
                          onTap: () => context.push(Routes.supplementDetail),
                        ),
                        _ProductCard(
                          badge: 'NEW',
                          badgeColor: _purple,
                          badgeTextColor: Colors.white,
                          emoji: '🌿',
                          name: '임산부 엽산\n플러스',
                          price: '18,900원',
                          rate: '4.9',
                          onTap: () => context.push(Routes.supplementDetail),
                        ),
                        _ProductCard(
                          badge: 'SALE',
                          badgeColor: const Color(0xFFFDE7EF),
                          badgeTextColor: AppColors.primaryStrong,
                          emoji: '🥛',
                          name: '칼슘 마그네슘\n복합제',
                          price: '22,400원',
                          rate: '4.7',
                          onTap: () => context.push(Routes.supplementDetail),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SectionHeader(title: '추천 상품', moreLabel: '더보기'),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 220.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _ProductCard(
                          emoji: '🧴',
                          name: '프로바이오틱스\n유산균',
                          price: '29,800원',
                          rate: '4.6',
                          onTap: () => context.push(Routes.supplementDetail),
                        ),
                        _ProductCard(
                          emoji: '☀️',
                          name: '비타민 D3\n2000IU',
                          price: '15,200원',
                          rate: '4.8',
                          onTap: () => context.push(Routes.supplementDetail),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFE9FC),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.local_shipping_rounded,
                              color: _purple, size: 20.sp),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '3만원 이상 무료배송',
                                style: TextStyle(
                                  fontSize: 14.5.sp,
                                  fontWeight: FontWeight.w800,
                                  color: _purple,
                                ),
                              ),
                              Text(
                                '오늘 주문 시 내일 도착 (서울·경기 기준)',
                                style: TextStyle(
                                  fontSize: 12.5.sp,
                                  color: AppColors.textSecondary,
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
          ],
        ),
      ),
    );
  }
}

class _Cat extends StatelessWidget {
  const _Cat(this.icon, this.bg, this.label);
  final IconData icon;
  final Color bg;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 54.w,
            height: 54.w,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, color: _purple, size: 24.sp),
          ),
          SizedBox(height: 8.h),
          Text(label,
              style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    this.badge,
    this.badgeColor,
    this.badgeTextColor,
    required this.emoji,
    required this.name,
    required this.price,
    required this.rate,
    required this.onTap,
  });

  final String? badge;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final String emoji;
  final String name;
  final String price;
  final String rate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150.w,
        margin: EdgeInsets.only(right: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F1F7),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                      child: Text(emoji, style: TextStyle(fontSize: 56.sp))),
                ),
                if (badge != null)
                  Positioned(
                    left: 8.w,
                    top: 8.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        badge!,
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w800,
                          color: badgeTextColor,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  right: 8.w,
                  top: 8.h,
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.favorite_border_rounded,
                        size: 17.sp, color: AppColors.textDisabled),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(name,
                style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w600, height: 1.4)),
            SizedBox(height: 6.h),
            Text(price,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: _purple,
                )),
            Text('⭐ $rate',
                style: TextStyle(
                    fontSize: 12.sp, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
