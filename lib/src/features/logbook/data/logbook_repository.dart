import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/features/authentication/data/auth_repository.dart';
import 'package:vanholst/src/features/logbook/data/fake_logbook_repository.dart';
import 'package:vanholst/src/features/logbook/data/wordpress_logbook_repository.dart';
import 'package:vanholst/src/features/logbook/domain/logbook_entry.dart';

abstract class LogbookRepository {
  Future<List<LogbookEntry>> getLogbookEntryList();
  Future<LogbookEntry?> getLogbookEntry(String id);
  Future<void> updateLogbookEntry(LogbookEntry entry);
}

final logbookRepositoryProvider = Provider<LogbookRepository>((ref) {
  final appUser = ref.watch(authRepositoryProvider).currentUser;
  const isFake = String.fromEnvironment('useFakeRepos') == 'true';
  return isFake ? FakeLogbookRepository() : WordpressLogbookRepository(appUser);
});

final logbookEntryListProvider = FutureProvider<List<LogbookEntry>>((ref) {
  final logbookRepository = ref.watch(logbookRepositoryProvider);
  return logbookRepository.getLogbookEntryList();
});

final logbookEntryProvider =
    FutureProvider.family<LogbookEntry?, String>((ref, id) {
  final logbookRepository = ref.watch(logbookRepositoryProvider);
  return logbookRepository.getLogbookEntry(id);
});
