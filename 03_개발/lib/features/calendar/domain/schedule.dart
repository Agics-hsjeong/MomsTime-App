import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/firestore_utils.dart';

/// 일정 종류.
enum ScheduleType {
  medication('medication', '복약'),
  checkup('checkup', '검진'),
  hospital('hospital', '병원'),
  personal('personal', '개인');

  const ScheduleType(this.key, this.label);
  final String key;
  final String label;

  static ScheduleType fromKey(String? key) {
    return ScheduleType.values.firstWhere(
      (e) => e.key == key,
      orElse: () => ScheduleType.personal,
    );
  }
}

/// 일정 — Firestore `users/{uid}/schedules/{id}`.
class Schedule {
  const Schedule({
    required this.id,
    required this.title,
    required this.type,
    this.date,
    this.memo = '',
    this.completed = false,
  });

  final String id;
  final String title;
  final ScheduleType type;
  final DateTime? date;
  final String memo;
  final bool completed;

  factory Schedule.fromMap(String id, Map<String, dynamic> map) {
    return Schedule(
      id: id,
      title: map['title'] as String? ?? '',
      type: ScheduleType.fromKey(map['type'] as String?),
      date: tsToDate(map['date']),
      memo: map['memo'] as String? ?? '',
      completed: map['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type.key,
      'date': date == null ? null : Timestamp.fromDate(date!),
      'memo': memo,
      'completed': completed,
    };
  }
}
