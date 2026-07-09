import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_tabs.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../notification/application/notification_providers.dart';
import '../../notification/domain/app_notification.dart';

/// 알림 목록 — 퍼블리싱 26_notification.html
class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  static const _tabs = ['전체', '복약', '검진', '예약', '공지'];

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(notificationTabFilterProvider);
    final notifications = ref.watch(filteredNotificationsProvider);
    final unread = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: '알림',
        leading: SizedBox(width: 40.w),
        actions: [
          IconButton(
            onPressed: () => context.push(Routes.notificationSettings),
            icon: Icon(Icons.settings_rounded, size: 24.sp),
          ),
        ],
      ),
      body: Column(
        children: [
          AppTabs(
            labels: _tabs,
            index: tab,
            onChanged: (i) =>
                ref.read(notificationTabFilterProvider.notifier).set(i),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
              children: [
                if (unread > 0)
                  AppCard(
                    color: const Color(0xFFF4F0FE),
                    child: Row(
                      children: [
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFF7C5CD6),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.notifications_active_rounded,
                              color: Colors.white, size: 24.sp),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Text(
                            '읽지 않은 알림이 $unread개 있어요.',
                            style: TextStyle(fontSize: 13.5.sp, height: 1.6),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () => context.push(Routes.notificationSettings),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF7C5CD6)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.w, vertical: 0),
                            minimumSize: Size(0, 42.h),
                          ),
                          child: Text(
                            '알림 설정',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF7C5CD6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (unread > 0) SizedBox(height: 24.h),
                if (notifications.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 48.h),
                    child: Text(
                      '알림이 없어요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                else ...[
                  Text(
                    '최근',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Divider(height: 24.h, color: AppColors.divider),
                  for (final item in notifications) _NotiItem(item: item),
                ],
                if (notifications.isNotEmpty) ...[
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => ref
                            .read(notificationControllerProvider.notifier)
                            .markAllRead(),
                        child: Row(
                          children: [
                            Icon(Icons.done_all_rounded,
                                size: 18.sp, color: AppColors.textSecondary),
                            SizedBox(width: 6.w),
                            Text(
                              '모두 읽음 처리',
                              style: TextStyle(
                                fontSize: 13.5.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotiItem extends ConsumerWidget {
  const _NotiItem({required this.item});
  final AppNotification item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = _styleFor(item.type);
    final time = item.sentAt == null
        ? ''
        : DateFormat('a h:mm', 'ko').format(item.sentAt!);

    return GestureDetector(
      onTap: () async {
        await ref.read(notificationControllerProvider.notifier).markRead(item.id);
        final route = item.actionRoute.trim();
        if (route.isNotEmpty) {
          try {
            if (context.mounted) context.push(route);
          } catch (_) {}
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 18.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(color: style.bg, shape: BoxShape.circle),
              child: Icon(style.icon, color: style.color, size: 24.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w700)),
                  SizedBox(height: 4.h),
                  Text(item.body,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                        height: 1.55,
                      )),
                  if (item.actionLabel.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Text(
                      item.actionLabel,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF7C5CD6),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (time.isNotEmpty)
                  Text(time,
                      style: TextStyle(
                          fontSize: 12.sp, color: AppColors.textSecondary)),
                if (!item.read) ...[
                  SizedBox(height: 22.h),
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF7C5CD6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  ({IconData icon, Color bg, Color color}) _styleFor(NotificationType type) {
    switch (type) {
      case NotificationType.medication:
        return (
          icon: Icons.medication_rounded,
          bg: const Color(0xFFE8F5EC),
          color: AppColors.primaryStrong,
        );
      case NotificationType.checkup:
        return (
          icon: Icons.science_rounded,
          bg: const Color(0xFFFDF0DC),
          color: AppColors.warning,
        );
      case NotificationType.booking:
        return (
          icon: Icons.assignment_rounded,
          bg: const Color(0xFFE7F0FB),
          color: const Color(0xFF7C5CD6),
        );
      case NotificationType.care:
        return (
          icon: Icons.favorite_rounded,
          bg: const Color(0xFFFDEFF3),
          color: AppColors.primaryStrong,
        );
      case NotificationType.system:
        return (
          icon: Icons.campaign_rounded,
          bg: const Color(0xFFE4EEFC),
          color: const Color(0xFF3B82F6),
        );
    }
  }
}
