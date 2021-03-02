/// Provides info about validation among multiple fields
abstract class ErrorsProvider<K> {
  /// Field keys
  Iterable<K> get fields;

  /// Current validation error values
  Iterable<String> get value;

  /// If provider has an error messages
  bool get hasError;
}
