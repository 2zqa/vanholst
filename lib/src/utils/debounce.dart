import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<T> debounce<T>({
  required Duration duration,
  required AutoDisposeFutureProviderRef ref,
  required Future<T> Function() callback,
}) async {
  var didDispose = false;
  ref.onDispose(() => didDispose = true);
  await Future<void>.delayed(duration);
  if (didDispose) {
    throw Exception('Cancelled');
  }

  return callback();
}
