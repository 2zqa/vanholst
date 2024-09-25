import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> debounce(
  Duration duration,
  AutoDisposeFutureProviderRef ref,
) async {
  var didDispose = false;
  ref.onDispose(() => didDispose = true);
  await Future<void>.delayed(duration);
  if (didDispose) {
    throw Exception('Cancelled');
  }
}
