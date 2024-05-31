import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vanholst/src/common_widgets/action_text_button.dart';
import 'package:vanholst/src/localization/string_hardcoded.dart';
import 'package:vanholst/src/models/app_user.dart';

/// Custom [AppBar] widget that is reused by the [ProductsListScreen] and
/// [ProductScreen].
/// It shows the following actions, depending on the application state:
/// - [ShoppingCartIcon]
/// - Orders button
/// - Account or Sign-in button
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: get user from auth repository
    const user = AppUser(uid: '123', email: 'test@test.com');

    return AppBar(
      title: Text('Van Holst Coaching'.hardcoded),
      actions: [
        if (user != null) ...[
          ActionTextButton(
            text: 'Account'.hardcoded,
            onPressed: () => context.go('/account'),
          ),
        ] else
          ActionTextButton(
            text: 'Log In'.hardcoded,
            onPressed: () => context.go('/login'),
          )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
