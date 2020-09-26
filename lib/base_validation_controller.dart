import 'package:reactive_validator/reactive_validator.dart';

abstract class BaseValidationController<K> implements ValidationController<K> {
  List<ValidationConnector<K,Object>> _connectors = [];

  @override
  String fieldError(K field) => errors[field];

  @override
  bool get isValid => errors.isEmpty;

  @override
  void clearFieldError(K field) {
    if (!errors.containsKey(field)) {
      return;
    }

    addErrors(
      {...errors}..remove(field)
    );
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
  void attachConnectors(Iterable<ValidationConnector<K, Object>> connectors) {
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