import 'validation_connector.dart';

abstract class ValidationController<K> {
  /// Attach multiple [ValidationConnector] to the controller
  void attachConnectors(Iterable<ValidationConnector<K, Object>> connectors);

  /// Add [ValidationConnector] to the active list
  void addConnector(ValidationConnector<K, Object> connector);

  /// Remove [ValidationConnector]
  void removeConnector(ValidationConnector<K, Object> connector);

  /// Provides [Stream] with validation errors for particular field
  Stream<String> fieldErrorStream(K field);

  /// Sync access to the validation error message if there is one
  String fieldError(K field);

  /// Sync access to current validation error messages
  Map<K, String> get errors;

  /// [Stream] with all validation error messages.
  Stream<Map<K, String>> get errorsStream;

  /// Sync access to validation state
  bool get isValid;

  /// [Stream] with current validation state
  Stream<bool> get isValidStream;

  /// Remove error message from particular field
  void clearFieldError(K field);

  /// Clear all validation errors
  void clearErrors();

  /// Add error message for some particular field
  void addFieldError(K field, String error);

  /// Replace error messages
  void addErrors(Map<K, String> errors);

  /// Invoke validation across all connected [ValidationConnector]
  Future<void> validate();

  /// Dispose method.
  ///
  /// In should be invoked when [ValidationController] no longer needed
  void dispose();
}