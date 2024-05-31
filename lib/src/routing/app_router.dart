// GoRouter configuration
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vanholst/src/features/account/account_screen.dart';
import 'package:vanholst/src/features/products_list/products_list_screen.dart';
import 'package:vanholst/src/features/sign_in/email_password_sign_in_screen.dart';
import 'package:vanholst/src/features/sign_in/email_password_sign_in_state.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: kDebugMode,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ProductsListScreen(),
      routes: [
        GoRoute(
          path: 'account',
          builder: (context, state) => const AccountScreen(),
        ),
        GoRoute(
          path: 'login',
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
);
