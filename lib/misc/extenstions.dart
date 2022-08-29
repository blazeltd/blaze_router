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
