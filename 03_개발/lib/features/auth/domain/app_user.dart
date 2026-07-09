import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/firestore_utils.dart';

/// 임신 단계.
enum PregnancyStage {
  preparing('preparing', '임신 준비 중'),
  pregnant('pregnant', '임신 중'),
  postpartum('postpartum', '출산 후');

  const PregnancyStage(this.key, this.label);
  final String key;
  final String label;

  static PregnancyStage fromKey(String? key) {
    return PregnancyStage.values.firstWhere(
      (e) => e.key == key,
      orElse: () => PregnancyStage.preparing,
    );
  }
}

/// 사용자 프로필 — Firestore `users/{uid}`.
class AppUser {
  const AppUser({
    required this.uid,
    required this.nickname,
    required this.email,
    this.provider = 'password',
    this.pregnancyStage = PregnancyStage.preparing,
    this.stageCompleted = false,
    this.dueDate,
    this.birthDate,
    this.profileImage = '',
    this.createdAt,
    this.updatedAt,
  });

  final String uid;
  final String nickname;
  final String email;
  final String provider;
  final PregnancyStage pregnancyStage;
  /// 단계 선택 화면을 완료했는지.
  final bool stageCompleted;
  final DateTime? dueDate;
  final DateTime? birthDate;
  final String profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      nickname: map['nickname'] as String? ?? '',
      email: map['email'] as String? ?? '',
      provider: map['provider'] as String? ?? 'password',
      pregnancyStage: PregnancyStage.fromKey(map['pregnancyStage'] as String?),
      stageCompleted: map['stageCompleted'] as bool? ??
          (map['pregnancyStage'] as String? ?? 'preparing') != 'preparing',
      dueDate: tsToDate(map['dueDate']),
      birthDate: tsToDate(map['birthDate']),
      profileImage: map['profileImage'] as String? ?? '',
      createdAt: tsToDate(map['createdAt']),
      updatedAt: tsToDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toCreateMap() {
    return {
      'uid': uid,
      'nickname': nickname,
      'email': email,
      'provider': provider,
      'pregnancyStage': pregnancyStage.key,
      'stageCompleted': stageCompleted,
      'dueDate': dueDate == null ? null : Timestamp.fromDate(dueDate!),
      'birthDate': birthDate == null ? null : Timestamp.fromDate(birthDate!),
      'profileImage': profileImage,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  AppUser copyWith({
    String? nickname,
    PregnancyStage? pregnancyStage,
    bool? stageCompleted,
    DateTime? dueDate,
    DateTime? birthDate,
    String? profileImage,
  }) {
    return AppUser(
      uid: uid,
      nickname: nickname ?? this.nickname,
      email: email,
      provider: provider,
      pregnancyStage: pregnancyStage ?? this.pregnancyStage,
      stageCompleted: stageCompleted ?? this.stageCompleted,
      dueDate: dueDate ?? this.dueDate,
      birthDate: birthDate ?? this.birthDate,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
