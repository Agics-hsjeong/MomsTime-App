import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_providers.dart';
import '../../auth/application/auth_providers.dart';
import '../data/medication_repository.dart';
import '../domain/medication.dart';

/// 현재 사용자 기준 복약 리포지토리. (미로그인/미설정 시 null)
final medicationRepositoryProvider = Provider<MedicationRepository?>((ref) {
  if (!ref.watch(firebaseReadyProvider)) return null;
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return null;
  return MedicationRepository(ref.watch(firestoreProvider), uid);
});

/// 활성 약 목록.
final medicationsProvider = StreamProvider<List<Medication>>((ref) {
  final repo = ref.watch(medicationRepositoryProvider);
  if (repo == null) return Stream.value(const <Medication>[]);
  return repo.watchMedications();
});

/// 오늘 복약 로그.
final todayLogsProvider = StreamProvider<List<MedicationLogEntry>>((ref) {
  final repo = ref.watch(medicationRepositoryProvider);
  if (repo == null) return Stream.value(const <MedicationLogEntry>[]);
  return repo.watchLogsForDay(DateTime.now());
});

/// 오늘 복용해야 할 약(시간 단위) + 완료 여부.
final todayDosesProvider = Provider<List<MedicationDose>>((ref) {
  final meds = ref.watch(medicationsProvider).value ?? const [];
  final logs = ref.watch(todayLogsProvider).value ?? const [];
  final today = DateTime.now();

  final doses = <MedicationDose>[];
  for (final med in meds) {
    if (!med.activeOn(today)) continue;
    final times = med.times.isEmpty ? <String>[''] : med.times;
    for (final time in times) {
      MedicationLogEntry? match;
      for (final log in logs) {
        if (log.medicationId != med.id) continue;
        final t = log.scheduledTime;
        if (t == null) continue;
        final hhmm =
            '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
        if (hhmm == time) {
          match = log;
          break;
        }
      }
      doses.add(MedicationDose(
        medication: med,
        time: time,
        completed: match != null,
        logId: match?.id,
      ));
    }
  }
  doses.sort((a, b) => a.sortKey.compareTo(b.sortKey));
  return doses;
});

/// 복약 요약 통계.
class MedicationSummary {
  const MedicationSummary({
    required this.total,
    required this.completed,
    required this.medCount,
  });
  final int total;
  final int completed;
  final int medCount;

  int get rate => total == 0 ? 0 : ((completed / total) * 100).round();
}

final medicationSummaryProvider = Provider<MedicationSummary>((ref) {
  final doses = ref.watch(todayDosesProvider);
  final meds = ref.watch(medicationsProvider).value ?? const [];
  return MedicationSummary(
    total: doses.length,
    completed: doses.where((d) => d.completed).length,
    medCount: meds.length,
  );
});

/// 상세/수정 화면용 선택된 약 id.
class SelectedMedicationId extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? id) => state = id;
}

final selectedMedicationIdProvider =
    NotifierProvider<SelectedMedicationId, String?>(SelectedMedicationId.new);

final selectedMedicationProvider = Provider<Medication?>((ref) {
  final id = ref.watch(selectedMedicationIdProvider);
  if (id == null) return null;
  final meds = ref.watch(medicationsProvider).value ?? const [];
  for (final m in meds) {
    if (m.id == id) return m;
  }
  return null;
});

/// 복약 CRUD/토글 컨트롤러.
class MedicationController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  MedicationRepository? get _repo => ref.read(medicationRepositoryProvider);

  Future<String?> add(Medication med) async {
    final repo = _repo;
    if (repo == null) return null;
    state = const AsyncLoading();
    String? id;
    state = await AsyncValue.guard(() async {
      id = await repo.add(med);
    });
    return id;
  }

  Future<bool> edit(String id, Medication med) async {
    final repo = _repo;
    if (repo == null) return false;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.update(id, med));
    return !state.hasError;
  }

  Future<bool> delete(String id) async {
    final repo = _repo;
    if (repo == null) return false;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.delete(id));
    return !state.hasError;
  }

  /// 복용 완료/취소 토글.
  Future<void> toggleDose(MedicationDose dose) async {
    final repo = _repo;
    if (repo == null) return;
    if (dose.completed && dose.logId != null) {
      await repo.unmark(dose.logId!);
    } else {
      final now = DateTime.now();
      final parts = dose.time.split(':');
      final scheduled = DateTime(
        now.year,
        now.month,
        now.day,
        parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0,
        parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
      );
      await repo.markTaken(
        medicationId: dose.medication.id,
        scheduledTime: scheduled,
      );
    }
  }
}

final medicationControllerProvider =
    AsyncNotifierProvider<MedicationController, void>(MedicationController.new);
