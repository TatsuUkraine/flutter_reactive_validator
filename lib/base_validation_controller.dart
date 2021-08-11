import 'package:reactive_validator/reactive_validator.dart';

import 'utils.dart';

/// Base class with common logic for [ValidationController]'s
abstract class BaseValidationController<K> implements ValidationController<K> {
  bool _disposed = false;

  /// Set of connected [ValidationConnector]'s
  List<ValidationConnector<K, dynamic>> _connectors = [];

  BaseValidationController(
      [List<ValidationConnector<K, dynamic>> connectors = const []]) {
    attachConnectors(connectors);
  }

  @override
  String? fieldError(K field) => errors[field];

  @override
  Iterable<String> fieldsError(Iterable<K> fields) =>
      filterErrors(fields, errors);

  @override
  bool get isValid => errors.isEmpty;

  @override
  bool get disposed => _disposed;

  @override
  void clearFieldError(K field) {
    addErrors({...errors}..remove(field));
  }

  @override
  void clearErrors() {
    if (isValid) {
      return;
    }

    addErrors({});
  }

  @override
  void addFieldError(K field, String error) => addErrors({
        ...errors,
        field: error,
      });

  @override
  Future<void> validate() {
    return Future.wait(
            _connectors.map<Future<_ValidationResult<K>>>((connector) {
      return Future.microtask(
          () => _ValidationResult<K>(connector.field, connector.validate()));
    }).toList())
        .then((collection) {
      return collection.fold<Map<K, String>>({}, (value, result) {
        if (!result.hasError) {
          return value;
        }

        return {
          ...value,
          result.field: result.error!,
        };
      });
    }).then(addErrors);
  }

  @override
  void dispose() {
    _disposed = true;

    [..._connectors].forEach((validator) {
      validator.detach();
    });

    _connectors.clear();
  }

  @override
  void addConnector(ValidationConnector<K, Object?> connector) {
    _connectors.add(connector);
  }

  @override
  void removeConnector(ValidationConnector<K, Object?> connector) {
    _connectors.remove(connector);

    if (_disposed) {
      return;
    }

    clearFieldError(connector.field);
  }

  @override
  void attachConnectors(Iterable<ValidationConnector<K, Object?>> connectors) {
    connectors.forEach((connector) {
      connector.attach(this);
    });
  }
}

/// Validation result
class _ValidationResult<K> {
  /// Field name
  final K field;

  /// Validation error message
  final String? error;

  _ValidationResult(this.field, this.error);

  /// If result has error message
  bool get hasError => error != null;
}
