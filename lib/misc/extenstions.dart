import 'package:blaze_router/blaze_router.dart';

extension StringExtension on String {
  bool get isEmptyRoute => this == '/' || isEmpty;

  List<String> get pathSegments => split('/');
}

extension IterableExtension<T> on List<T> {
  List<T> removeDuplicates() {
    final list = <T>[];
    for (var i = 0; i < length; i++) {
      list
        ..remove(this[i])
        ..add(this[i]);
    }
    return list;
  }
}

extension RoutesExtension on List<IBlazeRoute> {
  List<IBlazeRoute> sortRoutes() {
    final sorted = [...this]..sort((a, b) => b.path.compareTo(a.path));
    return sorted;
  }
}
