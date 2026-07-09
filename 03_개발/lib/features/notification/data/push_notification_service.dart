import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:convert';

import '../domain/app_notification.dart';
import 'notification_repository.dart';

/// FCM 토큰·권한·포그라운드 알림 처리.
class PushNotificationService {
  PushNotificationService({
    required FirebaseMessaging messaging,
    required FlutterLocalNotificationsPlugin localNotifications,
    NotificationRepository? repository,
  })  : _messaging = messaging,
        _local = localNotifications,
        _repository = repository;

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _local;
  NotificationRepository? _repository;
  final _routes = StreamController<String>.broadcast();

  static const _channelId = 'moms_time_default';
  static const _channelName = 'Mom\'s Time 알림';

  Stream<String> get routeStream => _routes.stream;

  void attachRepository(NotificationRepository repository) {
    _repository = repository;
  }

  Future<bool> initialize() async {
    await _initLocalNotifications();

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final granted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onOpenedApp);
    _messaging.onTokenRefresh.listen((token) async {
      try {
        final repo = _repository;
        if (repo != null) await repo.saveFcmToken(token);
      } catch (e) {
        debugPrint('[FCM] 토큰 갱신 저장 실패: $e');
      }
    });

    return granted;
  }

  Future<void> handleInitialMessage() async {
    try {
      final message = await _messaging.getInitialMessage();
      if (message != null) _emitRouteFrom(message.data);
    } catch (e) {
      debugPrint('[FCM] initial message 확인 실패: $e');
    }
  }

  Future<String?> syncToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null && _repository != null) {
        await _repository!.saveFcmToken(token);
      }
      return token;
    } catch (e) {
      debugPrint('[FCM] 토큰 동기화 실패: $e');
      return null;
    }
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _local.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (resp) {
        final payload = resp.payload;
        if (payload == null || payload.trim().isEmpty) return;
        try {
          final map = jsonDecode(payload);
          if (map is Map) {
            final route = map['actionRoute']?.toString().trim();
            if (route != null && route.isNotEmpty) _routes.add(route);
          }
        } catch (e) {
          debugPrint('[FCM] local payload 파싱 실패: $e');
        }
      },
    );

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      importance: Importance.high,
    );
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification != null) {
      final payload = jsonEncode(message.data);
      await _local.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: payload,
      );
    }

    final repo = _repository;
    if (repo == null) return;
    final data = message.data;
    await repo.add(AppNotification(
      id: '',
      title: notification?.title ?? data['title'] as String? ?? '알림',
      body: notification?.body ?? data['body'] as String? ?? '',
      type: NotificationType.fromKey(data['type'] as String?),
      actionLabel: data['actionLabel'] as String? ?? '',
      actionRoute: data['actionRoute'] as String? ?? '',
    ));
  }

  void _onOpenedApp(RemoteMessage message) {
    debugPrint('[FCM] 알림 탭: ${message.data}');
    _emitRouteFrom(message.data);
  }

  void _emitRouteFrom(Map<String, dynamic> data) {
    final route = (data['actionRoute'] as String?)?.trim();
    if (route != null && route.isNotEmpty) _routes.add(route);
  }

  void dispose() {
    _routes.close();
  }
}
