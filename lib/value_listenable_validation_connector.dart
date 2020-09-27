import 'package:flutter/foundation.dart';

import 'base_validation_connector.dart';
import 'contracts/validation_connector.dart';
import 'contracts/validation_controller.dart';
import 'contracts/validator.dart';

/// Validation Connector, that subscribes on provided [ValueListenable]
///
/// Allows to invoke validation on value change or clear validation errors
/// as soon as value is changes.
///
/// Requires to be attached to the controller.
///
/// As soon as it attaches to controller, it starts listen provided [ValueListenable].
class ValueListenableValidationConnector<K, I>
    extends BaseValidationConnector<K, I> implements ValidationConnector<K, I> {
  /// [ValueListenable] with value that should be validated
  final ValueListenable<I> valueListenable;

  /// [Validator] for defined stream
  final Validator<I> validator;

  /// Defines if validation should be invoked on [ValueListenable] change
  ///
  /// Only one [clearOnChange] or [validateOnChange] can't be enabled to
  /// avoid validation override
  final bool validateOnChange;

  /// Defines if error message should be removed when [ValueListenable] even is emitted.
  ///
  /// Only one [clearOnChange] or [validateOnChange] can't be enabled to
  /// avoid validation override
  final bool clearOnChange;

  /// If value should be validated on connector attached to the controller
  final bool validateOnAttach;

  /// Creates default connector
  ValueListenableValidationConnector({
    @required K field,
    @required this.valueListenable,
    @required this.validator,
    this.validateOnChange = false,
    this.clearOnChange = true,
    this.validateOnAttach = false,
  })  : assert(!clearOnChange || !validateOnChange),
        super(field);

  @override
  void attach(ValidationController<K> controller) {
    super.attach(controller);

    valueListenable.addListener(_onValueChanged);

    if (validateOnAttach) {
      validateField();
    }
  }

  @override
  void detach() {
    super.detach();

    valueListenable.removeListener(_onValueChanged);
  }

  @override
  String validate() => validator(valueListenable.value);

  void _onValueChanged() {
    if (clearOnChange) {
      controller.clearFieldError(field);
    }

    if (!validateOnChange) {
      return;
    }

    validateField();
  }
}

/// Extension to create [ValidationConnector] from a [ValueListenable] object
extension ValueListenableConnectorExtention<K, I> on ValueListenable<I> {
  /// Connect validator to the [ValueListenable] object
  ValidationConnector<K, I> connectValidator({
    @required K field,
    @required Validator<I> validator,
    bool clearOnChange = true,
    bool validateOnChange = false,
    bool validateOnAttach = false,
  }) =>
      ValueListenableValidationConnector<K, I>(
        field: field,
        valueListenable: this,
        validator: validator,
        clearOnChange: clearOnChange,
        validateOnChange: validateOnChange,
        validateOnAttach: validateOnAttach,
      );
}
