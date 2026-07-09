import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_providers.dart';
import '../../auth/application/auth_providers.dart';
import '../data/schedule_repository.dart';
import '../domain/schedule.dart';

final scheduleRepositoryProvider = Provider<ScheduleRepository?>((ref) {
  if (!ref.watch(firebaseReadyProvider)) return null;
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return null;
  return ScheduleRepository(ref.watch(firestoreProvider), uid);
});

final schedulesProvider = StreamProvider<List<Schedule>>((ref) {
  final repo = ref.watch(scheduleRepositoryProvider);
  if (repo == null) return Stream.value(const <Schedule>[]);
  return repo.watchAll();
});

/// 선택된 날짜.
class SelectedDate extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();
  void set(DateTime d) => state = DateTime(d.year, d.month, d.day);
}

final selectedDateProvider =
    NotifierProvider<SelectedDate, DateTime>(SelectedDate.new);

/// 선택된 날짜의 일정.
final schedulesForSelectedDayProvider = Provider<List<Schedule>>((ref) {
  final all = ref.watch(schedulesProvider).value ?? const [];
  final day = ref.watch(selectedDateProvider);
  return all.where((s) {
    final d = s.date;
    if (d == null) return false;
    return d.year == day.year && d.month == day.month && d.day == day.day;
  }).toList();
});

class ScheduleController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  ScheduleRepository? get _repo => ref.read(scheduleRepositoryProvider);

  Future<bool> add(Schedule schedule) async {
    final repo = _repo;
    if (repo == null) return false;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.add(schedule));
    return !state.hasError;
  }

  Future<void> toggle(Schedule schedule) async {
    final repo = _repo;
    if (repo == null) return;
    await repo.toggleCompleted(schedule.id, !schedule.completed);
  }

  Future<void> delete(String id) async {
    final repo = _repo;
    if (repo == null) return;
    await repo.delete(id);
  }
}

final scheduleControllerProvider =
    AsyncNotifierProvider<ScheduleController, void>(ScheduleController.new);
