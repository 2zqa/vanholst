import 'package:flutter_test/flutter_test.dart';
import 'package:vanholst/src/utils/retrieve_between.dart';

void main() {
  group('StringUtils', () {
    test('retrieveBetween should return the substring between start and end',
        () {
      const input = 'Hello [World]!';
      const start = '[';
      const end = ']';
      const expectedOutput = 'World';

      final result = input.retrieveBetween(start, end);

      expect(result, equals(expectedOutput));
    });

    test('retrieveBetween should return an empty string if start is not found',
        () {
      const input = 'Hello [World]!';
      const start = '(';
      const end = ']';
      const expectedOutput = '';

      final result = input.retrieveBetween(start, end);

      expect(result, equals(expectedOutput));
    });

    test('retrieveBetween should return an empty string if end is not found',
        () {
      const input = 'Hello [World]!';
      const start = '[';
      const end = ')';
      const expectedOutput = '';

      final result = input.retrieveBetween(start, end);

      expect(result, equals(expectedOutput));
    });

    test('retrieveBetween should return the substring between start and end with multiple characters', () {
      const input = 'Hello [World]!';
      const start = '[W';
      const end = 'ld]';
      const expectedOutput = 'or';
      final result = input.retrieveBetween(start, end);
      expect(result, equals(expectedOutput));
    });
  });
}
