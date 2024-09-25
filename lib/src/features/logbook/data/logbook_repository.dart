import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/features/authentication/data/auth_repository.dart';
import 'package:vanholst/src/features/logbook/data/fake_logbook_repository.dart';
import 'package:vanholst/src/features/logbook/data/wordpress_logbook_repository.dart';
import 'package:vanholst/src/features/logbook/domain/logbook_entry.dart';
import 'package:vanholst/src/utils/debounce.dart';

abstract class LogbookRepository {
  Future<List<LogbookEntry>> getLogbookEntryList();
  Future<LogbookEntry?> getLogbookEntry(String id);
  Future<void> updateLogbookEntry(LogbookEntry entry);
  Future<List<LogbookEntry>> searchLogbook(String query);
}

final logbookRepositoryProvider = Provider<LogbookRepository>((ref) {
  final appUser = ref.watch(authRepositoryProvider).currentUser;
  const isFake = String.fromEnvironment('useFakeRepos') == 'true';
  return isFake ? FakeLogbookRepository() : WordpressLogbookRepository(appUser);
});

class LogbookNotifier extends AsyncNotifier<List<LogbookEntry>> {
  late LogbookRepository _logbookRepository;

  @override
  Future<List<LogbookEntry>> build() {
    _logbookRepository = ref.watch(logbookRepositoryProvider);
    return _logbookRepository.getLogbookEntryList();
  }

  Future<void> updateLogbookEntry(LogbookEntry entry) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _logbookRepository.updateLogbookEntry(entry);
      return _logbookRepository.getLogbookEntryList();
    });
  }
}

final logbookNotifierProvider =
    AsyncNotifierProvider<LogbookNotifier, List<LogbookEntry>>(
        LogbookNotifier.new);

final logbookEntryProvider =
    FutureProvider.family<LogbookEntry?, String>((ref, id) async {
  final logbook = await ref.watch(logbookNotifierProvider.future);
  for (var entry in logbook) {
    if (entry.id == id) {
      return entry;
    }
  }
  return null;
});

final logbookSearchProvider = FutureProvider.autoDispose
    .family<List<LogbookEntry>, String>((ref, query) async {
  final logbookRepository = ref.watch(logbookRepositoryProvider);

  await debounce(const Duration(milliseconds: 750), ref);
  return logbookRepository.searchLogbook(query);
});
