/// Provides info about field validation
abstract class ErrorProvider<K> {
  /// Field key
  K get field;

  /// Current validation error value
  String get value;

  /// If provider has an error message
  bool get hasError;
}