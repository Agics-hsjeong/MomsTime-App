import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/app_user.dart';
import 'user_repository.dart';

/// 인증 관련 예외 → 한국어 메시지 변환.
class AuthException implements Exception {
  AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Firebase Authentication + 사용자 프로필 생성/조회.
class AuthRepository {
  AuthRepository(this._auth, this._users);

  final FirebaseAuth _auth;
  final UserRepository _users;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user!;
      await _syncProfileFromAuth(user, provider: 'password');
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    }
  }

  Future<User> signUpWithEmail({
    required String email,
    required String password,
    required String nickname,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user!;
      await _ensureProfile(user, nickname: nickname, provider: 'password');
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    }
  }

  Future<User> signInWithGoogle() async {
    try {
      final google = GoogleSignIn.instance;
      await google.initialize();
      final account = await google.authenticate();
      final idToken = account.authentication.idToken;
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final cred = await _auth.signInWithCredential(credential);
      final user = cred.user!;
      await _syncProfileFromAuth(
        user,
        provider: 'google',
        preferredNickname: user.displayName ?? account.displayName ?? '',
      );
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    } catch (e) {
      throw AuthException('Google 로그인에 실패했어요. 다시 시도해주세요.');
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    }
  }

  Future<void> signOut() => _auth.signOut();

  /// 프로필 문서가 없으면 생성.
  Future<void> _ensureProfile(
    User user, {
    required String nickname,
    required String provider,
  }) async {
    final exists = await _users.exists(user.uid);
    if (exists) return;
    await _users.create(
      AppUser(
        uid: user.uid,
        nickname: nickname.isEmpty ? (user.email?.split('@').first ?? '사용자') : nickname,
        email: user.email ?? '',
        provider: provider,
        profileImage: user.photoURL ?? '',
      ),
    );
  }

  /// 로그인된 Auth 정보(닉네임/사진/이메일)가 프로필에 비어있으면 채워넣는다.
  Future<void> _syncProfileFromAuth(
    User user, {
    required String provider,
    String preferredNickname = '',
  }) async {
    final exists = await _users.exists(user.uid);
    if (!exists) {
      await _ensureProfile(
        user,
        nickname: preferredNickname,
        provider: provider,
      );
      return;
    }

    // 이미 문서가 있으면 '비어있는 필드'만 보강.
    final profile = await _users.fetch(user.uid);
    if (profile == null) return;
    final updates = <String, dynamic>{};

    if (profile.email.isEmpty && (user.email ?? '').isNotEmpty) {
      updates['email'] = user.email;
    }
    if (profile.nickname.isEmpty) {
      final n = preferredNickname.isNotEmpty
          ? preferredNickname
          : (user.displayName ?? (user.email?.split('@').first ?? '사용자'));
      updates['nickname'] = n;
    }
    if (profile.profileImage.isEmpty && (user.photoURL ?? '').isNotEmpty) {
      updates['profileImage'] = user.photoURL;
    }
    if (profile.provider.isEmpty) {
      updates['provider'] = provider;
    }

    if (updates.isNotEmpty) {
      await _users.update(user.uid, updates);
    }
  }

  String _messageFor(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return '이메일 형식이 올바르지 않아요.';
      case 'user-disabled':
        return '비활성화된 계정이에요.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return '이메일 또는 비밀번호가 올바르지 않아요.';
      case 'email-already-in-use':
        return '이미 가입된 이메일이에요.';
      case 'weak-password':
        return '비밀번호는 6자 이상이어야 해요.';
      case 'network-request-failed':
        return '네트워크 연결을 확인해주세요.';
      case 'too-many-requests':
        return '잠시 후 다시 시도해주세요.';
      default:
        return '오류가 발생했어요. (${e.code})';
    }
  }
}
