import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../features/notification/application/notification_providers.dart';
import 'notification_bell.dart';

/// Riverpod과 연결된 알림 벨.
class ConnectedNotificationBell extends ConsumerWidget {
  const ConnectedNotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(unreadNotificationCountProvider);
    return NotificationBell(
      count: count,
      onTap: () => context.push(Routes.notifications),
    );
  }
}
