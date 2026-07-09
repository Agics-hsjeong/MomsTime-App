/// 알림 설정 — Firestore `users/{uid}.notificationSettings`.
class NotificationSettings {
  const NotificationSettings({
    this.pushEnabled = true,
    this.medication = true,
    this.checkup = true,
    this.booking = true,
    this.care = true,
    this.marketing = false,
  });

  final bool pushEnabled;
  final bool medication;
  final bool checkup;
  final bool booking;
  final bool care;
  final bool marketing;

  factory NotificationSettings.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const NotificationSettings();
    return NotificationSettings(
      pushEnabled: map['pushEnabled'] as bool? ?? true,
      medication: map['medication'] as bool? ?? true,
      checkup: map['checkup'] as bool? ?? true,
      booking: map['booking'] as bool? ?? true,
      care: map['care'] as bool? ?? true,
      marketing: map['marketing'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pushEnabled': pushEnabled,
      'medication': medication,
      'checkup': checkup,
      'booking': booking,
      'care': care,
      'marketing': marketing,
    };
  }

  NotificationSettings copyWith({
    bool? pushEnabled,
    bool? medication,
    bool? checkup,
    bool? booking,
    bool? care,
    bool? marketing,
  }) {
    return NotificationSettings(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      medication: medication ?? this.medication,
      checkup: checkup ?? this.checkup,
      booking: booking ?? this.booking,
      care: care ?? this.care,
      marketing: marketing ?? this.marketing,
    );
  }
}
