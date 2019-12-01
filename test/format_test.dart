import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/format.dart';

void main() {
  group('hours', () {
    test('positive', () {
      expect(Format.hours(10), '10h');
    });

    test('zero', () {
      expect(Format.hours(0), '0h');
    });

    test('negative', () {
      expect(Format.hours(-5), '0h');
    });

    test('decimal', () {
      expect(Format.hours(4.5), '4.5h');
    });
  });

  group('date', () {
    test('2019-08-12', () {
      expect(
        Format.date(DateTime(2019, 8, 12)),
        'Aug 12, 2019',
      );
    });
  });

  group('dayOfWeek', () {
    test('Monday', () {
      expect(
        Format.dayOfWeek(DateTime(2019, 8, 12)),
        'Mon',
      );
    });
  });

  group('currency', () {
    test('positive', () {
      expect(Format.currency(10), '\$10');
    });

    test('zero', () {
      expect(Format.currency(0), '');
    });

    test('negative', () {
      expect(Format.currency(-5), '-\$5');
    });
  });
}
