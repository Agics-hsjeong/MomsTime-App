import '../../../core/utils/firestore_utils.dart';

/// AI 브리핑 — Firestore `users/{uid}/ai_briefings/{id}`.
class AiBriefing {
  const AiBriefing({
    required this.id,
    required this.title,
    required this.summary,
    this.tips = const [],
    this.warnings = const [],
    this.generatedAt,
  });

  final String id;
  final String title;
  final String summary;
  final List<String> tips;
  final List<String> warnings;
  final DateTime? generatedAt;

  factory AiBriefing.fromMap(String id, Map<String, dynamic> map) {
    return AiBriefing(
      id: id,
      title: map['title'] as String? ?? '오늘의 AI 브리핑',
      summary: map['summary'] as String? ?? '',
      tips: stringList(map['tips']),
      warnings: stringList(map['warnings']),
      generatedAt: tsToDate(map['generatedAt'] ?? map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'summary': summary,
      'tips': tips,
      'warnings': warnings,
    };
  }
}
