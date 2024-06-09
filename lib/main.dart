import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:vanholst/src/app.dart';
import 'package:vanholst/src/features/authentication/data/auth_repository.dart';
import 'package:vanholst/src/features/authentication/data/fake_auth_repository.dart';
import 'package:vanholst/src/features/authentication/data/wordpress_auth_repository.dart';
import 'package:vanholst/src/localization/string_hardcoded.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  registerErrorHandlers();
  final wordpressAuthRepository = await WordpressAuthRepository.makeDefault();
  runApp(ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWith((ref) {
        // Run with this command:
        // flutter run --dart-define=useFakeRepos=true/false
        const isFake = String.fromEnvironment('useFakeRepos') == 'true';
        return isFake ? FakeAuthRepository() : wordpressAuthRepository;
      })
    ],
    child: const MyApp(),
  ));
}

void registerErrorHandlers() {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint(error.toString());
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('An error occurred'.hardcoded),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}
