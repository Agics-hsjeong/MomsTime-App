import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firebase_providers.dart';
import '../data/auth_repository.dart';
import '../data/user_repository.dart';
import '../domain/app_user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(firestoreProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(userRepositoryProvider),
  );
});

/// FirebaseAuth 로그인 상태 스트림. (미설정 시 항상 로그아웃)
final authStateProvider = StreamProvider<User?>((ref) {
  if (!ref.watch(firebaseReadyProvider)) {
    return Stream<User?>.value(null);
  }
  return ref.watch(authRepositoryProvider).authStateChanges();
});

/// 현재 로그인 여부 (동기 편의값).
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).value != null;
});

/// 현재 사용자 프로필(Firestore) 스트림.
final currentUserProfileProvider = StreamProvider<AppUser?>((ref) {
  final authUser = ref.watch(authStateProvider).value;
  if (authUser == null) return Stream<AppUser?>.value(null);
  return ref.watch(userRepositoryProvider).watch(authUser.uid);
});

/// 로그인/회원가입/로그아웃 액션 컨트롤러.
class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<bool> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.signInWithEmail(email: email, password: password),
    );
    return !state.hasError;
  }

  Future<bool> signUp(String email, String password, String nickname) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.signUpWithEmail(
        email: email,
        password: password,
        nickname: nickname,
      ),
    );
    return !state.hasError;
  }

  Future<bool> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.signInWithGoogle());
    return !state.hasError;
  }

  Future<bool> sendPasswordReset(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.sendPasswordReset(email));
    return !state.hasError;
  }

  Future<void> signOut() async {
    await _repo.signOut();
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, void>(AuthController.new);
