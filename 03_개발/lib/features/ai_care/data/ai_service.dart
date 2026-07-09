import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../domain/ai_briefing.dart';
import '../domain/ai_chat_message.dart';
import '../domain/ai_user_context.dart';
import '../../../core/ai/gemini_client.dart';

/// AI Cloud Functions 호출 + Firestore 저장.
class AiService {
  AiService(this._db, this._uid, this._functions);

  final FirebaseFirestore _db;
  final String _uid;
  final FirebaseFunctions _functions;
  final GeminiClient _gemini = GeminiClient();

  static const _aiBox = 'ai_limits';
  static const _dailyLimit = 30;

  String get _provider {
    final p = dotenv.env['AI_PROVIDER']?.trim().toLowerCase();
    if (p == null || p.isEmpty) return 'auto';
    return p;
  }

  bool get _preferGeminiFirst {
    final v = dotenv.env['AI_PREFER_GEMINI']?.trim().toLowerCase();
    return v == '1' || v == 'true' || v == 'yes';
  }

  Future<bool> _allowCall() async {
    final box = await Hive.openBox(_aiBox);
    final now = DateTime.now();
    final dayKey = '${now.year}-${now.month}-${now.day}';
    final countKey = 'count:$dayKey';
    final count = (box.get(countKey) as int?) ?? 0;
    if (count >= _dailyLimit) return false;
    await box.put(countKey, count + 1);
    return true;
  }

  CollectionReference<Map<String, dynamic>> get _chats =>
      _db.collection('users').doc(_uid).collection('ai_chats');

  CollectionReference<Map<String, dynamic>> get _briefings =>
      _db.collection('users').doc(_uid).collection('ai_briefings');

