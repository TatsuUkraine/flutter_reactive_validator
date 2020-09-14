import 'package:rxdart/rxdart.dart';
import 'package:stream_validator/contracts/error_provider.dart';
import 'package:stream_validator/mapped_value_error_provider.dart';

import 'contracts/validation_connector.dart';
import 'contracts/validation_controller.dart';



/// Validation controller that contains current state of validation.
///
/// Can be used to insert custom validation messages provided from API
/// or can be managed by [ValidationConnector]'s on data stream changes.
///
/// Works with [BehaviorSubject] stream controller.
///
/// Which means that all streams, that provided by this controller, will emit last value
/// to the listeners as soon as they subscribe.
class SubjectStreamValidationController<K> implements ValidationController<K> {
  final BehaviorSubject<Map<K, String>> streamController;

  List<ValidationConnector<K,Object>> _connectors = [];

  SubjectStreamValidationController()
      : streamController = BehaviorSubject<Map<K, String>>();

  SubjectStreamValidationController.seeded(Map<K, String> errors)
      : streamController = BehaviorSubject<Map<K, String>>.seeded(errors);

  @override
  ErrorProvider<K> fieldErrorProvider(K field) =>
      MappedValueErrorProvider<K>(field, streamController.stream);

  @override
  Stream<String> fieldErrorStream(K field) => errorsStream
      .map((errors) => errors[field]);

  @override
  String fieldError(K field) => errors[field];
  
  @override
  Stream<Map<K, String>> get errorsStream => streamController.stream;

  @override
  Map<K, String> get errors => streamController.value ?? {};

  @override
  bool get isValid => errors.isEmpty;
  
  @override
  Stream<bool> get isValidStream => errorsStream.map((errors) => errors.isEmpty);

  @override
  void clearFieldError(K field) {
    if (!errors.containsKey(field)) {
      return;
    }

    streamController.sink.add(
      {...errors}..remove(field)
    );
  }

  @override
  void clearErrors() {
    if (isValid) {
      return;
    }

    streamController.sink.add({});
  }

  @override
  void addFieldError(K field, String error) {
    streamController.sink.add({
      ...errors,
      field: error,
    });
  }

  @override
  void addErrors(Map<K, String> errors) => streamController.sink.add(errors);

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
    streamController.close();
  }

  @override
  void addConnector(ValidationConnector<K, Object> connector) {
    _connectors.add(connector);
  }

  @override
  void removeConnector(ValidationConnector<K, Object> connector) {
    _connectors.remove(connector);
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