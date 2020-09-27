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


