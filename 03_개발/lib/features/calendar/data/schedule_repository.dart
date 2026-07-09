import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/schedule.dart';

/// Firestore `users/{uid}/schedules` 접근.
class ScheduleRepository {
  ScheduleRepository(this._db, this._uid);

  final FirebaseFirestore _db;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('users').doc(_uid).collection('schedules');

  Stream<List<Schedule>> watchAll() {
    return _col.orderBy('date').snapshots().map(
        (snap) => snap.docs.map((d) => Schedule.fromMap(d.id, d.data())).toList());
  }

  Future<String> add(Schedule schedule) async {
    final ref = await _col.add({
      ...schedule.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Future<void> toggleCompleted(String id, bool completed) async {
    await _col.doc(id).update({'completed': completed});
  }

  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }
}
