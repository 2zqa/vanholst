import 'dart:math';

import 'package:vanholst/src/constants/test_logbook.dart';
import 'package:vanholst/src/features/logbook/data/logbook_repository.dart';
import 'package:vanholst/src/features/logbook/domain/logbook_entry.dart';

class FakeLogbookRepository implements LogbookRepository {
  final List<LogbookEntry> _entries = kTestLogbook;

  @override
  Future<List<LogbookEntry>> getLogbookEntryList() async {
    await Future.delayed(const Duration(seconds: 1));
    final random = Random();
    final randomEntry = LogbookEntry(
      userId: '1',
      id: '1',
      infoForCoach: random.nextInt(100).toString(),
      date: '10/06/2024',
      shortDayName: 'x',
      program: '${random.nextInt(100)} minute walk',
      sleep: 'sleep',
      timings: 'timings',
      performance: 'performance',
      circumstances: 'circumstances',
      km: 'km',
      link: 'link',
      feedbackCoach: 'feedbackCoach',
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    return Future.value([randomEntry] + _entries);
  }

  @override
  Future<LogbookEntry?> getLogbookEntry(String id) async {
    await Future.delayed(const Duration(seconds: 1));

    for (var entry in _entries) {
      if (entry.id == id) return Future.value(entry);
    }
    return null;
  }

  @override
  Future<void> updateLogbookEntry(LogbookEntry entry) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
    }
  }

  @override
  Future<List<LogbookEntry>> searchLogbook(String query) async {
    await Future.delayed(const Duration(seconds: 1));
    return Future.value(_entries.where((e) {
      final String performance = e.performance ?? '';
      return performance.toLowerCase().contains(query.toLowerCase());
    }).toList());
  }
}
