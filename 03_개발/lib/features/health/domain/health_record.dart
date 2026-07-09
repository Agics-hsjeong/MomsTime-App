import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/firestore_utils.dart';

/// 건강 기록 종류.
enum HealthType {
  weight('weight', '체중', 'kg'),
  bloodPressure('blood_pressure', '혈압', 'mmHg'),
  bloodSugar('blood_sugar', '혈당', 'mg/dL'),
  water('water', '수분', 'ml'),
  exercise('exercise', '운동', '분');

  const HealthType(this.key, this.label, this.unit);
  final String key;
  final String label;
  final String unit;

  static HealthType fromKey(String? key) {
    return HealthType.values.firstWhere(
      (e) => e.key == key,
      orElse: () => HealthType.weight,
    );
  }
}

/// 건강 기록 — Firestore `users/{uid}/health_records/{id}`.
class HealthRecord {
  const HealthRecord({
    required this.id,
    required this.type,
    required this.value,
    this.unit = '',
    this.memo = '',
    this.recordedAt,
  });

  final String id;
  final HealthType type;
  final double value;
  final String unit;
  final String memo;
  final DateTime? recordedAt;

  factory HealthRecord.fromMap(String id, Map<String, dynamic> map) {
    return HealthRecord(
      id: id,
      type: HealthType.fromKey(map['type'] as String?),
      value: doubleOf(map['value']),
      unit: map['unit'] as String? ?? '',
      memo: map['memo'] as String? ?? '',
      recordedAt: tsToDate(map['recordedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.key,
      'value': value,
      'unit': unit.isEmpty ? type.unit : unit,
      'memo': memo,
      'recordedAt':
          recordedAt == null ? null : Timestamp.fromDate(recordedAt!),
    };
  }
}
