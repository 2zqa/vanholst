import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vanholst/src/features/logbook/data/logbook_repository.dart';
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
    return AppBar(
      title: Text('van Holst Coaching'.hardcoded),
      actions: [
        IconButton(
          onPressed: () {
            // TODO: check if this can be moved to a controller
            ref.invalidate(logbookSearchProvider);
            ref.invalidate(logbookEntryProvider);
          },
          icon: const Icon(Icons.refresh),
        ),
        IconButton(
          onPressed: () => context.goNamed(AppRoute.account.name),
          icon: const Icon(Icons.account_circle),
        ),
        IconButton(
          onPressed: () => context.goNamed(AppRoute.settings.name),
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
