class BlazeInneringException implements Exception {
  BlazeInneringException(this.maxInnering, this.yourInnering)
      : assert(
          yourInnering > maxInnering,
          'Your innering is less or equals max innering',
        );

  final int maxInnering;
  final int yourInnering;

  @override
  String toString() => 'BlazeInneringError: maxInnering = $maxInnering '
      'while yourInnering = $yourInnering';
}

class EmptyPagesException implements Exception {
  EmptyPagesException();

  @override
  String toString() => 'No pages were built';
}
