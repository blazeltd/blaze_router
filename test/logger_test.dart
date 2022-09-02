import 'dart:async';

import 'package:blaze_router/misc/logger.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';

final log = <String>[];

void main() {
  runZonedGuarded(
    () async {
      test(
        'check if logger logs right string',
        overridePrint(() {
          l('privet');
          expect(
            log,
            isNotEmpty,
          );
          expect(log.firstOrNull, contains('privet'));
        }),
      );
    },
    (error, stack) {
      Zone.root.print(error.toString());
    },
    zoneValues: const {
      #debug: true,
    },
  );
}

void Function() overridePrint(void Function() testFn) => () {
      final spec = ZoneSpecification(
        print: (
          _,
          __,
          ___,
          msg,
        ) {
          // Add to log instead of printing to stdout
          log.add(msg);
        },
      );
      return Zone.current.fork(
        specification: spec,
        zoneValues: {#debug: true},
      ).run<void>(testFn);
    };
