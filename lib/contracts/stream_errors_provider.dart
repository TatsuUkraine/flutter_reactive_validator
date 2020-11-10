import 'errors_provider.dart';

/// Extended [ErrorsProvider] that provides [Stream] with error message
abstract class StreamErrorsProvider<K> extends ErrorsProvider<K> {
  /// [Stream] with error messages
  Stream<Iterable<String>> get stream;
}
