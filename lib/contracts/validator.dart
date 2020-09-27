/// Interface for all validators available in the system
abstract class Validator<I> {
  /// Invoke validation
  String call(I value);
}
