/// 약 등록 위저드 폼 데이터 (4단계).
class MedicationRegisterData {
  String name = '';
  String type = '선택해주세요';
  String manufacturer = '';
  String intakeMethod = '경구 (먹는 약)';
  int doseAmount = 1;
  String doseUnit = '정';
  String frequency = '매일';
  String periodStart = '2024.06.02';
  String periodEnd = '2024.12.31';
  String memo = '';
  bool alarmEnabled = true;
  bool morningEnabled = true;
  String morningTime = '09:00';
  bool eveningEnabled = true;
  String eveningTime = '19:00';
  String beforeAlarm = '정시';
  String reAlarm = '안 함';
  bool appNotification = true;
  bool pushNotification = true;
  bool emailNotification = false;

  static const typeOptions = ['처방약', '일반약', '영양제'];
  static const intakeMethods = ['경구 (먹는 약)', '외용 (바르는 약)', '흡입', '기타'];
  static const doseUnits = ['정', '캡슐', '포', 'ml'];
  static const frequencies = ['매일', '격일', '요일 지정'];

  String get displayType =>
      typeOptions.contains(type) ? type : '영양제';

  String get timesSummary {
    final parts = <String>[];
    if (morningEnabled) parts.add('아침 $morningTime');
    if (eveningEnabled) parts.add('저녁 $eveningTime');
    return parts.join(' · ');
  }

  String get alarmMethods {
    final parts = <String>[];
    if (appNotification) parts.add('앱');
    if (pushNotification) parts.add('푸시');
    if (emailNotification) parts.add('이메일');
    return parts.join(' · ');
  }

  void applyOcr({
    required String drugName,
    required String drugType,
    String? maker,
  }) {
    name = drugName;
    type = drugType;
    if (maker != null) manufacturer = maker;
  }
}
