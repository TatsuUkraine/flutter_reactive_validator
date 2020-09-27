import 'stream_error_provider.dart';
import 'validation_controller.dart';

/// [ValidationController] that uses [Stream] to handle errors
///
/// Also overrides defines extended [fieldErrorProvider] methods, that returns
/// error provider with an error message stream
abstract class StreamValidationController<K> extends ValidationController<K> {

  /// Provides [Stream] with validation errors for particular field
  Stream<String> fieldErrorStream(K field);

  @override
  StreamErrorProvider<K> fieldErrorProvider(K field);

  /// [Stream] with all validation error messages.
  Stream<Map<K, String>> get errorsStream;

  /// [Stream] with current validation state
  Stream<bool> get isValidStream;
}