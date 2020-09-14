abstract class ErrorProvider<K> {
  /// Field key
  K get field;

  /// Current validation error value
  String get value;

  /// If provider has an error message
  bool get hasValue;

  /// Validation error stream
  Stream<String> get stream;
}