import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vanholst/src/common_widgets/action_text_button.dart';
import 'package:vanholst/src/features/authentication/data/auth_repository.dart';
import 'package:vanholst/src/localization/string_hardcoded.dart';
import 'package:vanholst/src/routing/app_router.dart';

/// Custom [AppBar] widget that is reused by the [ProductsListScreen] and
/// [ProductScreen].
/// It shows the following actions, depending on the application state:
/// - [ShoppingCartIcon]
/// - Orders button
/// - Account or Sign-in button
class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    return AppBar(
      title: Text('Van Holst'.hardcoded),
      actions: [
        if (user != null)
          ActionTextButton(
            text: 'Account'.hardcoded,
            onPressed: () => context.goNamed(AppRoute.account.name),
          )
        else
          ActionTextButton(
            text: 'Sign In'.hardcoded,
            onPressed: () => context.goNamed(AppRoute.signIn.name),
          )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
