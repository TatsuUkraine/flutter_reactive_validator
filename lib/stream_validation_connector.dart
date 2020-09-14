import 'dart:async';

import 'package:flutter/foundation.dart';

import 'contracts/validation_connector.dart';
import 'contracts/validation_controller.dart';
import 'contracts/validator.dart';

/// Validation Connector, that subscribes on provided [Stream]
///
/// Allows to invoke validation on stream value change or clear validation errors
/// as soon as value in stream changes.
///
/// Requires to be attached to the controller.
///
/// As soon as it attaches to controller, it starts listen provided stream.
class StreamValidationConnector<K, I> implements ValidationConnector<K, I> {

  @override
  final K field;

  /// [Stream] with value that should be validated
  final Stream<I> stream;

  /// [Validator] for defined stream
  final Validator<I> validator;

  /// Defines if validation should be invoked on [Stream] change
  ///
  /// Only one [clearOnChange] or [validateOnChange] can't be enabled to
  /// avoid validation override
  final bool validateOnChange;

  /// Defines if error message should be removed when [Stream] even is emitted.
  ///
  /// Only one [clearOnChange] or [validateOnChange] can't be enabled to
  /// avoid validation override
  final bool clearOnChange;

  StreamSubscription<I> _subscription;
  ValidationController<K> _controller;

  I _lastValue;
  bool _hasValue = false;

  /// Creates default connector
  StreamValidationConnector({
    @required this.field,
    @required this.stream,
    @required this.validator,
    this.validateOnChange = false,
    this.clearOnChange = true,
  })  : assert(!clearOnChange || !validateOnChange),
        _lastValue = null,
        _hasValue = false;

  /// Creates connector with seeded data
  StreamValidationConnector.seeded({
    @required this.field,
    @required this.stream,
    @required this.validator,
    I initialValue,
    this.validateOnChange,
    this.clearOnChange,
  })  : assert(!clearOnChange || !validateOnChange),
        _lastValue = initialValue,
        _hasValue = true;

  @override
  void attach(ValidationController<K> controller) {
    if (_controller != null) {
      throw UnsupportedError('Validator can be attached to only single controller');
    }

    _controller = controller;
    _controller.addConnector(this);
    _subscription = stream.listen(_onValueChanged);
  }

  @override
  void detach() {
    _subscription?.cancel();
    _controller?.removeConnector(this);

    _subscription = null;
    _controller = null;
  }

  @override
  String validate() {
    if (!_hasValue) {
      return null;
    }

    return validator(_lastValue);
  }

  void _onValueChanged(I value) {
    _hasValue = true;
    _lastValue = value;

    if (clearOnChange) {
      _controller.clearFieldError(field);
    }

    if (!validateOnChange) {
      return;
    }

    final String error = validate();
    if (error == null) {
      return _controller.clearFieldError(field);
    }

    _controller.addFieldError(field, error);
  }
}