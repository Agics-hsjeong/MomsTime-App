import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/medication.dart';

/// Firestore `users/{uid}/medications` + `medication_logs` 접근.
class MedicationRepository {
  MedicationRepository(this._db, this._uid);

  final FirebaseFirestore _db;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _meds =>
      _db.collection('users').doc(_uid).collection('medications');

  CollectionReference<Map<String, dynamic>> get _logs =>
      _db.collection('users').doc(_uid).collection('medication_logs');

  /// 활성 약 목록(실시간).
  Stream<List<Medication>> watchMedications() {
    return _meds
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Medication.fromMap(d.id, d.data()))
            .toList());
  }

  Future<Medication?> fetch(String id) async {
    final snap = await _meds.doc(id).get();
    final data = snap.data();
    if (data == null) return null;
    return Medication.fromMap(id, data);
  }

  Future<String> add(Medication med) async {
    final ref = await _meds.add({
      ...med.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Future<void> update(String id, Medication med) async {
    await _meds.doc(id).update({
      ...med.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Soft delete + 비활성화.
  Future<void> delete(String id) async {
    await _meds.doc(id).update({
      'isActive': false,
      'deletedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 특정 날짜의 복약 로그(실시간).
  Stream<List<MedicationLogEntry>> watchLogsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return _logs
        .where('scheduledTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('scheduledTime', isLessThan: Timestamp.fromDate(end))
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => MedicationLogEntry(
                  id: d.id,
                  medicationId: d.data()['medicationId'] as String? ?? '',
                  scheduledTime:
                      (d.data()['scheduledTime'] as Timestamp?)?.toDate(),
                  status: d.data()['status'] as String? ?? 'completed',
                ))
            .toList());
  }

  /// 복용 완료 기록.
  Future<void> markTaken({
    required String medicationId,
    required DateTime scheduledTime,
  }) async {
    await _logs.add({
      'medicationId': medicationId,
      'scheduledTime': Timestamp.fromDate(scheduledTime),
      'completedTime': FieldValue.serverTimestamp(),
      'status': 'completed',
      'note': '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// 복용 기록 취소.
  Future<void> unmark(String logId) async {
    await _logs.doc(logId).delete();
  }

  /// 특정 기간 로그 수(복약률 계산용).
  Future<int> countLogsSince(DateTime since) async {
    final snap = await _logs
        .where('scheduledTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(since))
        .where('status', isEqualTo: 'completed')
        .get();
    return snap.docs.length;
  }
}

class MedicationLogEntry {
  MedicationLogEntry({
    required this.id,
    required this.medicationId,
    required this.scheduledTime,
    required this.status,
  });
  final String id;
  final String medicationId;
  final DateTime? scheduledTime;
  final String status;
}
