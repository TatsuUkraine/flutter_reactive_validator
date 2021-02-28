import 'stream_error_provider.dart';
import 'stream_errors_provider.dart';
import 'validation_controller.dart';

/// [ValidationController] that uses [Stream] to handle errors
///
/// Also overrides defines extended [fieldErrorProvider] methods, that returns
/// error provider with an error message stream
abstract class StreamValidationController<K>
    extends ValidationController<K> {
  /// Provides [Stream] with validation errors for particular field
  Stream<String?> fieldErrorStream(K field);

  /// Provides [Stream] with validation errors for multiple fields
  Stream<Iterable<String>> fieldsErrorStream(Iterable<K> fields);

  @override
  StreamErrorProvider<K> fieldErrorProvider(K field);

  @override
  StreamErrorsProvider<K> fieldsErrorProvider(Iterable<K> fields);

  /// [Stream] with all validation error messages.
  Stream<Map<K, String>> get errorsStream;

  /// [Stream] with current validation state
  Stream<bool> get isValidStream;
}
