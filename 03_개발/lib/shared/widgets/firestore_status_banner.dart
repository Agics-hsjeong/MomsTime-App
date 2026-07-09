import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/firebase/firebase_bootstrap.dart';
import '../../core/theme/app_colors.dart';
import '../../features/auth/application/auth_providers.dart';
import 'app_card.dart';

/// Firestore 연결/프로필 로딩 상태 안내 배너.
class FirestoreStatusBanner extends ConsumerWidget {
  const FirestoreStatusBanner({super.key, this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!firebaseReady) return const SizedBox.shrink();

    final profileAsync = ref.watch(currentUserProfileProvider);
    if (profileAsync.hasError) {
      return _Banner(
        compact: compact,
        color: const Color(0xFFFDEFF3),
        icon: Icons.cloud_off_rounded,
        iconColor: AppColors.primaryStrong,
        message:
            'Firestore가 아직 활성화되지 않았어요.\nFirebase 콘솔에서 Database를 생성해주세요.',
      );
    }
    if (profileAsync.isLoading) {
      return _Banner(
        compact: compact,
        color: const Color(0xFFF4F0FE),
        icon: Icons.hourglass_top_rounded,
        iconColor: const Color(0xFF7C5CD6),
        message: '프로필을 불러오는 중이에요…',
      );
    }
    return const SizedBox.shrink();
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.compact,
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.message,
  });

  final bool compact;
  final Color color;
  final IconData icon;
  final Color iconColor;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, compact ? 8.h : 12.h, 20.w, 0),
      child: AppCard(
        color: color,
        padding: EdgeInsets.all(compact ? 14.w : 16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: compact ? 20.sp : 22.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: compact ? 12.sp : 13.sp,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
