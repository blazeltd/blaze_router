import 'package:blaze_router/blaze_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Blaze Routes Tests',
    () {
      late BlazeRoutes blazeRoutes;
      late List<IBlazeRoute> routes;

      setUp(() {
        routes = const <IBlazeRoute>[
          BlazeRoute(path: '/'),
          BlazeRoute(path: '/home'),
          BlazeRoute(path: '/feed'),
        ];
        blazeRoutes = BlazeRoutes(routes: routes);
      });
      test('Test if it finds a correct item by path', () {
        expect(blazeRoutes.find('/home'), const BlazeRoute(path: '/home'));
        expect(blazeRoutes.find('/'), const BlazeRoute(path: '/'));
        expect(blazeRoutes.find('/feed'), const BlazeRoute(path: '/feed'));
      });
    },
  );
}
