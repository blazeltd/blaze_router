class BlazeInneringError extends Error {
  BlazeInneringError(this.maxInnering, this.yourInnering)
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
