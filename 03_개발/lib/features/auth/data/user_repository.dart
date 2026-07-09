import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/app_user.dart';

/// Firestore `users/{uid}` 문서 접근.
class UserRepository {
  UserRepository(this._db);

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection('users').doc(uid);

  Future<AppUser?> fetch(String uid) async {
    final snap = await _doc(uid).get();
    final data = snap.data();
    if (data == null) return null;
    return AppUser.fromMap(uid, data);
  }

  Stream<AppUser?> watch(String uid) {
    return _doc(uid).snapshots().map((snap) {
      final data = snap.data();
      if (data == null) return null;
      return AppUser.fromMap(uid, data);
    });
  }

  Future<void> create(AppUser user) async {
    await _doc(user.uid).set(user.toCreateMap(), SetOptions(merge: true));
  }

  Future<void> update(String uid, Map<String, dynamic> fields) async {
    await _doc(uid).update({
      ...fields,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> exists(String uid) async {
    final snap = await _doc(uid).get();
    return snap.exists;
  }
}
