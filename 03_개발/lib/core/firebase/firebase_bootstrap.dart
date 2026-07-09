import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';
import 'fcm_bootstrap.dart';

/// Firebase 초기화 성공 여부.
/// `flutterfire configure` 전(자리표시자 상태)에는 false 로 남아
/// 앱은 실행되되 인증/DB 연동은 비활성 상태가 됩니다.
bool firebaseReady = false;

Future<void> initFirebase() async {
  if (!DefaultFirebaseOptions.isConfigured) {
    debugPrint(
      '[Firebase] 설정 전(placeholder) 상태입니다. '
      '`flutterfire configure` 실행 후 실제 연동이 활성화됩니다.',
    );
    return;
  }
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
    debugPrint('[Firebase] 초기화 완료');
    await initFcm();
  } catch (e) {
    firebaseReady = false;
    debugPrint('[Firebase] 초기화 실패: $e');
  }
}
