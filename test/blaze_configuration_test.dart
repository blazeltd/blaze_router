import 'package:blaze_router/router/blaze_configuration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Blaze Configuration Tests', () {
    test('check if hashcode is the same for the same objects', () {
      const config1 = BlazeConfiguration(
        location: '/',
      );
      const config2 = BlazeConfiguration(
        location: '/',
      );
      expect(config1.hashCode, config2.hashCode);
    });

    test('check equals', () {
      const config1 = BlazeConfiguration(
        location: '/',
      );
      const config2 = BlazeConfiguration(
        location: '/',
      );
      expect(config1, config2);
    });

    test('check isFirst', () {
      const config1 = BlazeConfiguration(
        location: '/',
      );
      const config2 = BlazeConfiguration(
        location: '/hello',
      );
      expect(config1.isFirst, true);
      expect(config2.isFirst, false);
    });

    test('withQueryParams test', () {
      const config1 = BlazeConfiguration(
        location: '/',
      );
      const config2 = BlazeConfiguration(
        location: '/?age=20',
      );
      expect(config1.withQueryParams({'age': '20'}), config2);
    });

    test('copyWith test', () {
      const config1 = BlazeConfiguration(
        location: '/',
      );
      const config2 = BlazeConfiguration(
        location: '/hello',
      );
      expect(config1.copyWith(location: '/hello'), config2);
      expect(config1.copyWith(), config1);
    });

    test('get queryParams test', () {
      const config1 = BlazeConfiguration(
        location: '/',
      );
      const config2 = BlazeConfiguration(
        location: '/?age=20',
      );
      expect(config1.queryParams, const <String, String>{});
      expect(config2.queryParams, {'age': '20'});
    });
  });
}
