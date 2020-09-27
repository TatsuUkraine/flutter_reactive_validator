# Reactive Validator

Reactive Validator is a validation manager package for Streams and Value
Notifiers.

It provides ability to define scoped validation rules for set of stream
or value listenable objects. Also it allows to manage error state
manually to render validation response from the Server or any other
resource.

In addition to error management this package also provides sett of
validators for some common validation cases. If need - any callable
validator instance can be used to validate target value

## Getting Started

Install and import package

```dart
import 'package:reactive_validator/reactive_validator.dart';
```

Create controller instance

```dart
/// For controller with stream
StreamValidationController<String> controller = SubjectStreamValidationController<String>();

/// OR for controller with [ValueNotifier]
ListenableValidationController<String> controller = ValueListenableValidationController<String>();
```

Define and attach value for notification

```dart
/// Connectors can be attached or with controller constructor, or with
/// [attachConnectors] method
controller.attachConnectors([
  StreamValidationConnector<String, String>(
    field: 'some_field', /// field name that will be used within the error bucket
    stream: someValueStream.distinct(), /// your [Stream] with field value
    validator: const EmailValidator(),
  ),
  ValueListenableValidationConnector<String, String>(
    field: 'some_other_field', /// field name that will be used within the error bucket
    valueListenable: someValueListenable, /// your [ValueListenable] with field value
    validator: const NotEmptyStringValidator(),
  )
]);

/// or with [attach] method
ValueListenableValidationConnector<String, String>(
  field: 'some_third_field', /// field name that will be used within the error bucket
  valueListenable: someValueListenable, /// your [ValueListenable] with field value
  validator: const NotEmptyStringValidator(),
)..attach(controller);
```

When you're ready to validate, just validate it

```dart
controller.validate();
```

Or add error message manually

```dart
controller.addFieldError('field', 'error');
```

## Validation connectors

Package provides 2 types of validation connectors to provide relation
between value that needs to be validated and validation rules.

Each of them starts track value changes as soon as it attached to the
controller.

### ValueListenableValidationConnector

This validation connector is needed to attach validation rules to
ValueListenable object.

```dart
  ValueListenableValidationConnector<K,V>({
    K field, /// required, field name
    ValueListenable<V> valueListenable, /// required, value provider
    Validator<V> validator, /// required, validation rules that needs to be applied
    bool validateOnChange = false, /// if value should be validated as soon as it changes
    bool clearOnChange = true, /// if validation error should be cleared as soon as value changes
    bool validateOnAttach = false, /// if value should be validated as soon as connector attached to the controller
  });
```

To prevent collision, connector can't invoke validation on change and
clear validation error on change. Which means that `validateOnChange`
and `clearOnChange` can't be both `true` in the same time

### StreamValidationConnector

This validation connector is needed to attach validation rules to Stream
object.

```dart
  StreamValidationConnector<K,V>({
    K field, /// required, field name
    Stream<V> stream, /// required, value provider
    Validator<V> validator, /// required, validation rules that needs to be applied
    bool validateOnChange = false, /// if value should be validated as soon as it changes
    bool clearOnChange = true, /// if validation error should be cleared as soon as value changes
    bool validateOnAttach = false, /// if value should be validated as soon as connector attached to the controller
  });

  StreamValidationConnector<K,V>.seeded({
    V initialValue, /// required, initial value
    K field, /// required, field name
    Stream<V> stream, /// required, value provider
    Validator<V> validator, /// required, validation rules that needs to be applied
    bool validateOnChange = false, /// if value should be validated as soon as it changes
    bool clearOnChange = true, /// if validation error should be cleared as soon as value changes
    bool validateOnAttach = false, /// if value should be validated as soon as connector attached to the controller
  });
```

To prevent collision, connector can't invoke validation on change and
clear validation error on change. Which means that `validateOnChange`
and `clearOnChange` can't be both `true` in the same time.
