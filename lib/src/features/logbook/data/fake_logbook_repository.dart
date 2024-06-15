import 'package:vanholst/src/constants/test_logbook.dart';
import 'package:vanholst/src/features/logbook/data/logbook_repository.dart';
import 'package:vanholst/src/features/logbook/domain/logbook_entry.dart';

class FakeLogbookRepository implements LogbookRepository {
  final List<LogbookEntry> _entries = kTestLogbook;

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

  @override
  Future<void> updateLogbookEntry(LogbookEntry entry) async {
    await Future.delayed(const Duration(seconds: 2));
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
    }
  }
}
