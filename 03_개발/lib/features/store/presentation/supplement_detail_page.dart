import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/app_frame.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/status_chip.dart';

const _purple = Color(0xFF7C5CD6);

/// 영양제 상세 — 퍼블리싱 24_supplement_detail.html
class SupplementDetailPage extends StatefulWidget {
  const SupplementDetailPage({super.key});

  @override
  State<SupplementDetailPage> createState() => _SupplementDetailPageState();
}

class _SupplementDetailPageState extends State<SupplementDetailPage> {
  int _tab = 0;
  static const _tabs = ['상품 정보', '성분 정보', '복용 가이드', '리뷰 (124)'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: '영양제 상세',
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share_rounded, size: 26.sp)),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite_rounded,
                size: 26.sp, color: AppColors.primaryStrong),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 24.h),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150.w,
                        height: 220.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFF4F1EC), Color(0xFFE8E2D8)],
                          ),
                        ),
                        child: Icon(Icons.sanitizer_rounded,
                            size: 64.sp, color: _purple),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 6.w,
                              children: [
                                StatusChip(
                                  label: '인기',
                                  height: 26.h,
                                  backgroundColor: Colors.transparent,
                                  color: _purple,
                                ),
                                StatusChip(
                                  label: '혈행·혈중 중성지질 개선',
                                  height: 26.h,
                                  backgroundColor: const Color(0xFFEFE9FC),
                                  color: _purple,
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              '닥터웰 오메가3 rTG 1200',
                              style: TextStyle(
                                fontSize: 21.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'EPA 및 DHA 함유 유지',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Text('⭐ 4.8 ',
                                    style: TextStyle(
                                        fontSize: 13.5.sp,
                                        fontWeight: FontWeight.w700)),
                                Text('(124)',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: _purple,
                                      decoration: TextDecoration.underline,
                                    )),
                                Text('  |  구매 12,345',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                            SizedBox(height: 14.h),
                            Row(
                              children: const [
                                _Effect(Icons.water_drop_rounded,
                                    Color(0xFF3B82F6), '혈행 개선', '도움'),
                                _Effect(Icons.favorite_rounded,
                                    AppColors.primaryStrong, '혈중 중성지질', '개선 도움'),
                                _Effect(Icons.visibility_rounded,
                                    Color(0xFF22A050), '눈 건강', '도움'),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            const Divider(color: AppColors.divider),
                            Text(
                              '건강기능식품  |  제조사 닥터웰바이오  |  국내 제조',
                              style: TextStyle(
                                fontSize: 11.5.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                AppContent(
                  child: AppCard(
                    child: Row(
                      children: const [
                        _Quick(Icons.verified_user_rounded,
                            Color(0xFFE8F5EC), _purple, '주요 효능'),
                        _Quick(Icons.medication_rounded,
                            Color(0xFFE7F0FB), AppColors.primaryStrong, '복용 방법'),
                        _Quick(Icons.schedule_rounded,
                            Color(0xFFEFE9FC), _purple, '복용 시간'),
                        _Quick(Icons.groups_rounded,
                            Color(0xFFFDF3E4), _purple, '권장 대상'),
                        _Quick(null, Color(0xFFF4F4F5), null, '목록 추가',
                            emoji: '🔖'),
                      ],
                    ),
                  ),
                ),
                _PurpleTabs(
                  labels: _tabs,
                  index: _tab,
                  onChanged: (i) => setState(() => _tab = i),
                ),
                SizedBox(height: 16.h),
                AppContent(
                  child: switch (_tab) {
                    0 => const _ProductPanel(),
                    1 => const _IngredientPanel(),
                    2 => const _GuidePanel(),
                    _ => const _ReviewPanel(),
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.divider),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('정상가 32,000원',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                              decoration: TextDecoration.lineThrough,
                            )),
                        Row(
                          children: [
                            Text('할인가 ',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary)),
                            Text('25,600원',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryStrong,
                                )),
                            Text(' (20%)',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryStrong,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 11,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            elevation: 4,
                          ),
                          child: Text('장바구니 담기',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: OutlinedButton(
                          onPressed: () => context.push(Routes.payment),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: _purple, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: Text('바로 구매하기',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w800,
                                  color: _purple)),
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
    );
  }
}

class _Effect extends StatelessWidget {
  const _Effect(this.icon, this.color, this.title, this.sub);
  final IconData icon;
  final Color color;
  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: const BoxDecoration(
              color: Color(0xFFEFE9FC),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 21.sp),
          ),
          SizedBox(height: 6.h),
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700)),
          Text(sub,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11.sp, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _Quick extends StatelessWidget {
  const _Quick(this.icon, this.bg, this.color, this.label, {this.emoji});
  final IconData? icon;
  final Color bg;
  final Color? color;
  final String label;
  final String? emoji;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Center(
              child: emoji != null
                  ? Text(emoji!, style: TextStyle(fontSize: 22.sp))
                  : Icon(icon, color: color, size: 22.sp),
            ),
          ),
          SizedBox(height: 8.h),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _PurpleTabs extends StatelessWidget {
  const _PurpleTabs({
    required this.labels,
    required this.index,
    required this.onChanged,
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        children: [
          for (var i = 0; i < labels.length; i++)
            GestureDetector(
              onTap: () => onChanged(i),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: i == index ? _purple : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: i == index ? _purple : AppColors.textDisabled,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductPanel extends StatelessWidget {
  const _ProductPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('상품 소개',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w800)),
                  Icon(Icons.expand_more_rounded,
                      color: AppColors.textDisabled),
                ],
              ),
              SizedBox(height: 8.h),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    color: AppColors.textSecondary,
                    height: 1.75,
                  ),
                  children: const [
                    TextSpan(
                      text: 'rTG 형태의 오메가3',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text:
                          '로 체내 흡수율을 높인 프리미엄 제품입니다.\nEPA 및 DHA 함유 유지로 혈행 개선, 혈중 중성지질 개선, 눈 건강에 도움을 줄 수 있습니다.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('주요 효능',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w800)),
                  Text('식약처 기능성 인정',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: _purple,
                      )),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: const [
                  _EffItem(Icons.bloodtype_rounded, Color(0xFFFDEFF3),
                      AppColors.primaryStrong, '혈행 개선에 도움'),
                  _EffItem(Icons.water_drop_rounded, Color(0xFFFDF3E4),
                      Color(0xFF3B82F6), '혈중 중성지질\n개선에 도움'),
                  _EffItem(Icons.visibility_rounded, Color(0xFFE8F5EC),
                      Color(0xFF22A050), '건조한 눈을 개선하여\n눈 건강에 도움'),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('권장 대상',
                  style: TextStyle(
                      fontSize: 16.sp, fontWeight: FontWeight.w800)),
              SizedBox(height: 12.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: const [
                        _TargetItem('혈행 개선이 필요하신 분'),
                        _TargetItem('혈중 중성지질 수치가 걱정되시는 분'),
                        _TargetItem('눈의 건조함을 자주 느끼시는 분'),
                        _TargetItem('불규칙한 식습관으로 영양 보충이 필요하신 분'),
                      ],
                    ),
                  ),
                  Container(
                    width: 130.w,
                    height: 120.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F0FE),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(Icons.groups_rounded,
                        size: 52.sp, color: AppColors.primaryStrong),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        AppCard(
          color: const Color(0xFFF4F0FE),
          child: Row(
            children: [
              Text('🤖', style: TextStyle(fontSize: 48.sp)),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AI 건강 추천',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF6D4FD0),
                        )),
                    Text(
                      '최근 검진 결과를 기반으로 오메가3 제품이 현재 건강 상태에 도움을 줄 수 있어요!',
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _purple),
                  minimumSize: Size(0, 44.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text('맞춤 추천 더보기 ›',
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: _purple)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IngredientPanel extends StatelessWidget {
  const _IngredientPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1일 섭취량 (2캡슐) 당',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w800)),
                  StatusChip(
                    label: '%기준치',
                    height: 28.h,
                    backgroundColor: const Color(0xFFEFE9FC),
                    color: _purple,
                  ),
                ],
              ),
              const _IngRow('EPA', '600mg', '—'),
              const _IngRow('DHA', '400mg', '—'),
              const _IngRow('오메가-3 (총합)', '1,200mg', '120%'),
              const _IngRow('비타민 E', '11mg', '100%'),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('원재료명',
                  style: TextStyle(
                      fontSize: 16.sp, fontWeight: FontWeight.w800)),
              SizedBox(height: 8.h),
              Text(
                '정제어유(rTG), 비타민E 혼합제제, 젤라틴, 글리세린, 정제수. 대두·어류(멸치) 함유.',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  color: AppColors.textSecondary,
                  height: 1.75,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Icon(Icons.info_outline_rounded, size: 15.sp, color: _purple),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                '알레르기 체질이거나 임신·수유 중이라면 섭취 전 전문가와 상담하세요.',
                style: TextStyle(
                    fontSize: 12.sp, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GuidePanel extends StatelessWidget {
  const _GuidePanel();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      child: Column(
        children: const [
          _GuideItem(Icons.medication_rounded, '섭취량',
              '1일 1회, 1회 2캡슐을 충분한 물과 함께 섭취하세요.'),
          _GuideItem(Icons.schedule_rounded, '섭취 시간',
              '흡수율을 높이려면 식사 직후에 드시는 것이 좋아요.'),
          _GuideItem(Icons.ac_unit_rounded, '보관 방법',
              '직사광선을 피해 서늘한 곳에 보관하고, 개봉 후엔 냉장 보관하세요.'),
          _GuideItem(Icons.warning_amber_rounded, '주의사항',
              '항응고제 복용 중이라면 의사와 상담하세요. 하루 권장량을 초과하지 마세요.'),
        ],
      ),
    );
  }
}

class _ReviewPanel extends StatelessWidget {
  const _ReviewPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          child: Row(
            children: [
              Column(
                children: [
                  Text('4.8',
                      style: TextStyle(
                        fontSize: 42.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF6D4FD0),
                      )),
                  Text('★★★★★',
                      style: TextStyle(
                          fontSize: 15.sp, color: AppColors.warning)),
                  Text('124개 리뷰',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary)),
                ],
              ),
              SizedBox(width: 18.w),
              Expanded(
                child: Column(
                  children: [
                    _RatingBar(5, 0.82),
                    _RatingBar(4, 0.12),
                    _RatingBar(3, 0.04),
                    _RatingBar(2, 0.01),
                    _RatingBar(1, 0.01),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        AppCard(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
          child: Column(
            children: const [
              _RevItem('★★★★★', '이**', '2024.05.28',
                  '비린내가 거의 없어서 매일 챙겨 먹기 좋아요. 캡슐도 크지 않아 삼키기 편해요.'),
              _RevItem('★★★★☆', '김**', '2024.05.20',
                  '임신 중에 먹으려고 구매했는데 상담 후 잘 복용하고 있어요. 배송도 빨랐습니다.'),
              _RevItem('★★★★★', '박**', '2024.05.11',
                  '가격 대비 함량이 좋아요. 재구매 의사 있습니다!'),
            ],
          ),
        ),
      ],
    );
  }
}

class _EffItem extends StatelessWidget {
  const _EffItem(this.icon, this.bg, this.color, this.text);
  final IconData icon;
  final Color bg;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: AppColors.divider)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
        child: Column(
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(height: 10.h),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

class _TargetItem extends StatelessWidget {
  const _TargetItem(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded, size: 18.sp, color: _purple),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 13.sp, height: 2)),
          ),
        ],
      ),
    );
  }
}

class _IngRow extends StatelessWidget {
  const _IngRow(this.name, this.amt, this.pct);
  final String name;
  final String amt;
  final String pct;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13.h),
      child: Row(
        children: [
          Expanded(
            child: Text(name,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
          ),
          Text(amt,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800)),
          SizedBox(
            width: 66.w,
            child: Text(pct,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 12.sp, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}

class _GuideItem extends StatelessWidget {
  const _GuideItem(this.icon, this.title, this.desc);
  final IconData icon;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: const Color(0xFFEFE9FC),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: _purple, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.w700)),
                Text(desc,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  const _RatingBar(this.star, this.fill);
  final int star;
  final double fill;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Text('$star',
              style: TextStyle(
                  fontSize: 11.sp, color: AppColors.textSecondary)),
          SizedBox(width: 8.w),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999.r),
              child: LinearProgressIndicator(
                value: fill,
                minHeight: 6.h,
                backgroundColor: const Color(0xFFEFEFEF),
                color: _purple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RevItem extends StatelessWidget {
  const _RevItem(this.stars, this.name, this.date, this.text);
  final String stars;
  final String name;
  final String date;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(stars,
                  style: TextStyle(
                      fontSize: 13.sp, color: AppColors.warning)),
              SizedBox(width: 8.w),
              Text(name,
                  style: TextStyle(
                      fontSize: 13.sp, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text(date,
                  style: TextStyle(
                      fontSize: 11.sp, color: AppColors.textDisabled)),
            ],
          ),
          SizedBox(height: 8.h),
          Text(text,
              style: TextStyle(fontSize: 13.sp, height: 1.6)),
        ],
      ),
    );
  }
}
