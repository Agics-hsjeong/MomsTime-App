import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

/// 백그라운드 FCM 수신 핸들러 (top-level).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (!DefaultFirebaseOptions.isConfigured) return;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('[FCM] 백그라운드 메시지: ${message.messageId}');
}

/// FCM 초기화 — Firebase 초기화 이후 호출.
Future<void> initFcm() async {
  if (!DefaultFirebaseOptions.isConfigured) return;
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}
