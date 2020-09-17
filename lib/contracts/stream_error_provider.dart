import 'error_provider.dart';

abstract class StreamErrorProvider<K> extends ErrorProvider<K> {
  /// [Stream] with error message
  Stream<String> get stream;
}