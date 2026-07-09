import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';

/// Mom's Time 브랜드 로고 (하트 라인 아트).
/// 퍼블리싱의 SVG 로고를 CustomPainter로 재현.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.w,
      height: size.w,
      child: CustomPaint(painter: _HeartLogoPainter()),
    );
  }
}

class _HeartLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final rect = Offset.zero & size;
    const gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF58BA8), Color(0xFFEF4B77)],
    );
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.055
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = gradient.createShader(rect);

    // 큰 하트
    final heart = Path()
      ..moveTo(w * 0.5, h * 0.30)
      ..cubicTo(w * 0.43, h * 0.12, w * 0.10, h * 0.14, w * 0.11, h * 0.40)
      ..cubicTo(w * 0.12, h * 0.63, w * 0.30, h * 0.78, w * 0.5, h * 0.92)
      ..cubicTo(w * 0.70, h * 0.78, w * 0.88, h * 0.63, w * 0.89, h * 0.40)
      ..cubicTo(w * 0.90, h * 0.14, w * 0.57, h * 0.12, w * 0.5, h * 0.30)
      ..close();
    canvas.drawPath(heart, stroke);

    // 안쪽 아기 곡선 (c 모양)
    final baby = Path()
      ..moveTo(w * 0.56, h * 0.42)
      ..cubicTo(w * 0.46, h * 0.44, w * 0.44, h * 0.58, w * 0.52, h * 0.64)
      ..cubicTo(w * 0.57, h * 0.68, w * 0.63, h * 0.66, w * 0.66, h * 0.62);
    canvas.drawPath(baby, stroke..strokeWidth = w * 0.045);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 로고 + 브랜드명 세로 조합
class BrandLockup extends StatelessWidget {
  const BrandLockup({
    super.key,
    this.logoSize = 96,
    this.nameSize = 34,
  });

  final double logoSize;
  final double nameSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrandLogo(size: logoSize),
        SizedBox(height: 16.h),
        Text(
          "Mom's Time",
          style: TextStyle(
            fontSize: nameSize.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryStrong,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          '엄마의 건강한 하루를 위한 동반자',
          style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
