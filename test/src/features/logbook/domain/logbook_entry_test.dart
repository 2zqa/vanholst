import 'package:flutter_test/flutter_test.dart';
import 'package:vanholst/src/features/logbook/domain/logbook_entry.dart';

void main() {
  group('LogbookEntry', () {
    test('should parse Uri from a href link', () {
      const link =
          "<a href='https://connect.garmin.com/modern/activity/88888888888' rel='nofollow' target='_blank'><button class=''>GPS</button></a>";
      const entry = LogbookEntry(
        userId: '123',
        id: '456',
        date: '01/01/2021',
        shortDayName: 'ma',
        program: 'program',
        link: link,
        timestamp: 'timestamp',
      );

      expect(entry.linkUri,
          Uri.parse('https://connect.garmin.com/modern/activity/88888888888'));
    });

    test('should return empty Uri when parsing from a blank link', () {
      const entry = LogbookEntry(
        userId: '123',
        id: '456',
        date: '01/01/2021',
        shortDayName: 'ma',
        program: 'program',
        link: '',
        timestamp: 'timestamp',
      );

      expect(entry.linkUri, Uri());
    });
  });
}
