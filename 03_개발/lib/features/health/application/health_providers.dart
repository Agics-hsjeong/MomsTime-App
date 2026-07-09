import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_providers.dart';
import '../../auth/application/auth_providers.dart';
import '../data/health_repository.dart';
import '../domain/health_record.dart';

final healthRepositoryProvider = Provider<HealthRepository?>((ref) {
  if (!ref.watch(firebaseReadyProvider)) return null;
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return null;
  return HealthRepository(ref.watch(firestoreProvider), uid);
});

final healthRecordsProvider = StreamProvider<List<HealthRecord>>((ref) {
  final repo = ref.watch(healthRepositoryProvider);
  if (repo == null) return Stream.value(const <HealthRecord>[]);
  return repo.watchAll();
});

/// 종류별 최신 값.
final latestByTypeProvider = Provider<Map<HealthType, HealthRecord>>((ref) {
  final records = ref.watch(healthRecordsProvider).value ?? const [];
  final map = <HealthType, HealthRecord>{};
  for (final r in records) {
    final existing = map[r.type];
    if (existing == null) {
      map[r.type] = r;
    } else {
      final a = r.recordedAt;
      final b = existing.recordedAt;
      if (a != null && (b == null || a.isAfter(b))) map[r.type] = r;
    }
  }
  return map;
});

class HealthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  HealthRepository? get _repo => ref.read(healthRepositoryProvider);

  Future<bool> add(HealthRecord record) async {
    final repo = _repo;
    if (repo == null) return false;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.add(record));
    return !state.hasError;
  }

  Future<bool> delete(String id) async {
    final repo = _repo;
    if (repo == null) return false;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.delete(id));
    return !state.hasError;
  }
}

final healthControllerProvider =
    AsyncNotifierProvider<HealthController, void>(HealthController.new);
