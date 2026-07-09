import '../../../core/utils/firestore_utils.dart';

/// AI 채팅 메시지 역할.
enum AiChatRole {
  user('user'),
  assistant('assistant');

  const AiChatRole(this.key);
  final String key;

  static AiChatRole fromKey(String? key) {
    return AiChatRole.values.firstWhere(
      (e) => e.key == key,
      orElse: () => AiChatRole.user,
    );
  }
}

/// AI 채팅 메시지 — Firestore `users/{uid}/ai_chats/{id}`.
class AiChatMessage {
  const AiChatMessage({
    required this.id,
    required this.role,
    required this.message,
    this.createdAt,
    this.feedback = '',
  });

  final String id;
  final AiChatRole role;
  final String message;
  final DateTime? createdAt;
  /// `up` | `down` | ''
  final String feedback;

  bool get isUser => role == AiChatRole.user;

  factory AiChatMessage.fromMap(String id, Map<String, dynamic> map) {
    return AiChatMessage(
      id: id,
      role: AiChatRole.fromKey(map['role'] as String?),
      message: map['message'] as String? ?? '',
      createdAt: tsToDate(map['createdAt']),
      feedback: map['feedback'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role.key,
      'message': message,
      if (feedback.isNotEmpty) 'feedback': feedback,
    };
  }

  AiChatMessage copyWith({String? feedback}) {
    return AiChatMessage(
      id: id,
      role: role,
      message: message,
      createdAt: createdAt,
      feedback: feedback ?? this.feedback,
    );
  }
}
