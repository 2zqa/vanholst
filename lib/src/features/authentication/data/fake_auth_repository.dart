import 'package:vanholst/src/features/authentication/data/auth_repository.dart';
import 'package:vanholst/src/features/authentication/domain/app_user.dart';
import 'package:vanholst/src/utils/in_memory_store.dart';

class FakeAuthRepository implements AuthRepository {
  final _authState = InMemoryStore<AppUser?>(null);

  @override
  Stream<AppUser?> authStateChanges() => _authState.stream;

  @override
  AppUser? get currentUser => _authState.value;

  @override
  void signOut() async => _authState.value = null;

  @override
  Future<void> signInWithUsernameAndPassword(
      String username, String password) async {
    _authState.value = AppUser(
      username: username,
      hash: '',
      loggedIn: '',
      sec: '',
    );
  }
}
