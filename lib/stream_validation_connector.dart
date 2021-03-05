import 'dart:async';

import 'base_validation_connector.dart';
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
class StreamValidationConnector<K, I> extends BaseValidationConnector<K, I>
    implements ValidationConnector<K, I> {
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

  /// If value should be validated on connector attach
  ///
  /// Validation will be invoke only if connector already
  /// have last emitted value.
  ///
  /// If default [StreamValidationConnector] constructor is used,
  /// validation will be invoked only after second attach.
  ///
  /// So if you need to validate [Stream] value on first attach, use
  /// [StreamValidationConnector.seeded] constructor
  final bool validateOnAttach;

  StreamSubscription<I>? _subscription;

  I? _lastValue;
  bool _hasValue = false;

  /// Creates default connector
  StreamValidationConnector({
    required K field,
    required this.stream,
    required this.validator,
    this.validateOnChange = false,
    this.clearOnChange = true,
    this.validateOnAttach = false,
  })  : assert(!clearOnChange || !validateOnChange),
        _lastValue = null,
        _hasValue = false,
        super(field);

  /// Creates connector with seeded data
  StreamValidationConnector.seeded({
    required K field,
    required this.stream,
    required this.validator,
    required I initialValue,
    this.validateOnChange = false,
    this.clearOnChange = true,
    this.validateOnAttach = false,
  })  : assert(!clearOnChange || !validateOnChange),
        _lastValue = initialValue,
        _hasValue = true,
        super(field);

  @override
  void attach(ValidationController<K> controller) {
    super.attach(controller);

    _subscription = stream.listen(_onValueChanged);

    if (validateOnAttach) {
      validateField();
    }
  }

  @override
  void detach() {
    super.detach();

    _subscription?.cancel();
    _subscription = null;
  }

  @override
  String? validate() {
    if (!_hasValue) {
      return null;
    }

    return validator(_lastValue);
  }

  @override
  void validateField() {
    if (!_hasValue) {
      return;
    }

    super.validateField();
  }

  void _onValueChanged(I value) {
    _hasValue = true;
    _lastValue = value;

    if (clearOnChange) {
      controller!.clearFieldError(field);
    }

    if (!validateOnChange) {
      return;
    }

    validateField();
  }
}

/// Extension to create [ValidationConnector] from a [Stream] object
extension StreamConnectorExtention<K, I> on Stream<I> {
  /// Connect validator to the [Stream] object
  ValidationConnector<K, I> connectValidator({
    required K field,
    required Validator<I> validator,
    bool clearOnChange = true,
    bool validateOnChange = false,
    bool validateOnAttach = false,
  }) =>
      StreamValidationConnector<K, I>(
        field: field,
        stream: this,
        validator: validator,
        clearOnChange: clearOnChange,
        validateOnChange: validateOnChange,
        validateOnAttach: validateOnAttach,
      );
}
