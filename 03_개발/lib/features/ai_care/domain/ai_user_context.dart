/// AI 프롬프트에 넣을 사용자 맥락.
class AiUserContext {
  const AiUserContext({
    this.nickname = '',
    this.stageLabel = '',
    this.dueDateLabel = '',
    this.pregnancyWeeks,
  });

  final String nickname;
  final String stageLabel;
  final String dueDateLabel;
  final int? pregnancyWeeks;

  bool get hasData =>
      nickname.isNotEmpty ||
      stageLabel.isNotEmpty ||
      dueDateLabel.isNotEmpty ||
      pregnancyWeeks != null;

  String toPromptBlock() {
    if (!hasData) return '';
    final lines = <String>[];
    if (nickname.isNotEmpty) lines.add('닉네임: $nickname');
    if (stageLabel.isNotEmpty) lines.add('임신 단계: $stageLabel');
    if (pregnancyWeeks != null) lines.add('임신 주차(추정): $pregnancyWeeks주');
    if (dueDateLabel.isNotEmpty) lines.add('출산 예정일: $dueDateLabel');
    return '${lines.join('\n')}\n';
  }
}
