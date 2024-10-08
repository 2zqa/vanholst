import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/common_widgets/primary_button.dart';
import 'package:vanholst/src/common_widgets/responsive_scrollable_card.dart';
import 'package:vanholst/src/constants/app_sizes.dart';
import 'package:vanholst/src/features/authentication/presentation/account/sign_in_controller.dart';
import 'package:vanholst/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:vanholst/src/features/authentication/presentation/sign_in/string_validators.dart';
import 'package:vanholst/src/localization/string_hardcoded.dart';
import 'package:vanholst/src/utils/async_value_ui.dart';

/// Email & password sign in screen.
/// Wraps the [SignInContents] widget below with a [Scaffold] and
/// [AppBar] with a title.
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  // * Keys for testing using find.byKey()
  static const emailKey = Key('email');
  static const passwordKey = Key('password');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).signInTitle)),
      body: const SignInContents(),
    );
  }
}

/// A widget for authenticating.
class SignInContents extends ConsumerStatefulWidget {
  const SignInContents({
    super.key,
    this.onSignedIn,
  });
  final VoidCallback? onSignedIn;

  @override
  ConsumerState<SignInContents> createState() => _SignInContentsState();
}

class _SignInContentsState extends ConsumerState<SignInContents> {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text;
  String get password => _passwordController.text;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var _submitted = false;

  @override
  void dispose() {
    // * TextEditingControllers should be always disposed
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(SignInState state) async {
    setState(() => _submitted = true);
    // only submit the form if validation passes
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(signInControllerProvider.notifier);
      final success = await controller.submit(email, password);
      if (success) {
        widget.onSignedIn?.call();
      }
    }
  }

  void _emailEditingComplete(SignInState state) {
    if (state.canSubmitEmail(email)) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete(SignInState state) {
    if (!state.canSubmitEmail(email)) {
      _node.previousFocus();
      return;
    }
    _submit(state);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      signInControllerProvider.select((state) => state.value),
      (_, value) => value.showAlertDialogOnError(context),
    );
    final l = AppLocalizations.of(context);
    final state = ref.watch(signInControllerProvider);
    return ResponsiveScrollableCard(
      child: FocusScope(
        node: _node,
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                gapH8,
                // Email field
                TextFormField(
                  autofillHints: const [AutofillHints.username],
                  key: SignInScreen.emailKey,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: l.signInLogin,
                    hintText: 'test@test.com'.hardcoded,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) => !_submitted
                      ? null
                      : state.usernameErrorText(email ?? '', l),
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _emailEditingComplete(state),
                  inputFormatters: <TextInputFormatter>[
                    ValidatorInputFormatter(
                        editingValidator: UsernameEditingRegexValidator()),
                  ],
                ),
                gapH8,
                // Password field
                TextFormField(
                  autofillHints: const [AutofillHints.password],
                  key: SignInScreen.passwordKey,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: l.signInPassword,
                    enabled: !state.isLoading,
                    suffixIcon: state.isPasswordHidden
                        ? IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              ref
                                  .read(signInControllerProvider.notifier)
                                  .togglePasswordVisibility();
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.visibility_off),
                            onPressed: () {
                              ref
                                  .read(signInControllerProvider.notifier)
                                  .togglePasswordVisibility();
                            },
                          ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (password) => !_submitted
                      ? null
                      : state.passwordErrorText(password ?? '', l),
                  obscureText: state.isPasswordHidden,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _passwordEditingComplete(state),
                ),
                gapH8,
                PrimaryButton(
                  text: l.signInSignIn,
                  isLoading: state.isLoading,
                  onPressed: state.isLoading ? null : () => _submit(state),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
