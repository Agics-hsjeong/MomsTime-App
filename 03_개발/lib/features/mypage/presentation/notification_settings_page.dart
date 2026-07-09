import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';

import '../../../core/firebase/firebase_bootstrap.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/moms_app_bar.dart';
import '../../../shared/widgets/settings_widgets.dart';
import '../../notification/application/notification_providers.dart';
import '../../notification/domain/notification_settings.dart' as app;
import '../../../core/firebase/firebase_providers.dart';
import '../../auth/application/auth_providers.dart';

/// 알림 설정 — 마이페이지 > 알림 설정
class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState
    extends ConsumerState<NotificationSettingsPage> {
  app.NotificationSettings? _draft;

  app.NotificationSettings get _settings =>
      _draft ??
      ref.watch(notificationSettingsProvider).value ??
      const app.NotificationSettings();

  Future<void> _save(app.NotificationSettings next) async {
    setState(() => _draft = next);
    if (!firebaseReady) return;
    await ref.read(notificationControllerProvider.notifier).saveSettings(next);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('알림 설정이 저장되었어요.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = _settings;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MomsAppBar(title: '알림 설정'),
      body: ListView(
        padding: EdgeInsets.only(bottom: 32.h),
        children: [
          const SetLead('앱 알림 및 푸시 알림을 설정해요.'),
          SetSection(
            title: '푸시 알림',
            child: SetList(
              children: [
                SetSwitchRow(
                  title: '푸시 알림 받기',
                  subtitle: '중요한 알림을 놓치지 않도록 켜두세요.',
                  icon: Icons.notifications_active_rounded,
                  value: settings.pushEnabled,
                  onChanged: (v) => _save(settings.copyWith(pushEnabled: v)),
                  showDivider: false,
                ),
              ],
            ),
          ),
          SetSection(
            title: '알림 종류',
            child: SetList(
              children: [
                SetSwitchRow(
                  title: '복약 알림',
                  subtitle: '복용 시간에 맞춰 알려드려요.',
                  icon: Icons.medication_rounded,
                  value: settings.medication,
                  onChanged: (v) => _save(settings.copyWith(medication: v)),
                ),
                SetSwitchRow(
                  title: '검진 알림',
                  subtitle: '건강검진 일정을 알려드려요.',
                  icon: Icons.science_rounded,
                  value: settings.checkup,
                  onChanged: (v) => _save(settings.copyWith(checkup: v)),
                ),
                SetSwitchRow(
                  title: '예약 알림',
                  subtitle: '병원 예약 일정을 알려드려요.',
                  icon: Icons.event_rounded,
                  value: settings.booking,
                  onChanged: (v) => _save(settings.copyWith(booking: v)),
                ),
                SetSwitchRow(
                  title: 'AI 케어 알림',
                  subtitle: '맞춤 케어와 브리핑을 알려드려요.',
                  icon: Icons.favorite_rounded,
                  value: settings.care,
                  onChanged: (v) => _save(settings.copyWith(care: v)),
                ),
                SetSwitchRow(
                  title: '마케팅 알림',
                  subtitle: '이벤트 및 혜택 소식을 받아요.',
                  icon: Icons.campaign_rounded,
                  value: settings.marketing,
                  onChanged: (v) => _save(settings.copyWith(marketing: v)),
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SetNote('알림이 오지 않으면 기기 설정에서 Mom\'s Time 알림 권한을 확인해주세요.'),
          if (kDebugMode) ...[
            SizedBox(height: 12.h),
            SetSection(
              title: '개발자',
              child: SetList(
                children: [
                  SetRow(
                    title: '테스트 푸시 보내기',
                    subtitle: '서버(Cloud Functions)에서 내 기기로 푸시를 발송해요.',
                    icon: Icons.bolt_rounded,
                    onTap: () async {
                      if (!firebaseReady) return;
                      final uid = ref.read(authStateProvider).value?.uid;
                      if (uid == null) return;
                      final messenger = ScaffoldMessenger.of(context);
                      try {
                        final callable = ref
                            .read(firebaseFunctionsProvider)
                            .httpsCallable('sendNotification');
                        await callable.call({
                          'uid': uid,
                          'title': 'Mom\'s Time 테스트 알림',
                          'body': '알림을 탭하면 알림함으로 이동해요.',
                          'data': {
                            'type': 'system',
                            'actionLabel': '알림함 열기',
                            'actionRoute': Routes.notifications,
                          },
                        });
                        if (!mounted) return;
                        messenger.showSnackBar(
                          const SnackBar(content: Text('테스트 푸시를 요청했어요.')),
                        );
                      } catch (e) {
                        if (!mounted) return;
                        messenger.showSnackBar(
                          SnackBar(content: Text('푸시 요청 실패: $e')),
                        );
                      }
                    },
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
