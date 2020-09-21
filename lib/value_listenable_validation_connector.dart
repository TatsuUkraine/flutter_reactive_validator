import 'package:flutter/foundation.dart';

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
class ValueListenableValidationConnector<K, I> implements ValidationConnector<K, I> {

  @override
  final K field;

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

  ValidationController<K> _controller;

  /// Creates default connector
  ValueListenableValidationConnector({
    @required this.field,
    @required this.valueListenable,
    @required this.validator,
    this.validateOnChange = false,
    this.clearOnChange = true,
    this.validateOnAttach = false,
  })  : assert(!clearOnChange || !validateOnChange);

  @override
  void attach(ValidationController<K> controller) {
    if (_controller != null) {
      throw UnsupportedError('Validator can be attached to only single controller');
    }

    _controller = controller;
    _controller.addConnector(this);
    valueListenable.addListener(_onValueChanged);

    if (validateOnAttach) {
      _validateValue();
    }
  }

  @override
  void detach() {
    valueListenable.removeListener(_onValueChanged);
    _controller?.removeConnector(this);

    _controller = null;
  }

  @override
  String validate() => validator(valueListenable.value);

  void _onValueChanged() {
    if (clearOnChange) {
      _controller.clearFieldError(field);
    }

    if (!validateOnChange) {
      return;
    }

    _validateValue();
  }

  void _validateValue() {
    final String error = validate();
    if (error == null) {
      return _controller.clearFieldError(field);
    }

    _controller.addFieldError(field, error);
  }
}

extension ValueListenableConnectorExtention<K,I> on ValueListenable<I> {
  /// Connect validator to the [ValueListenable] object
  ValidationConnector<K,I> connectValidator({
    @required K field,
    @required Validator<I> validator,
    bool clearOnChange = true,
    bool validateOnChange = false,
    bool validateOnAttach = false,
  }) => ValueListenableValidationConnector<K,I>(
    field: field,
    valueListenable: this,
    validator: validator,
    clearOnChange: clearOnChange,
    validateOnChange: validateOnChange,
    validateOnAttach: validateOnAttach,
  );
}