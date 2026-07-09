/// 앱 라우트 경로 상수.
abstract final class Routes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String stage = '/stage';
  static const String home = '/home';
  static const String medicationRegister = '/medication/register';
  static const String medicationOcr = '/medication/ocr';
  static const String medicationDetail = '/medication/detail';
  static const String medicationEdit = '/medication/edit';
  static const String medicationComplete = '/medication/complete';
  static const String aiChat = '/ai/chat';
  static const String aiBriefing = '/ai/briefing';

  // 건강 / 검진 / 가족
  static const String health = '/health';
  static const String checkup = '/checkup';
  static const String checkupDetail = '/checkup/detail';
  static const String family = '/family';
  static const String familyInvite = '/family/invite';
  static const String report = '/report';
  static const String statistics = '/statistics';

  // 마이페이지 / 설정
  static const String profileEdit = '/mypage/profile';
  static const String accountSecurity = '/mypage/security';
  static const String notificationSettings = '/mypage/notifications/settings';
  static const String notifications = '/notifications';
  static const String languageRegion = '/mypage/language';
  static const String help = '/mypage/help';
  static const String appInfo = '/mypage/info';
  static const String premium = '/premium';
  static const String subscription = '/subscription';
  static const String payment = '/payment';
  static const String coupon = '/coupon';

  // 스토어 / 병원
  static const String store = '/store';
  static const String supplementDetail = '/store/supplement';
  static const String hospitalDetail = '/hospital/detail';
}
