import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/app_user.dart';
import '../application/ai_care_providers.dart';

/// AI 건강 챗봇 — 퍼블리싱 20_ai_chat.html
class AiChatPage extends ConsumerStatefulWidget {
  const AiChatPage({super.key});

  @override
  ConsumerState<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends ConsumerState<AiChatPage> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  String _lastSent = '';
  bool _lastFailed = false;

  static List<String> _chipsFor(PregnancyStage stage) {
    return switch (stage) {
      PregnancyStage.pregnant => const [
          '임신 중 약 복용해도 될까요?',
          '태동이 줄었어요',
          '임신 중 감기 대처법',
          '영양제 추천',
        ],
      PregnancyStage.postpartum => const [
          '산후 우울감이 심해요',
          '모유 수유 중 약 복용',
          '산후 회복 운동',
          '수면 부족 관리',
        ],
      PregnancyStage.preparing => const [
          '임신 준비 영양제',
          '배란·임신 시기 궁금해요',
          '임신 전 건강검진',
          '생활 습관 조언',
        ],
    };
  }

  void _showTemplates() {
    final profile = ref.read(currentUserProfileProvider).value;
    final ctx = buildAiUserContext(profile);
    final week = ctx.pregnancyWeeks;
    final templates = <String>[
      if (week != null)
        '임신 $week주인데 최근 속이 메스꺼워요. 괜찮은지 알려주세요.',
      '복용 중인 영양제와 처방약을 함께 먹어도 될까요?',
      '오늘 컨디션이 안 좋은데 병원에 가야 할까요?',
      '수면·스트레스 관리 방법을 알려주세요.',
    ];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '질문 템플릿',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 8.h),
              Text(
                '탭하면 바로 질문할 수 있어요.',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 16.h),
              for (final t in templates)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(t, style: TextStyle(fontSize: 14.sp, height: 1.5)),
                  trailing: Icon(Icons.north_west_rounded,
                      size: 18.sp, color: AppColors.textDisabled),
                  onTap: () {
                    Navigator.pop(ctx);
                    _send(t);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _feedback(String messageId, String value) async {
    await ref.read(aiCareControllerProvider.notifier).setFeedback(messageId, value);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value == 'up' ? '피드백 감사해요!' : '더 나은 답변을 위해 참고할게요.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _send([String? preset]) async {
    final text = (preset ?? _inputCtrl.text).trim();
    if (text.isEmpty) return;
    if (!firebaseReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Firebase 설정 후 AI 채팅을 사용할 수 있어요.')),
      );
      return;
    }
    _inputCtrl.clear();
    setState(() {
      _lastSent = text;
      _lastFailed = false;
    });
    final ok =
        await ref.read(aiCareControllerProvider.notifier).sendMessage(text);
    if (!mounted) return;
    if (!ok) {
      setState(() => _lastFailed = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('메시지 전송에 실패했어요.')),
      );
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    return DateFormat('a h:mm', 'ko').format(time);
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(aiChatMessagesProvider).value ?? const [];
    final sending = ref.watch(aiChatSendingProvider);
    final controller = ref.watch(aiCareControllerProvider);
    final profile = ref.watch(currentUserProfileProvider).value;
    final recent = ref.watch(recentAiQuestionsProvider);
    final chips = _chipsFor(profile?.pregnancyStage ?? PregnancyStage.preparing);
    final name = (profile?.nickname.isNotEmpty ?? false)
        ? profile!.nickname
        : '엄마';
    final lastAssistant = messages.where((m) => !m.isUser).lastOrNull?.message;
    final emergency = _looksEmergency(lastAssistant);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MomsAppBar(
        title: 'AI 건강 챗봇',
        actions: [
          IconButton(
            onPressed: sending ? null : _showTemplates,
            icon: Icon(Icons.edit_note_rounded, size: 24.sp),
            tooltip: '질문 템플릿',
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _OnlineDot(active: !sending),
              SizedBox(width: 6.w),
              Text(
                sending ? 'AI가 답변을 생성 중입니다' : 'AI 상담 준비 완료',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              controller: _scrollCtrl,
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
              children: [
                _WelcomeCard(
                  name: name,
                  chips: chips,
                  onChipTap: _send,
                ),
                if (emergency) ...[
                  SizedBox(height: 12.h),
                  const _EmergencyCard(),
                ],
                if (_lastFailed || controller.hasError) ...[
                  SizedBox(height: 12.h),
                  _RetryCard(
                    lastText: _lastSent,
                    onRetry: sending ? null : () => _send(_lastSent),
                  ),
                ],
                SizedBox(height: 20.h),
                for (final msg in messages) ...[
                  if (msg.isUser)
                    _UserBubble(
                      time: _formatTime(msg.createdAt),
                      text: msg.message,
                    )
                  else
                    _AiBubble(
                      messageId: msg.id,
                      time: _formatTime(msg.createdAt),
                      text: msg.message,
                      feedback: msg.feedback,
                      onFeedback: _feedback,
                    ),
                  SizedBox(height: 16.h),
                ],
                if (sending)
                  Padding(
                    padding: EdgeInsets.only(left: 50.w, bottom: 8.h),
                    child: Text(
                      '답변 생성 중...',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (recent.isNotEmpty)
            _RecentQuestions(
              questions: recent,
              onTap: sending ? null : _send,
            ),
          _ChatInputBar(
            controller: _inputCtrl,
            onSend: () => _send(),
            enabled: !sending,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
            child: Text(
              'AI의 답변은 일반적인 정보 제공을 목적으로 하며, 의학적 진단을 대신할 수 없습니다.\n면책 조항 보기 ›',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textDisabled,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnlineDot extends StatelessWidget {
  const _OnlineDot({this.active = true});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF34C759) : AppColors.textDisabled,
        shape: BoxShape.circle,
      ),
    );
  }
}

bool _looksEmergency(String? text) {
  if (text == null) return false;
  final t = text.toLowerCase();
  const keywords = [
    '즉시',
    '응급',
    '119',
    '응급실',
    '출혈',
    '피가',
    '심한 복통',
    '호흡곤란',
    '의식',
    '고열',
    '38',
  ];
  return keywords.any((k) => t.contains(k.toLowerCase()));
}

class _EmergencyCard extends StatelessWidget {
  const _EmergencyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEF2),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFF7B5C3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_rounded, color: const Color(0xFFE55980), size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              '응급 신호가 의심돼요.\n'
              '출혈·심한 복통·호흡곤란·고열·의식 저하가 있으면 즉시 119 또는 가까운 응급실에 연락/내원해주세요.',
              style: TextStyle(
                fontSize: 12.5.sp,
                height: 1.55,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF8E1B3B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RetryCard extends StatelessWidget {
  const _RetryCard({required this.lastText, required this.onRetry});
  final String lastText;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (lastText.trim().isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F0FE),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE4DBF9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.refresh_rounded, color: const Color(0xFF7C5CD6), size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              '답변을 가져오지 못했어요.\n'
              '네트워크 상태를 확인한 뒤 “다시 시도”를 눌러주세요.',
              style: TextStyle(fontSize: 12.5.sp, height: 1.55),
            ),
          ),
          SizedBox(width: 8.w),
          TextButton(
            onPressed: onRetry,
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({
    required this.name,
    required this.chips,
    required this.onChipTap,
  });
  final String name;
  final List<String> chips;
  final ValueChanged<String> onChipTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F0FE),
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 84.w,
            height: 84.w,
            decoration: const BoxDecoration(
              color: Color(0xFFE9E1FC),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text('🤖', style: TextStyle(fontSize: 44.sp)),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '안녕하세요 $name님! 저는 맘케어 AI입니다. 😊',
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 6.h),
                Text(
                  '임신, 복약, 건강, 생활 습관 등\n궁금한 내용을 질문하시면 도와드릴게요.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 14.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    for (final c in chips)
                      GestureDetector(
                        onTap: () => onChipTap(c),
                        child: Container(
                          height: 38.h,
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            border: Border.all(color: AppColors.aiPurple),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            c,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF7C5CD6),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.time, required this.text});
  final String time;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          time,
          style: TextStyle(fontSize: 11.sp, color: AppColors.textDisabled),
        ),
        SizedBox(width: 8.w),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFF8B6FF0),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(4.r),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                height: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AiBubble extends StatelessWidget {
  const _AiBubble({
    required this.messageId,
    required this.time,
    required this.text,
    required this.feedback,
    required this.onFeedback,
  });
  final String messageId;
  final String time;
  final String text;
  final String feedback;
  final void Function(String messageId, String value) onFeedback;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: const BoxDecoration(
            color: Color(0xFFE9E1FC),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text('🤖', style: TextStyle(fontSize: 20.sp)),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                padding:
                    EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.r),
                    topRight: Radius.circular(20.r),
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 14.sp, height: 1.7),
                ),
              ),
              if (messageId.isNotEmpty) ...[
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '도움이 되었나요?',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textDisabled,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.h),
                      onPressed: feedback == 'up'
                          ? null
                          : () => onFeedback(messageId, 'up'),
                      icon: Icon(
                        feedback == 'up'
                            ? Icons.thumb_up_rounded
                            : Icons.thumb_up_outlined,
                        size: 18.sp,
                        color: feedback == 'up'
                            ? const Color(0xFF7C5CD6)
                            : AppColors.textSecondary,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.h),
                      onPressed: feedback == 'down'
                          ? null
                          : () => onFeedback(messageId, 'down'),
                      icon: Icon(
                        feedback == 'down'
                            ? Icons.thumb_down_rounded
                            : Icons.thumb_down_outlined,
                        size: 18.sp,
                        color: feedback == 'down'
                            ? AppColors.textSecondary
                            : AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 4.h),
              Text(
                time,
                style:
                    TextStyle(fontSize: 11.sp, color: AppColors.textDisabled),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecentQuestions extends StatelessWidget {
  const _RecentQuestions({required this.questions, required this.onTap});
  final List<String> questions;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '최근 질문',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 36.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: questions.length,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
              itemBuilder: (context, i) {
                final q = questions[i];
                final label = q.length > 18 ? '${q.substring(0, 18)}…' : q;
                return GestureDetector(
                  onTap: onTap == null ? null : () => onTap!(q),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(999.r),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// NOTE: `_GuideCard`는 현재 화면에서 사용하지 않아 제거했습니다.

// NOTE: `_GuideTh`, `_GuideTd`는 현재 화면에서 사용하지 않아 제거했습니다.

// NOTE: `_RelCard`, `_FbButton`은 현재 화면에서 사용하지 않아 제거했습니다.

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({
    required this.controller,
    required this.onSend,
    this.enabled = true,
  });
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      color: AppColors.background,
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F1F3),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add_rounded,
                color: AppColors.textSecondary, size: 24.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Container(
              height: 52.h,
              padding: EdgeInsets.fromLTRB(18.w, 0, 8.w, 0),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: const Color(0xFFE4DBF9)),
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      enabled: enabled,
                      onSubmitted: enabled ? (_) => onSend() : null,
                      style: TextStyle(fontSize: 14.sp),
                      decoration: InputDecoration(
                        hintText: '건강에 대해 질문해보세요...',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textDisabled,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: enabled ? onSend : null,
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFB99CFF), AppColors.aiPurple],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.send_rounded,
                          color: Colors.white, size: 20.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
