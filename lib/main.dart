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
import 'package:vanholst/src/features/settings/data/package_info_repository.dart';
import 'package:vanholst/src/features/settings/data/settings_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  // TODO: check if these can be awaited in parallel
  final wordpressAuthRepository = await WordpressAuthRepository.makeDefault();
  final settingsRepository = await SettingsRepository.makeDefault();
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWith((ref) {
        // Run with this command:
        // flutter run --dart-define=useFakeRepos=true/false
        const isFake = String.fromEnvironment('useFakeRepos') == 'true';
        return isFake ? FakeAuthRepository() : wordpressAuthRepository;
      }),
      settingsRepositoryProvider.overrideWith((ref) => settingsRepository),
    ],
    observers: [AsyncErrorLogger()],
  );
  final errorLogger = container.read(errorLoggerProvider);
  final packageInfoRepository = container.read(packageInfoRepositoryProvider);
  final packageInfo = await packageInfoRepository.getPackageInfo();
  registerErrorHandlers(errorLogger);
  runApp(UncontrolledProviderScope(
    container: container,
    child: VanHolst(title: packageInfo.appName),
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
          return Text(AppLocalizations.of(context).appErrorMessage);
        }),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}
