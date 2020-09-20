import 'package:flutter/foundation.dart';

import 'value_error_provider.dart';
import 'contracts/error_provider.dart';
import 'contracts/validation_connector.dart';
import 'contracts/listenable_validation_controller.dart';


/// Validation controller that contains current state of validation.
///
/// Can be used to insert custom validation messages provided from API
/// or can be managed by [ValidationConnector]'s on data stream changes.
///
/// Works with [ValueNotifier] as a controller.
class ValueListenableValidationController<K> implements ListenableValidationController<K> {
  final ValueNotifier<Map<K, String>> valueNotifier;

  List<ValidationConnector<K,Object>> _connectors = [];

  ValueListenableValidationController()
      : valueNotifier = ValueNotifier<Map<K, String>>({});

  ValueListenableValidationController.seeded(Map<K, String> errors)
      : valueNotifier = ValueNotifier<Map<K, String>>(errors);

  @override
  ErrorProvider<K> fieldErrorProvider(K field) =>
      ValueErrorProvider<K>(field, errors[field]);

  @override
  String fieldError(K field) => errors[field];

  @override
  Map<K, String> get errors => valueNotifier.value;

  @override
  ValueListenable<Map<K, String>> get errorsNotifier => valueNotifier;

  @override
  bool get isValid => errors.isEmpty;

  @override
  void clearFieldError(K field) {
    if (!errors.containsKey(field)) {
      return;
    }

    valueNotifier.value = {...errors}..remove(field);
  }

  @override
  void clearErrors() {
    if (isValid) {
      return;
    }

    valueNotifier.value = {};
  }

  @override
  void addFieldError(K field, String error) {
    valueNotifier.value = {
      ...errors,
      field: error,
    };
  }

  @override
  void addErrors(Map<K, String> errors) => valueNotifier.value = errors;

  @override
  Future<void> validate() {
    return Future.wait(
      _connectors.map<Future<_ValidationResult<K>>>((connector) {
        return Future.microtask(() => _ValidationResult<K>(
          connector.field,
          connector.validate()
        ));
      }).toList()
    ).then((collection) {
      return collection.fold<Map<K, String>>({}, (value, result) {
        if (!result.hasError) {
          return value;
        }

        return {
          ...value,
          result.field: result.error,
        };
      });
    }).then(addErrors);
  }

  @override
  void dispose() {
    [..._connectors].forEach((validator) {
      validator.detach();
    });

    _connectors.clear();
    valueNotifier.dispose();
  }

  @override
  void addConnector(ValidationConnector<K, Object> connector) {
    _connectors.add(connector);
  }

  @override
  void removeConnector(ValidationConnector<K, Object> connector) {
    _connectors.remove(connector);
    clearFieldError(connector.field);
  }

  @override
  void attachConnectors(Iterable<ValidationConnector<K,Object>> connectors) {
    connectors.forEach((connector) {
      connector.attach(this);
    });
  }
}

class _ValidationResult<K> {
  final K field;
  final String error;

  _ValidationResult(this.field, this.error);

  bool get hasError => error != null;
}