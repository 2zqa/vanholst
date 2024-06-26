import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vanholst/src/features/authentication/data/auth_repository.dart';
import 'package:vanholst/src/features/authentication/presentation/account/account_screen.dart';
import 'package:vanholst/src/features/authentication/presentation/sign_in/sign_in_screen.dart';
import 'package:vanholst/src/features/logbook/presentation/product_screen/logbook_entry_edit_screen.dart';
import 'package:vanholst/src/features/logbook/presentation/product_screen/logbook_entry_screen.dart';
import 'package:vanholst/src/features/logbook/presentation/products_list/logbook_screen.dart';
import 'package:vanholst/src/routing/go_router_refresh_stream.dart';
import 'package:vanholst/src/routing/not_found_screen.dart';

enum AppRoute {
  home,
  logbookEntry,
  logbookEntryEdit,
  account,
  signIn,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    redirect: (_, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final path = state.uri.path;
      if (isLoggedIn && path == '/signIn') {
        return '/';
      }
      if (!isLoggedIn && path == '/account') {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const LogbookScreen(),
        routes: [
          GoRoute(
            path: 'entry/:id',
            name: AppRoute.logbookEntry.name,
            builder: (context, state) {
              final entryId = state.pathParameters['id']!;
              return LogbookEntryScreen(entryId: entryId);
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: AppRoute.logbookEntryEdit.name,
                pageBuilder: (context, state) {
                  final entryId = state.pathParameters['id']!;
                  return MaterialPage(
                    fullscreenDialog: true,
                    child: LogbookEntryEditScreen(entryId: entryId),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: 'account',
            name: AppRoute.account.name,
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: AccountScreen(),
            ),
          ),
          GoRoute(
            path: 'signIn',
            name: AppRoute.signIn.name,
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: SignInScreen(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
