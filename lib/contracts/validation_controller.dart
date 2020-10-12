import 'error_provider.dart';
import 'validation_connector.dart';

/// Base validation controller interface
abstract class ValidationController<K> {
  /// Attach multiple [ValidationConnector] to the controller
  void attachConnectors(Iterable<ValidationConnector<K, Object>> connectors);

  /// Add [ValidationConnector] to the active list.
  ///
  /// This method doesn't actually attach connector,
  /// which means that connector won't track any value changes.
  ///
  /// To properly add connector use [attachConnectors] or
  /// [ValidationConnector.attach]
  void addConnector(ValidationConnector<K, Object> connector);

  /// Remove [ValidationConnector].
  ///
  /// This method doesn't detach connector, which means that connector
  /// still will be thinking that he's attached to the controller
  ///
  /// To properly remove connector use
  /// [ValidationConnector.detach]
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

  /// Returns `true` whenever controller is disposed
  bool get disposed;

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
  /// It should be invoked when [ValidationController] no longer needed
  void dispose();
}
