import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/features/authentication/presentation/sign_in/string_validators.dart';
import 'package:vanholst/src/localization/string_hardcoded.dart';

/// Mixin class to be used for client-side email & password validation
mixin EmailAndPasswordValidators {
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator =
      MinLengthStringValidator(8);
  final StringValidator passwordSignInSubmitValidator =
      NonEmptyStringValidator();
}

/// State class for the email & password form.
@immutable
class EmailPasswordSignInState with EmailAndPasswordValidators {
  EmailPasswordSignInState({
    this.value = const AsyncValue.data(null),
  });

  final AsyncValue<void> value;
  bool get isLoading => value.isLoading;

  EmailPasswordSignInState copyWith({
    AsyncValue<void>? value,
  }) {
    return EmailPasswordSignInState(
      value: value ?? this.value,
    );
  }

  @override
  String toString() => 'EmailPasswordSignInState(value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmailPasswordSignInState && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

extension EmailPasswordSignInStateX on EmailPasswordSignInState {
  String get passwordLabelText => 'Password'.hardcoded;

  bool canSubmitEmail(String email) {
    return emailSubmitValidator.isValid(email);
  }

  bool canSubmitPassword(String password) =>
      passwordSignInSubmitValidator.isValid(password);

  String? emailErrorText(String email) {
    final bool showErrorText = !canSubmitEmail(email);
    final String errorText = email.isEmpty
        ? 'Email can\'t be empty'.hardcoded
        : 'Invalid email'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String? passwordErrorText(String password) {
    final bool showErrorText = !canSubmitPassword(password);
    final String errorText = password.isEmpty
        ? 'Password can\'t be empty'.hardcoded
        : 'Password is too short'.hardcoded;
    return showErrorText ? errorText : null;
  }
}
