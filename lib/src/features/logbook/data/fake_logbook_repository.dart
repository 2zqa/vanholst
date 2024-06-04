import 'package:vanholst/src/constants/test_products.dart';
import 'package:vanholst/src/features/logbook/domain/product.dart';

class FakeLogbookRepository {
  FakeLogbookRepository._();
  static FakeLogbookRepository instance = FakeLogbookRepository._();

  List<LogbookEntry> getLogbookEntryList() {
    return kTestLogbook;
  }

  LogbookEntry? getLogbookEntry(String id) {
    for (var entry in kTestLogbook) {
      if (entry.id == id) return entry;
    }
    return null;
  }
}
