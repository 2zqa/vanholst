// GoRouter configuration
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:vanholst/src/features/account/account_screen.dart';
import 'package:vanholst/src/features/products_list/products_list_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: kDebugMode,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ProductsListScreen(),
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) => const AccountScreen(),
    )
  ],
);
