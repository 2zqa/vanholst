import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/constants/test_products.dart';
import 'package:vanholst/src/features/authentication/domain/app_user.dart';
import 'package:vanholst/src/features/logbook/domain/product.dart';

abstract class LogbookRepository {
  Future<List<LogbookEntry>> getLogbookEntryList();
  Future<LogbookEntry?> getLogbookEntry(String id);
}

class WordpressLogbookRepository implements LogbookRepository {

  @override
  Future<List<LogbookEntry>> getLogbookEntryList() async {
    throw UnimplementedError();
  }

  @override
  Future<LogbookEntry?> getLogbookEntry(String id) async {
    throw UnimplementedError();
  }
}

class FakeLogbookRepository implements LogbookRepository {
  final List<LogbookEntry> _entries = kTestLogbook;

  // TODO: delete this method
  LogbookEntry getLogbookEntrySync(String id) {
    for (var entry in _entries) {
      if (entry.id == id) return entry;
    }
    return _entries.first;
  }

  @override
  Future<List<LogbookEntry>> getLogbookEntryList() async {
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(_entries);
  }

  @override
  Future<LogbookEntry?> getLogbookEntry(String id) async {
    await Future.delayed(const Duration(seconds: 2));

    for (var entry in _entries) {
      if (entry.id == id) return Future.value(entry);
    }
    return null;
  }
}

final logbookRepositoryProvider = Provider<LogbookRepository>((ref) {
  const isFake = String.fromEnvironment('mock') == 'true';
  return isFake ? FakeLogbookRepository() : WordpressLogbookRepository();
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
