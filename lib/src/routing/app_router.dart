import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vanholst/src/features/authentication/presentation/account/account_screen.dart';
import 'package:vanholst/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:vanholst/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:vanholst/src/features/products/presentation/product_screen/product_screen.dart';
import 'package:vanholst/src/features/products/presentation/products_list/products_list_screen.dart';
import 'package:vanholst/src/routing/not_found_screen.dart';

enum AppRoute {
  home,
  product,
  account,
  signIn,
}

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home.name,
      builder: (context, state) => const ProductsListScreen(),
      routes: [
        GoRoute(
          path: 'product/:id',
          name: AppRoute.product.name,
          builder: (context, state) {
            final productId = state.pathParameters['id']!;
            return ProductScreen(productId: productId);
          },
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
            child: EmailPasswordSignInScreen(
              formType: EmailPasswordSignInFormType.signIn,
            ),
          ),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);