  Stream<List<AiChatMessage>> watchMessages() {
    return _chats
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => AiChatMessage.fromMap(d.id, d.data()))
            .toList());
  }

  Stream<List<AiBriefing>> watchBriefings() {
    return _briefings
        .orderBy('generatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => AiBriefing.fromMap(d.id, d.data()))
            .toList());
  }

  Future<AiChatMessage> sendMessage(
    String text, {
    AiUserContext? context,
  }) async {
    await _chats.add({
      ...AiChatMessage(id: '', role: AiChatRole.user, message: text).toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    final reply = await _askAi(text, context: context);
    final ref = await _chats.add({
      ...AiChatMessage(id: '', role: AiChatRole.assistant, message: reply)
          .toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return AiChatMessage(
      id: ref.id,
      role: AiChatRole.assistant,
      message: reply,
      createdAt: DateTime.now(),
    );
  }

  Future<void> saveFeedback(String messageId, String feedback) async {
    if (messageId.isEmpty) return;
    await _chats.doc(messageId).update({'feedback': feedback});
  }

  Future<AiBriefing> generateBriefing({AiUserContext? context}) async {
    final result = await _generateBriefing(context: context);
    final ref = await _briefings.add({
      ...result.toMap(),
      'generatedAt': FieldValue.serverTimestamp(),
    });
    return AiBriefing(
      id: ref.id,
      title: result.title,
      summary: result.summary,
      tips: result.tips,
      warnings: result.warnings,
      generatedAt: DateTime.now(),
    );
  }

  Future<String> _askAi(String message, {AiUserContext? context}) async {
    // 비용/폭주 최소 방지 (무료 플랜 + 클라이언트 키 사용)
    if (!await _allowCall()) {
      return '오늘 AI 상담 요청이 많아 잠시 쉬어가고 있어요.\n'
          '잠시 후 다시 시도해주시거나, 급한 증상은 의료진 상담을 권장드려요.';
    }
    final provider = _provider;
    final useFunctions = provider == 'functions' || provider == 'auto';
    final useGemini = provider == 'gemini' || provider == 'auto';

    if (_preferGeminiFirst && useGemini) {
      final gem = await _askGemini(message, context: context);
      if (gem != null) return gem;
    }

    if (useFunctions) {
      try {
        final callable = _functions.httpsCallable('askAI');
        final result = await callable.call<Map<String, dynamic>>({
          'message': message,
        });
        final reply = result.data['reply'] as String?;
        if (reply != null && reply.trim().isNotEmpty) return reply.trim();
      } catch (e) {
        debugPrint('[AI] askAI(functions) 실패: $e');
      }
    }

    if (useGemini) {
      final gem = await _askGemini(message, context: context);
      if (gem != null) return gem;
    }

    return _fallbackReply(message);
  }

  Future<String?> _askGemini(String message, {AiUserContext? context}) async {
    final ctx = context?.toPromptBlock() ?? '';
    final prompt =
        '너는 임신/산모 건강을 돕는 상담 도우미야.\n'
        '의학적 진단은 하지 말고, 안전한 범위의 일반적인 정보/주의사항/다음 행동을 안내해.\n'
        '긴급 신호(출혈, 심한 복통, 호흡곤란, 고열 등)가 있으면 즉시 진료를 권고해.\n\n'
        '${ctx.isEmpty ? '' : '사용자 정보:\n$ctx\n'}'
        '사용자 질문: $message\n\n'
        '답변(한국어, 6~10문장, 줄바꿈 포함):';
    return _gemini.generateText(prompt: prompt);
  }

  Future<AiBriefing> _generateBriefing({AiUserContext? context}) async {
    final nickname = context?.nickname ?? '';
    final stage = context?.stageLabel ?? '';
    if (!await _allowCall()) {
      return _fallbackBriefing(nickname: nickname, stage: stage);
    }
    final provider = _provider;
    final useFunctions = provider == 'functions' || provider == 'auto';
    final useGemini = provider == 'gemini' || provider == 'auto';

    if (_preferGeminiFirst && useGemini) {
      final b = await _briefGemini(context: context);
      if (b != null) return b;
    }

    if (useFunctions) {
      try {
        final callable = _functions.httpsCallable('generateDailyBriefing');
        final result = await callable.call<Map<String, dynamic>>({
          'nickname': nickname,
          'stage': stage,
        });
        final data = result.data;
        return AiBriefing(
          id: '',
          title: data['title'] as String? ?? '오늘의 AI 브리핑',
          summary: data['summary'] as String? ?? '',
          tips: (data['tips'] as List?)?.map((e) => '$e').toList() ?? const [],
          warnings:
              (data['warnings'] as List?)?.map((e) => '$e').toList() ?? const [],
        );
      } catch (e) {
        debugPrint('[AI] generateDailyBriefing(functions) 실패: $e');
      }
    }

    if (useGemini) {
      final b = await _briefGemini(context: context);
      if (b != null) return b;
    }

    return _fallbackBriefing(nickname: nickname, stage: stage);
  }

  Future<AiBriefing?> _briefGemini({AiUserContext? context}) async {
    final nickname = context?.nickname ?? '';
    final stage = context?.stageLabel ?? '';
    final ctx = context?.toPromptBlock() ?? '';
    final prompt =
        '너는 임신/산모 건강 앱의 "오늘의 브리핑"을 작성하는 도우미야.\n'
        '아래 형식으로만 JSON을 반환해:\n'
        '{ "title": string, "summary": string, "tips": string[], "warnings": string[] }\n'
        'tips는 3개, warnings는 1~2개.\n'
        '너무 과장하지 말고 실천 가능한 조언 중심.\n\n'
        '${ctx.isEmpty ? '' : '사용자 정보:\n$ctx\n'}'
        '닉네임: $nickname\n'
        '단계: $stage\n';
    final ai = await _gemini.generateText(prompt: prompt);
    if (ai == null) return null;
    try {
      final jsonStart = ai.indexOf('{');
      final jsonEnd = ai.lastIndexOf('}');
      if (jsonStart < 0 || jsonEnd <= jsonStart) return null;
      final raw = ai.substring(jsonStart, jsonEnd + 1);
      final map = (jsonDecode(raw) as Map).cast<String, dynamic>();
      return AiBriefing(
        id: '',
        title: map['title'] as String? ?? '오늘의 AI 브리핑',
        summary: map['summary'] as String? ?? '',
        tips: (map['tips'] as List?)?.map((e) => '$e').toList() ?? const [],
        warnings:
            (map['warnings'] as List?)?.map((e) => '$e').toList() ?? const [],
      );
    } catch (e) {
      debugPrint('[AI] 브리핑 JSON 파싱 실패: $e');
      return null;
    }
  }

  String _fallbackReply(String message) {
    final q = message.toLowerCase();
    if (q.contains('감기') || q.contains('콧물') || q.contains('기침')) {
      return '임신 중 감기는 흔하게 발생할 수 있어요.\n'
          '충분한 수분 섭취와 휴식을 우선으로 하시고, '
          '해열이 있으면 의사와 상의 후 아세트아미노펜 사용을 고려해보세요.\n'
          '이부프로펜 등 일부 진통제는 임신 시기에 따라 주의가 필요해요.';
    }
    if (q.contains('약') || q.contains('복용')) {
      return '임신 중 약 복용은 반드시 의사·약사와 상의하는 것이 안전해요.\n'
          '처방받은 약은 지시된 용량과 시간을 지키고, '
          '영양제·한약 등도 임의로 추가하지 않는 것이 좋아요.';
    }
    if (q.contains('영양') || q.contains('엽산')) {
      return '임신 준비·임신 초기에는 엽산이 중요해요.\n'
          '균형 잡힌 식사와 함께 의사가 권장하는 영양제를 꾸준히 챙기세요.\n'
          '철분, 비타민 D 등은 검사 결과에 따라 추가가 필요할 수 있어요.';
    }
    if (q.contains('수면') || q.contains('잠')) {
      return '임신 중에는 수면 패턴이 달라질 수 있어요.\n'
          '규칙적인 취침 시간, 가벼운 스트레칭, 카페인 조절이 도움이 됩니다.\n'
          '지속적인 불면이 있다면 산부인과에 상담해보세요.';
    }
    return '질문해주셔서 감사해요.\n'
        '임신·건강 관련 궁금증은 증상, 복용 중인 약, 임신 주차를 함께 알려주시면 '
        '더 구체적으로 안내해드릴 수 있어요.\n'
        '급한 증상이나 지속되는 불편함은 반드시 의료진과 상담해주세요.';
  }

  AiBriefing _fallbackBriefing({
    required String nickname,
    required String stage,
  }) {
    final name = nickname.isEmpty ? '엄마' : nickname;
    final stageLabel = stage.isEmpty ? '건강 관리' : stage;
    return AiBriefing(
      id: '',
      title: '오늘의 AI 브리핑',
      summary:
          '$name님, 오늘도 $stageLabel에 맞춰 건강한 하루를 보내세요.\n'
          '복약 일정과 수분 섭취를 챙기고, 무리한 활동은 피하는 것이 좋아요.',
      tips: const [
        '오늘 예정된 복약 시간을 확인해보세요.',
        '하루 1.5~2L 정도 수분을 섭취해보세요.',
        '가벼운 산책이나 스트레칭으로 컨디션을 유지해보세요.',
      ],
      warnings: const [
        '지속되는 복통, 출혈, 심한 두통은 즉시 의료진과 상담하세요.',
      ],
    );
  }
}
