import '../../../core/utils/firestore_utils.dart';

/// 알림 종류.
enum NotificationType {
  medication('medication', '복약'),
  checkup('checkup', '검진'),
  booking('booking', '예약'),
  care('care', 'AI 케어'),
  system('system', '공지');

  const NotificationType(this.key, this.label);
  final String key;
  final String label;

  static NotificationType fromKey(String? key) {
    return NotificationType.values.firstWhere(
      (e) => e.key == key,
      orElse: () => NotificationType.system,
    );
  }
}

/// 앱 알림 — Firestore `users/{uid}/notifications/{id}`.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.read = false,
    this.sentAt,
    this.actionLabel = '',
    this.actionRoute = '',
  });

  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final bool read;
  final DateTime? sentAt;
  final String actionLabel;
  final String actionRoute;

  factory AppNotification.fromMap(String id, Map<String, dynamic> map) {
    return AppNotification(
      id: id,
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      type: NotificationType.fromKey(map['type'] as String?),
      read: map['read'] as bool? ?? false,
      sentAt: tsToDate(map['sentAt'] ?? map['createdAt']),
      actionLabel: map['actionLabel'] as String? ?? '',
      actionRoute: map['actionRoute'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'type': type.key,
      'read': read,
      'sentAt': sentAt,
      'actionLabel': actionLabel,
      'actionRoute': actionRoute,
    };
  }
}
