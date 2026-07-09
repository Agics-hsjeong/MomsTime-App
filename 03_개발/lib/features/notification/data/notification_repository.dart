import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/app_notification.dart';
import '../domain/notification_settings.dart';

/// Firestore `users/{uid}/notifications` + 알림 설정.
class NotificationRepository {
  NotificationRepository(this._db, this._uid);

  final FirebaseFirestore _db;
  final String _uid;

  DocumentReference<Map<String, dynamic>> get _user =>
      _db.collection('users').doc(_uid);

  CollectionReference<Map<String, dynamic>> get _notifications =>
      _user.collection('notifications');

  Stream<List<AppNotification>> watchAll() {
    return _notifications
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => AppNotification.fromMap(d.id, d.data()))
            .toList());
  }

  Stream<NotificationSettings> watchSettings() {
    return _user.snapshots().map((snap) {
      final map = snap.data()?['notificationSettings'];
      if (map is Map<String, dynamic>) {
        return NotificationSettings.fromMap(map);
      }
      return const NotificationSettings();
    });
  }

  Future<void> saveSettings(NotificationSettings settings) async {
    await _user.set(
      {
        'notificationSettings': settings.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> saveFcmToken(String token) async {
    await _user.set(
      {
        'fcmToken': token,
        'fcmUpdatedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> markRead(String id) async {
    await _notifications.doc(id).update({'read': true});
  }

  Future<void> markAllRead() async {
    final snap = await _notifications.where('read', isEqualTo: false).get();
    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
  }

  Future<void> add(AppNotification notification) async {
    await _notifications.add({
      ...notification.toMap(),
      'sentAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteAll() async {
    final snap = await _notifications.get();
    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
