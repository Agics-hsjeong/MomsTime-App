import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../auth/application/auth_providers.dart';
import '../../auth/domain/app_user.dart';
import '../data/ai_service.dart';
import '../domain/ai_briefing.dart';
import '../domain/ai_chat_message.dart';
import '../domain/ai_user_context.dart';
import '../../../core/firebase/firebase_providers.dart';

final aiServiceProvider = Provider<AiService?>((ref) {
  if (!ref.watch(firebaseReadyProvider)) return null;
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return null;
  return AiService(
    ref.watch(firestoreProvider),
    uid,
    ref.watch(firebaseFunctionsProvider),
  );
});

final aiChatMessagesProvider = StreamProvider<List<AiChatMessage>>((ref) {
  final service = ref.watch(aiServiceProvider);
  if (service == null) return Stream.value(const <AiChatMessage>[]);
  return service.watchMessages();
});

final aiBriefingsProvider = StreamProvider<List<AiBriefing>>((ref) {
  final service = ref.watch(aiServiceProvider);
  if (service == null) return Stream.value(const <AiBriefing>[]);
  return service.watchBriefings();
});

final latestAiBriefingProvider = Provider<AiBriefing?>((ref) {
  final items = ref.watch(aiBriefingsProvider).value ?? const [];
  if (items.isEmpty) return null;
  return items.first;
});

/// 최근 사용자 질문(중복 제거, 최대 5개).
final recentAiQuestionsProvider = Provider<List<String>>((ref) {
  final messages = ref.watch(aiChatMessagesProvider).value ?? const [];
  final seen = <String>{};
  final out = <String>[];
  for (final m in messages.reversed) {
    if (!m.isUser) continue;
    final q = m.message.trim();
    if (q.isEmpty || seen.contains(q)) continue;
    seen.add(q);
    out.add(q);
    if (out.length >= 5) break;
  }
  return out;
});

AiUserContext buildAiUserContext(AppUser? profile) {
  if (profile == null) return const AiUserContext();
  final due = profile.dueDate;
  String dueLabel = '';
  int? weeks;
  if (due != null) {
    dueLabel = DateFormat('yyyy.MM.dd', 'ko').format(due);
    final daysLeft = due.difference(DateTime.now()).inDays;
    final w = 40 - (daysLeft / 7).round();
    if (w >= 0 && w <= 42) weeks = w;
  }
  return AiUserContext(
    nickname: profile.nickname,
    stageLabel: profile.pregnancyStage.label,
    dueDateLabel: dueLabel,
    pregnancyWeeks: weeks,
  );
}

class AiCareController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  AiService? get _service => ref.read(aiServiceProvider);

  Future<bool> sendMessage(String text) async {
    final service = _service;
    if (service == null) return false;
    final context = buildAiUserContext(ref.read(currentUserProfileProvider).value);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => service.sendMessage(text, context: context),
    );
    return !state.hasError;
  }

  Future<void> setFeedback(String messageId, String feedback) async {
    await _service?.saveFeedback(messageId, feedback);
  }

  Future<bool> generateBriefing() async {
    final service = _service;
    if (service == null) return false;
    final context = buildAiUserContext(ref.read(currentUserProfileProvider).value);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => service.generateBriefing(context: context),
    );
    return !state.hasError;
  }
}

final aiCareControllerProvider =
    AsyncNotifierProvider<AiCareController, void>(AiCareController.new);

final aiChatSendingProvider = Provider<bool>((ref) {
  return ref.watch(aiCareControllerProvider).isLoading;
});
