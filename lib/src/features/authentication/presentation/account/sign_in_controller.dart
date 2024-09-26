import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/features/authentication/data/auth_repository.dart';
import 'package:vanholst/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';

class SignInController extends StateNotifier<SignInState> {
  SignInController({
    required this.authRepository,
  }) : super(SignInState());
  final AuthRepository authRepository;

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordHidden: !state.isPasswordHidden);
    debugPrint('Password visibility is now ${state.isPasswordHidden}');
  }

  Future<bool> submit(String email, String password) async {
    state = state.copyWith(
      value: const AsyncValue.loading(),
      isPasswordHidden: true,
    );
    final value = await AsyncValue.guard(
        () => authRepository.signInWithUsernameAndPassword(email, password));
    state = state.copyWith(value: value);
    return value.hasError == false;
  }
}

final signInControllerProvider =
    StateNotifierProvider.autoDispose<SignInController, SignInState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignInController(authRepository: authRepository);
});
