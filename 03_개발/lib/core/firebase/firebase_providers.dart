import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_bootstrap.dart';

/// Firebase 초기화(설정) 완료 여부.
final firebaseReadyProvider = Provider<bool>((ref) => firebaseReady);

/// FirebaseAuth 인스턴스.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Cloud Firestore 인스턴스.
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Cloud Functions 인스턴스.
final firebaseFunctionsProvider = Provider<FirebaseFunctions>((ref) {
  // Functions를 한국 리전에 배포해 지연을 줄입니다.
  return FirebaseFunctions.instanceFor(region: 'asia-northeast3');
});
