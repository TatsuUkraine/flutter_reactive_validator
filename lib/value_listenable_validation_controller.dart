import 'package:flutter/foundation.dart';

import 'base_validation_controller.dart';
import 'contracts/errors_provider.dart';
import 'utils.dart';
import 'value_error_provider.dart';
import 'contracts/error_provider.dart';
import 'contracts/validation_connector.dart';
import 'contracts/listenable_validation_controller.dart';
import 'value_errors_provider.dart';

/// Validation controller that contains current state of validation.
///
/// Can be used to insert custom validation messages provided from API
/// or can be managed by [ValidationConnector]'s on data stream changes.
///
/// Works with [ValueNotifier] as a controller.
class ValueListenableValidationController<K> extends BaseValidationController<K>
    implements ListenableValidationController<K> {
  final ValueNotifier<Map<K, String>> _valueNotifier;

  ValueListenableValidationController({
    List<ValidationConnector<K, Object>> connectors = const [],
  })  : _valueNotifier = ValueNotifier<Map<K, String>>({}),
        super(connectors);

  ValueListenableValidationController.seeded(
    Map<K, String> errors, {
    List<ValidationConnector<K, Object>> connectors = const [],
  })  : _valueNotifier = ValueNotifier<Map<K, String>>(errors),
        super(connectors);

  @override
  ErrorProvider<K> fieldErrorProvider(K field) =>
      ValueErrorProvider<K>(field, errors[field]);

  @override
  ErrorsProvider<K> fieldsErrorProvider(Iterable<K> fields) =>
      ValueErrorsProvider<K>(fields, filterErrors(fields, errors));

  @override
  Map<K, String> get errors => _valueNotifier.value;

  @override
  ValueListenable<Map<K, String>> get errorsNotifier => _valueNotifier;

  @override
  bool get isValid => errors.isEmpty;

  @override
  void addErrors(Map<K, String> errors) => _valueNotifier.value = errors;

  @override
  void dispose() {
    _valueNotifier.dispose();
    super.dispose();
  }
}
