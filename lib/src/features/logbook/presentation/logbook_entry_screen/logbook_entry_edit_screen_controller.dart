import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/features/logbook/data/logbook_repository.dart';
import 'package:vanholst/src/features/logbook/domain/logbook_entry.dart';

class LogbookEntryEditScreenController extends StateNotifier<AsyncValue<void>> {
  LogbookEntryEditScreenController({
    required this.logbookNotifier,
    required this.ref,
  }) : super(const AsyncValue.data(null));

  final LogbookNotifier logbookNotifier;
  final Ref ref;

  Future<bool> save(LogbookEntry entry) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await logbookNotifier.updateLogbookEntry(entry);
      ref.invalidate(logbookEntryProvider(entry.id));
    });
    return state.hasError == false;
  }
}

final logbookEntryEditScreenControllerProvider =
    StateNotifierProvider<LogbookEntryEditScreenController, AsyncValue<void>>(
        (ref) {
  return LogbookEntryEditScreenController(
      logbookNotifier: ref.watch(logbookNotifierProvider.notifier), ref: ref);
});
