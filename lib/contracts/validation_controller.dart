import 'error_provider.dart';
import 'validation_connector.dart';

abstract class ValidationController<K> {
  /// Attach multiple [ValidationConnector] to the controller
  void attachConnectors(Iterable<ValidationConnector<K, Object>> connectors);

  /// Add [ValidationConnector] to the active list
  void addConnector(ValidationConnector<K, Object> connector);

  /// Remove [ValidationConnector]
  void removeConnector(ValidationConnector<K, Object> connector);

  /// Provides [ErrorProvider] with validation error value and stream
  /// for particular field.
  ///
  /// [ErrorProvider.value] gives sync access to current validation error
  ErrorProvider<K> fieldErrorProvider(K field);

  /// Sync access to the validation error message if there is one
  String fieldError(K field);

  /// Sync access to current validation error messages
  Map<K, String> get errors;

  /// Sync access to validation state
  bool get isValid;

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