import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/features/authentication/data/auth_repository.dart';

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  AccountScreenController({required this.authRepository})
      : super(const AsyncValue.data(null));

  final AuthRepository authRepository;

  void signOut() => authRepository.signOut();
}

final accountScreenControllerProvider = StateNotifierProvider.autoDispose<
    AccountScreenController, AsyncValue<void>>(
  (ref) => AccountScreenController(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);
