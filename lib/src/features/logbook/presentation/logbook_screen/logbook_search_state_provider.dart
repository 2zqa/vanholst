import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vanholst/src/features/logbook/data/logbook_repository.dart';
import 'package:vanholst/src/features/logbook/domain/logbook_entry.dart';

final logbookSearchQueryStateProvider = StateProvider<String>((ref) {
  return '';
});

final logbookSearchResultsProvider =
    FutureProvider<List<LogbookEntry>>((ref) async {
  final searchQuery = ref.watch(logbookSearchQueryStateProvider);
  return ref.watch(logbookSearchProvider(searchQuery).future);
});
