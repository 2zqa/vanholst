import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/constants/test_products.dart';
import 'package:vanholst/src/features/logbook/domain/product.dart';

class FakeLogbookRepository {
  final List<LogbookEntry> _entries = kTestLogbook;

  // TODO: delete this method
  LogbookEntry getLogbookEntrySync(String id) {
    for (var entry in _entries) {
      if (entry.id == id) return entry;
    }
    return _entries.first;
  }

  Future<List<LogbookEntry>> getLogbookEntryList() async {
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(_entries);
  }

  Future<LogbookEntry?> getLogbookEntry(String id) async {
    await Future.delayed(const Duration(seconds: 2));

    for (var entry in _entries) {
      if (entry.id == id) return Future.value(entry);
    }
    return null;
  }
}

final logbookRepositoryProvider = Provider<FakeLogbookRepository>((ref) {
  return FakeLogbookRepository();
});

final logbookFutureProvider = FutureProvider<List<LogbookEntry>>((ref) {
  final logbookRepository = ref.watch(logbookRepositoryProvider);
  return logbookRepository.getLogbookEntryList();
});

final logbookEntryProvider =
    FutureProvider.family<LogbookEntry?, String>((ref, id) {
  final logbookRepository = ref.watch(logbookRepositoryProvider);
  return logbookRepository.getLogbookEntry(id);
});
