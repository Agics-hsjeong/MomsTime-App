import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/health_record.dart';

/// Firestore `users/{uid}/health_records` 접근.
class HealthRepository {
  HealthRepository(this._db, this._uid);

  final FirebaseFirestore _db;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('users').doc(_uid).collection('health_records');

  Stream<List<HealthRecord>> watchAll() {
    return _col
        .orderBy('recordedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => HealthRecord.fromMap(d.id, d.data()))
            .toList());
  }

  Future<String> add(HealthRecord record) async {
    final ref = await _col.add({
      ...record.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }
}
