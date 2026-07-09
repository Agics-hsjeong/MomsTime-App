import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/firestore_utils.dart';

/// 약/영양제 — Firestore `users/{uid}/medications/{id}`.
class Medication {
  const Medication({
    required this.id,
    required this.name,
    required this.category,
    this.dosage = '',
    this.frequency = 1,
    this.times = const [],
    this.beforeMeal = false,
    this.startDate,
    this.endDate,
    this.memo = '',
    this.isActive = true,
    this.createdAt,
  });

  final String id;
  final String name;

  /// medicine / supplement
  final String category;
  final String dosage;
  final int frequency;

  /// "HH:mm" 문자열 목록
  final List<String> times;
  final bool beforeMeal;
  final DateTime? startDate;
  final DateTime? endDate;
  final String memo;
  final bool isActive;
  final DateTime? createdAt;

  bool get isSupplement => category == 'supplement';

  factory Medication.fromMap(String id, Map<String, dynamic> map) {
    return Medication(
      id: id,
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? 'supplement',
      dosage: map['dosage'] as String? ?? '',
      frequency: intOf(map['frequency'], 1),
      times: stringList(map['times']),
      beforeMeal: map['beforeMeal'] as bool? ?? false,
      startDate: tsToDate(map['startDate']),
      endDate: tsToDate(map['endDate']),
      memo: map['memo'] as String? ?? '',
      isActive: map['isActive'] as bool? ?? true,
      createdAt: tsToDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'dosage': dosage,
      'frequency': frequency,
      'times': times,
      'beforeMeal': beforeMeal,
      'startDate': startDate == null ? null : Timestamp.fromDate(startDate!),
      'endDate': endDate == null ? null : Timestamp.fromDate(endDate!),
      'memo': memo,
      'isActive': isActive,
    };
  }

  /// 지정한 날짜에 복용 대상인지.
  bool activeOn(DateTime day) {
    if (!isActive) return false;
    final d = DateTime(day.year, day.month, day.day);
    if (startDate != null) {
      final s = DateTime(startDate!.year, startDate!.month, startDate!.day);
      if (d.isBefore(s)) return false;
    }
    if (endDate != null) {
      final e = DateTime(endDate!.year, endDate!.month, endDate!.day);
      if (d.isAfter(e)) return false;
    }
    return true;
  }
}

/// 오늘 복용 단위(약 + 특정 시간).
class MedicationDose {
  const MedicationDose({
    required this.medication,
    required this.time,
    required this.completed,
    this.logId,
  });

  final Medication medication;

  /// "HH:mm"
  final String time;
  final bool completed;
  final String? logId;

  int get sortKey {
    final parts = time.split(':');
    if (parts.length != 2) return 0;
    return (int.tryParse(parts[0]) ?? 0) * 60 + (int.tryParse(parts[1]) ?? 0);
  }
}
