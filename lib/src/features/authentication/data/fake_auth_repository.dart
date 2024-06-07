import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/features/authentication/domain/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  AppUser? get currentUser;
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}

class WordpressAuthRepository implements AuthRepository {
  @override
  Stream<AppUser?> authStateChanges() {
    // TODO
    throw UnimplementedError();
  }

  @override
  AppUser? get currentUser {
    // TODO
    throw UnimplementedError();
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) {
    // TODO
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO
    throw UnimplementedError();
  }
}

class FakeAuthRepository implements AuthRepository {
  @override
  Stream<AppUser?> authStateChanges() => Stream.value(null);
  @override
  AppUser? get currentUser => null;

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    // TODO
  }

  @override
  Future<void> signOut() async {
    // TODO
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  const isFake = String.fromEnvironment('mock') == 'true';
  return isFake ? FakeAuthRepository() : WordpressAuthRepository();
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
