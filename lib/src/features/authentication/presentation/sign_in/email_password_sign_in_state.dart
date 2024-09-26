import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/features/authentication/presentation/sign_in/string_validators.dart';

/// Mixin class to be used for client-side email & password validation
mixin EmailAndPasswordValidators {
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordSignInSubmitValidator =
      NonEmptyStringValidator();
}

/// State class for the email & password form.
@immutable
class SignInState with EmailAndPasswordValidators {
  SignInState({
    this.value = const AsyncValue.data(null),
    this.isPasswordHidden = true,
  });

  final AsyncValue<void> value;
  final bool isPasswordHidden;
  bool get isLoading => value.isLoading;

  SignInState copyWith({
    AsyncValue<void>? value,
    bool? isPasswordHidden,
  }) {
    return SignInState(
      value: value ?? this.value,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
    );
  }

  @override
  String toString() =>
      'SignInState(value: $value, isPasswordHidden: $isPasswordHidden)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SignInState &&
        other.value == value &&
        other.isPasswordHidden == isPasswordHidden;
  }

  @override
  int get hashCode => value.hashCode ^ isPasswordHidden.hashCode;
}

extension SignInStateX on SignInState {
  bool canSubmitEmail(String email) {
    return emailSubmitValidator.isValid(email);
  }

  bool canSubmitPassword(String password) =>
      passwordSignInSubmitValidator.isValid(password);

  String? usernameErrorText(String email, AppLocalizations l) {
    final bool showErrorText = !canSubmitEmail(email);
    final String errorText = email.isEmpty
        ? l.signInEmptyUsernameError
        : l.signInInvalidUsernameError;
    return showErrorText ? errorText : null;
  }

  String? passwordErrorText(String password, AppLocalizations l) {
    final bool showErrorText = !canSubmitPassword(password);
    return showErrorText ? l.signInEmptyPasswordError : null;
  }
}
