import 'package:blaze_router/blaze_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Blaze Errors', () {
    group('Blaze Innering error', () {
      test('Check if params are valid', () {
        final inneringError = BlazeInneringError(10, 11);
        expect(inneringError.maxInnering, 10);
        expect(inneringError.yourInnering, 11);
      });
      test('Check if there is an assertion error with wrong values', () {
        expect(
          () => BlazeInneringError(5, 2),
          throwsAssertionError,
        );
      });
      test('To string returns normally', () {
        final inneringError = BlazeInneringError(10, 11);
        expect(inneringError.toString, returnsNormally);
      });
    });
  });
}
