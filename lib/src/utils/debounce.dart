import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<T> debounce<T>({
  required Duration duration,
  required FutureProviderRef ref,
  required Future<T> Function() callback,
  required T fallback,
}) async {
  var didCancel = false;
  var didFinish = false;
  ref.onCancel(() {
    didCancel = true;
    if (!didFinish) {
      ref.invalidateSelf();
    }
  });

  await Future<void>.delayed(duration);
  if (!didCancel) {
    didFinish = true;
    return callback();
  }

  return fallback;
}
