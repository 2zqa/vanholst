import 'package:vanholst/src/constants/test_products.dart';
import 'package:vanholst/src/features/logbook/domain/product.dart';

class FakeLogbookRepository {
  FakeLogbookRepository._();
  static FakeLogbookRepository instance = FakeLogbookRepository._();

  final List<LogbookEntry> _entries = kTestLogbook;

  List<LogbookEntry> getLogbookEntryList() {
    return _entries;
  }

  LogbookEntry? getLogbookEntry(String id) {
    for (var entry in _entries) {
      if (entry.id == id) return entry;
    }
    return null;
  }
}
