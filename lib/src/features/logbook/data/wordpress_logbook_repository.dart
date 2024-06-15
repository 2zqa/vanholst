import 'package:vanholst/src/features/logbook/data/logbook_repository.dart';
import 'package:vanholst/src/features/logbook/domain/logbook_entry.dart';

class WordpressLogbookRepository implements LogbookRepository {
  @override
  Future<List<LogbookEntry>> getLogbookEntryList() async {
    throw UnimplementedError();
  }

  @override
  Future<LogbookEntry?> getLogbookEntry(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateLogbookEntry(LogbookEntry entry) {
    // TODO: implement updateLogbookEntry
    throw UnimplementedError();
  }
}
