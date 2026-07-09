import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../domain/app_notification.dart';
import '../domain/notification_settings.dart' as app;
import '../data/notification_repository.dart';
import '../data/push_notification_service.dart';
import '../../../core/firebase/firebase_providers.dart';

final notificationRepositoryProvider = Provider<NotificationRepository?>((ref) {
  if (!ref.watch(firebaseReadyProvider)) return null;
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return null;
  return NotificationRepository(ref.watch(firestoreProvider), uid);
});

final notificationsProvider = StreamProvider<List<AppNotification>>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  if (repo == null) return Stream.value(const <AppNotification>[]);
  return repo.watchAll();
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  final items = ref.watch(notificationsProvider).value ?? const [];
  return items.where((n) => !n.read).length;
});

final notificationSettingsProvider =
    StreamProvider<app.NotificationSettings>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  if (repo == null) return Stream.value(const app.NotificationSettings());
  return repo.watchSettings();
});

final localNotificationsPluginProvider =
    Provider<FlutterLocalNotificationsPlugin>((ref) {
  return FlutterLocalNotificationsPlugin();
});

final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});

final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  final service = PushNotificationService(
    messaging: ref.watch(firebaseMessagingProvider),
    localNotifications: ref.watch(localNotificationsPluginProvider),
    repository: ref.watch(notificationRepositoryProvider),
  );
  ref.listen(notificationRepositoryProvider, (prev, next) {
    if (next != null) service.attachRepository(next);
  });
  return service;
});

class NotificationController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  NotificationRepository? get _repo => ref.read(notificationRepositoryProvider);

  Future<void> markRead(String id) async {
    await _repo?.markRead(id);
  }

  Future<void> markAllRead() async {
    await _repo?.markAllRead();
  }

  Future<void> saveSettings(app.NotificationSettings settings) async {
    final repo = _repo;
    if (repo == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.saveSettings(settings));
  }
}

final notificationControllerProvider =
    AsyncNotifierProvider<NotificationController, void>(
        NotificationController.new);

/// 알림 탭 필터.
class NotificationTabFilter extends Notifier<int> {
  @override
  int build() => 0;
  void set(int index) => state = index;
}

final notificationTabFilterProvider =
    NotifierProvider<NotificationTabFilter, int>(NotificationTabFilter.new);

final filteredNotificationsProvider = Provider<List<AppNotification>>((ref) {
  final tab = ref.watch(notificationTabFilterProvider);
  final items = ref.watch(notificationsProvider).value ?? const [];
  if (tab == 0) return items;
  const tabTypes = [
    null,
    NotificationType.medication,
    NotificationType.checkup,
    NotificationType.booking,
    NotificationType.system,
  ];
  final type = tabTypes[tab];
  if (type == null) return items;
  return items.where((n) => n.type == type).toList();
});
