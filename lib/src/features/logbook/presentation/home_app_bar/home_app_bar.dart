import 'package:flutter/material.dart';
import 'package:vanholst/src/features/logbook/presentation/home_app_bar/more_menu_button.dart';
import 'package:vanholst/src/localization/string_hardcoded.dart';

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
    return AppBar(
      title: Text('Van Holst'.hardcoded),
      actions: const [MyCascadingMenu()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
