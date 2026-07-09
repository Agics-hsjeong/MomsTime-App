import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/primary_button.dart';

/// OCR 인식 결과 — 퍼블리싱 17_ocr_result.html
class OcrResultPage extends StatelessWidget {
  const OcrResultPage({super.key});

  static const _drugs = [
    ('1', '아목시실린정 250mg', '(항생제)', '1 정', '2 회', '7 일'),
    ('2', '클라리트로마이신정 250mg', '(항생제)', '1 정', '2 회', '7 일'),
    ('3', '베포타스틴정 10mg', '(항히스타민제)', '1 정', '1 회', '7 일'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: 'OCR 결과',
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert_rounded, size: 24.sp),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              children: [
                // 인식 완료 배너
                AppCard(
                  color: const Color(0xFFFDEFF3),
                  child: Row(
                    children: [
                      Container(
                        width: 56.w,
                        height: 56.w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryStrong,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x59F2547F),
                              blurRadius: 14.r,
                              offset: Offset(0, 6.h),
                            ),
                          ],
                        ),
                        child: Icon(Icons.check_rounded,
                            color: Colors.white, size: 30.sp),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '처방전을 인식했어요!',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '아래 내용이 맞는지 확인해주세요.',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: AppColors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 0),
                          minimumSize: Size(0, 44.h),
                        ),
                        icon: Icon(Icons.edit_rounded,
                            size: 16.sp, color: AppColors.primaryStrong),
                        label: Text(
                          '수정하기',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryStrong,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // 원본 이미지 (처방전 목업)
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '원본 이미지',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      const _RxPaper(),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // 인식된 정보
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '인식된 정보',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      const _RecGrid(),
                      SizedBox(height: 16.h),
                      const _RecTable(),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 16.sp, color: const Color(0xFF3B82F6)),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              '인식 결과가 다르다면 \'수정하기\'를 눌러 직접 수정할 수 있어요.',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // 정확도 팁
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF1FC),
                    borderRadius: BorderRadius.circular(AppSizes.radiusCard),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.verified_user_rounded,
                          size: 40.sp, color: const Color(0xFF7C5CD6)),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '정확도를 높이는 팁',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            _tipItem('조명이 밝은 곳에서 촬영해주세요.'),
                            _tipItem('글자가 흔들리지 않게 정면에서 촬영해주세요.'),
                            _tipItem('처방전 전체가 보이도록 촬영해주세요.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 8.h),
            child: Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: '다시 촬영하기',
                    onPressed: () => context.pop(),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    label: '복약 등록하기',
                    icon: Icons.check_circle_rounded,
                    onPressed: () {
                      context.pop({
                        'name': '철분제',
                        'type': '영양제',
                        'maker': '훼로바',
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_rounded,
                    size: 15.sp, color: AppColors.textDisabled),
                SizedBox(width: 6.w),
                Text(
                  'OCR로 인식된 정보는 안전하게 처리됩니다.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tipItem(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ',
              style: TextStyle(color: const Color(0xFF3B82F6), fontSize: 12.sp)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RxPaper extends StatelessWidget {
  const _RxPaper();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAF8),
        border: Border.all(color: const Color(0xFFE8E8E4)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            '처방전',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 12,
            ),
          ),
          SizedBox(height: 14.h),
          Divider(color: const Color(0xFF666666), thickness: 1.5),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(child: _meta('병·의원명', '○○○내과의원')),
              Expanded(child: _meta('처방일', '2024-06-02')),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(child: _meta('전화번호', '042-XXX-XXXX')),
              Expanded(child: _meta('의사명', '김하나')),
            ],
          ),
          SizedBox(height: 12.h),
          Table(
            border: TableBorder.all(color: const Color(0xFFC9C9C4)),
            columnWidths: const {
              0: FixedColumnWidth(28),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: const BoxDecoration(color: Color(0xFFF0F0EC)),
                children: [
                  _th('Rp.'),
                  _th('약 품 명'),
                  _th('1회\n투약량'),
                  _th('1일\n투여횟수'),
                  _th('총\n투약일수'),
                ],
              ),
              for (final d in OcrResultPage._drugs)
                TableRow(
                  children: [
                    _td(d.$1, center: true),
                    _td('${d.$2}\n${d.$3}', align: TextAlign.left),
                    _td(d.$4, center: true),
                    _td(d.$5, center: true),
                    _td(d.$6, center: true),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _meta(String label, String value) {
    return Text(
      '$label  $value',
      style: TextStyle(fontSize: 12.sp, color: const Color(0xFF3A3A3A)),
    );
  }

  Widget _th(String text) => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700),
        ),
      );

  Widget _td(String text,
          {bool center = false, TextAlign align = TextAlign.center}) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        child: Text(
          text,
          textAlign: align,
          style: TextStyle(fontSize: 11.sp),
        ),
      );
}

class _RecGrid extends StatelessWidget {
  const _RecGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: _RecItem(Icons.calendar_month_rounded, '처방일', '2024.06.02')),
            Expanded(child: _RecItem(null, '의사명', '김하나', emoji: '🧑‍⚕️')),
          ],
        ),
        SizedBox(height: 14.h),
        Row(
          children: const [
            Expanded(child: _RecItem(Icons.local_hospital_rounded, '병·의원명', '○○○내과의원')),
            Expanded(child: _RecItem(Icons.call_rounded, '전화번호', '042-XXX-XXXX', iconColor: Color(0xFF22A050))),
          ],
        ),
      ],
    );
  }
}

class _RecItem extends StatelessWidget {
  const _RecItem(this.icon, this.label, this.value, {this.emoji, this.iconColor});

  final IconData? icon;
  final String label;
  final String value;
  final String? emoji;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12.r),
          ),
          alignment: Alignment.center,
          child: icon != null
              ? Icon(icon, size: 20.sp, color: iconColor ?? AppColors.primaryStrong)
              : Text(emoji!, style: TextStyle(fontSize: 20.sp)),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11.sp, color: AppColors.textSecondary)),
              Text(value,
                  style: TextStyle(
                      fontSize: 14.sp, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecTable extends StatelessWidget {
  const _RecTable();

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: const Color(0xFFFBE9F0),
            borderRadius: BorderRadius.circular(10.r),
          ),
          children: [
            _th('약품명'),
            _th('1회 투약량'),
            _th('1일 투여횟수'),
            _th('총 투약일수'),
          ],
        ),
        for (final d in OcrResultPage._drugs)
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
                child: Row(
                  children: [
                    Container(
                      width: 26.w,
                      height: 26.w,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        d.$1,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryStrong,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(d.$2,
                              style: TextStyle(
                                  fontSize: 13.sp, fontWeight: FontWeight.w700)),
                          Text(d.$3,
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _td(d.$4),
              _td(d.$5),
              _td(d.$6),
            ],
          ),
      ],
    );
  }

  Widget _th(String text) => Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
        ),
      );

  Widget _td(String text) => Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13.sp),
        ),
      );
}
