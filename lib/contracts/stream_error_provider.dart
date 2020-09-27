import 'error_provider.dart';

/// Extended [ErrorProvider] that provides [Stream] with error message
abstract class StreamErrorProvider<K> extends ErrorProvider<K> {
  /// [Stream] with error message
  Stream<String> get stream;
}
