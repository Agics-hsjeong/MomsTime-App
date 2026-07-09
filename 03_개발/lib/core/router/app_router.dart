import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../firebase/firebase_bootstrap.dart';
import '../../features/auth/application/auth_providers.dart';
import '../../features/ai_care/presentation/ai_briefing_page.dart';
import '../../features/ai_care/presentation/ai_chat_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/checkup/presentation/checkup_detail_page.dart';
import '../../features/checkup/presentation/checkup_page.dart';
import '../../features/family/presentation/family_invite_page.dart';
import '../../features/family/presentation/family_page.dart';
import '../../features/health/presentation/health_page.dart';
import '../../features/health/presentation/statistics_detail_page.dart';
import '../../features/medication/presentation/medication_complete_page.dart';
import '../../features/medication/presentation/medication_detail_page.dart';
import '../../features/medication/presentation/medication_edit_page.dart';
import '../../features/medication/presentation/medication_register_page.dart';
import '../../features/medication/presentation/ocr_result_page.dart';
import '../../features/medication/presentation/report_page.dart';
import '../../features/checkup/presentation/hospital_detail_page.dart';
import '../../features/mypage/presentation/coupon_page.dart';
import '../../features/mypage/presentation/payment_page.dart';
import '../../features/mypage/presentation/subscription_page.dart';
import '../../features/store/presentation/store_page.dart';
import '../../features/store/presentation/supplement_detail_page.dart';
import '../../features/mypage/presentation/account_security_page.dart';
import '../../features/mypage/presentation/app_info_page.dart';
import '../../features/mypage/presentation/help_page.dart';
import '../../features/mypage/presentation/language_region_page.dart';
import '../../features/mypage/presentation/notification_page.dart';
import '../../features/mypage/presentation/notification_settings_page.dart';
import '../../features/mypage/presentation/premium_page.dart';
import '../../features/mypage/presentation/profile_edit_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/shell/presentation/main_shell.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../../features/stage/presentation/stage_page.dart';
import 'app_routes.dart';

/// 앱 라우터 (Riverpod).
/// 흐름: Splash → Onboarding → Login → Stage → Home
/// 로그인 상태에 따라 보호 라우트 접근을 제어한다.
final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.onDispose(refresh.dispose);
  ref.listen(authStateProvider, (_, _) => refresh.value++);
  ref.listen(currentUserProfileProvider, (_, _) => refresh.value++);

  const publicRoutes = {Routes.splash, Routes.onboarding, Routes.login};
  const onboardingRoutes = {Routes.stage, Routes.profileEdit};

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      // Firebase 미설정(개발/목업) 시에는 자유 탐색 허용.
      if (!firebaseReady) return null;
      final loggedIn = ref.read(authStateProvider).value != null;
      final loc = state.matchedLocation;
      final isPublic = publicRoutes.contains(loc);
      if (!loggedIn && !isPublic) return Routes.login;
      if (loggedIn && loc == Routes.login) return Routes.home;

      // 로그인 상태라면 프로필 완성도에 따라 초기 흐름을 안내.
      if (loggedIn) {
        final profileAsync = ref.read(currentUserProfileProvider);
        final profile = profileAsync.value;
        // 로딩/에러 중엔 강제 리다이렉트로 루프를 만들지 않는다.
        if (profile != null) {
          if (!profile.stageCompleted &&
              !onboardingRoutes.contains(loc) &&
              loc != Routes.stage) {
            return Routes.stage;
          }
        }
      }
      return null;
    },
    routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: Routes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: Routes.stage,
      builder: (context, state) => const StagePage(),
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const MainShell(),
    ),
    GoRoute(
      path: Routes.medicationRegister,
      builder: (context, state) {
        final step = int.tryParse(state.uri.queryParameters['step'] ?? '') ?? 0;
        return MedicationRegisterPage(initialStep: step.clamp(0, 3));
      },
    ),
    GoRoute(
      path: Routes.medicationOcr,
      builder: (context, state) => const OcrResultPage(),
    ),
    GoRoute(
      path: Routes.medicationDetail,
      builder: (context, state) => const MedicationDetailPage(),
    ),
    GoRoute(
      path: Routes.medicationEdit,
      builder: (context, state) => const MedicationEditPage(),
    ),
    GoRoute(
      path: Routes.medicationComplete,
      builder: (context, state) => const MedicationCompletePage(),
    ),
    GoRoute(
      path: Routes.aiChat,
      builder: (context, state) => const AiChatPage(),
    ),
    GoRoute(
      path: Routes.aiBriefing,
      builder: (context, state) => const AiBriefingPage(),
    ),
    GoRoute(
      path: Routes.health,
      builder: (context, state) => const HealthPage(),
    ),
    GoRoute(
      path: Routes.checkup,
      builder: (context, state) => const CheckupPage(),
    ),
    GoRoute(
      path: Routes.checkupDetail,
      builder: (context, state) => const CheckupDetailPage(),
    ),
    GoRoute(
      path: Routes.family,
      builder: (context, state) => const FamilyPage(),
    ),
    GoRoute(
      path: Routes.familyInvite,
      builder: (context, state) => const FamilyInvitePage(),
    ),
    GoRoute(
      path: Routes.report,
      builder: (context, state) => const ReportPage(),
    ),
    GoRoute(
      path: Routes.statistics,
      builder: (context, state) => const StatisticsDetailPage(),
    ),
    GoRoute(
      path: Routes.profileEdit,
      builder: (context, state) => const ProfileEditPage(),
    ),
    GoRoute(
      path: Routes.accountSecurity,
      builder: (context, state) => const AccountSecurityPage(),
    ),
    GoRoute(
      path: Routes.notificationSettings,
      builder: (context, state) => const NotificationSettingsPage(),
    ),
    GoRoute(
      path: Routes.notifications,
      builder: (context, state) => const NotificationPage(),
    ),
    GoRoute(
      path: Routes.languageRegion,
      builder: (context, state) => const LanguageRegionPage(),
    ),
    GoRoute(
      path: Routes.help,
      builder: (context, state) => const HelpPage(),
    ),
    GoRoute(
      path: Routes.appInfo,
      builder: (context, state) => const AppInfoPage(),
    ),
    GoRoute(
      path: Routes.premium,
      builder: (context, state) => const PremiumPage(),
    ),
    GoRoute(
      path: Routes.subscription,
      builder: (context, state) => const SubscriptionPage(),
    ),
    GoRoute(
      path: Routes.payment,
      builder: (context, state) => const PaymentPage(),
    ),
    GoRoute(
      path: Routes.coupon,
      builder: (context, state) => const CouponPage(),
    ),
    GoRoute(
      path: Routes.store,
      builder: (context, state) => const StorePage(),
    ),
    GoRoute(
      path: Routes.supplementDetail,
      builder: (context, state) => const SupplementDetailPage(),
    ),
    GoRoute(
      path: Routes.hospitalDetail,
      builder: (context, state) => const HospitalDetailPage(),
    ),
    ],
  );
});
