import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_providers.dart';
import '../../features/notification/application/notification_providers.dart';
import 'firebase_providers.dart';

/// 로그인 후 FCM 권한·토큰을 동기화합니다.
class PushNotificationBootstrap extends ConsumerStatefulWidget {
  const PushNotificationBootstrap({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<PushNotificationBootstrap> createState() =>
      _PushNotificationBootstrapState();
}

class _PushNotificationBootstrapState
    extends ConsumerState<PushNotificationBootstrap> {
  bool _listening = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncPush());
  }

  Future<void> _syncPush() async {
    if (!ref.read(firebaseReadyProvider)) return;
    if (ref.read(authStateProvider).value == null) return;
    final service = ref.read(pushNotificationServiceProvider);
    await service.initialize();
    await service.syncToken();
    await service.handleInitialMessage();

    if (!_listening) {
      _listening = true;
      service.routeStream.listen((route) {
        if (!mounted) return;
        try {
          // route가 잘못된 경우 크래시 방지
          if (route.trim().isNotEmpty) context.push(route.trim());
        } catch (_) {}
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, (prev, next) {
      if (prev?.value == null && next.value != null) {
        _syncPush();
      }
    });
    return widget.child;
  }
}
