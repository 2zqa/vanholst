// GoRouter configuration
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vanholst/src/features/account/account_screen.dart';
import 'package:vanholst/src/features/not_found/not_found_screen.dart';
import 'package:vanholst/src/features/products_list/products_list_screen.dart';
import 'package:vanholst/src/features/sign_in/email_password_sign_in_screen.dart';
import 'package:vanholst/src/features/sign_in/email_password_sign_in_state.dart';

enum AppRoute {
  home,
  account,
  login,
}

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: kDebugMode,
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home.name,
      builder: (context, state) => const ProductsListScreen(),
      routes: [
        GoRoute(
          path: 'account',
          name: AppRoute.account.name,
          builder: (context, state) => const AccountScreen(),
        ),
        GoRoute(
          path: 'login',
          name: AppRoute.login.name,
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            fullscreenDialog: true,
            child: const EmailPasswordSignInScreen(
              formType: EmailPasswordSignInFormType.signIn,
            ),
          ),
        ),
      ],
    )
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);
