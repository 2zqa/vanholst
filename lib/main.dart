import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:vanholst/src/app.dart';
import 'package:vanholst/src/exceptions/async_error_logger.dart';
import 'package:vanholst/src/exceptions/error_logger.dart';
import 'package:vanholst/src/features/authentication/data/auth_repository.dart';
import 'package:vanholst/src/features/authentication/data/fake_auth_repository.dart';
import 'package:vanholst/src/features/authentication/data/wordpress_auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  final wordpressAuthRepository = await WordpressAuthRepository.makeDefault();
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWith((ref) {
        // Run with this command:
        // flutter run --dart-define=useFakeRepos=true/false
        const isFake = String.fromEnvironment('useFakeRepos') == 'true';
        return isFake ? FakeAuthRepository() : wordpressAuthRepository;
      })
    ],
    observers: [AsyncErrorLogger()],
  );
  final errorLogger = container.read(errorLoggerProvider);
  registerErrorHandlers(errorLogger);
  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
}

void registerErrorHandlers(ErrorLogger errorLogger) {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    errorLogger.logError(details.exception, details.stack);
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    errorLogger.logError(error, stack);
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Builder(builder: (context) {
          return Text(AppLocalizations.of(context).app_error_message);
        }),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}
