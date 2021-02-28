import 'validation_controller.dart';

/// Defines relation between data and validation
abstract class ValidationConnector<K, I> {
  /// Field key for error message
  K get field;

  /// Attached [ValidationController] controller
  ValidationController<K>? get controller;

  /// Attach connector to the validation controller
  void attach(ValidationController<K> controller);

  /// Detach connector from the validation controller
  void detach();

  /// Validate current field value. Returns error message if
  /// current value is invalid
  String? validate();

  /// Validates field, and pushes result to the [ValidationController]
  void validateField();
}
