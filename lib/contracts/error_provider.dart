abstract class ErrorProvider<K> {
  /// Field key
  K get field;

  /// Current validation error value
  String get value;

  /// Validation error stream
  Stream<String> get stream;
}