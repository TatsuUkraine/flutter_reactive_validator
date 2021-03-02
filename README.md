# Reactive Validator

[![pub package](https://img.shields.io/pub/v/reactive_validator.svg)](https://pub.dartlang.org/packages/reactive_validator)

Reactive Validator is a type safe validation manager package for Streams
and Value Notifiers.

It provides ability to define scoped validation rules for set of stream
or value listenable objects. Also it allows to manage error state
manually to collect validation response from the Server or any other
resource.

In addition to error management this package also provides set of
validators for some common validation cases. If need - any callable
validator instance can be used to validate target value.

## Table Of Contents

- [Getting Started](#getting-started)
- [Validation controller](#validation-controller)
  - [Invoke validation](#invoke-validation)
  - [StreamValidationController](#streamvalidationcontroller)
- [Validation connectors](#validation-connectors)
  - [ValueListenableValidationConnector](#valuelistenablevalidationconnector)
  - [StreamValidationConnector](#streamvalidationconnector)
    - [Stream validation specific](#stream-validation-specific)
  - [Create validation connector](#create-validation-connector)
- [Validators](#validators)
  - [Validation against multiple validators](#validation-against-multiple-validators)
  - [Custom validation](#custom-validation)
  - [Cross field validation](#cross-field-validation)
  - [External validator package usage](#external-validator-package-usage)

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

Define and attach validation connectors

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
).attach(controller);

/// or with extension method
someValueListenable.connectValidator(
  field: 'some_fifth_field', /// field name that will be used within the error bucket
  valueListenable: someValueListenable, /// your [ValueListenable] with field value
  validator: const NotEmptyStringValidator(),
).attach(controller);
```

When you're ready to validate, just validate it

```dart
controller.validate();
```

Or add error message manually

```dart
controller.addFieldError('field', 'error');
```

## Validation controller

Controller is a manager of your validation state.

Package provides controller based on `ValueNotifier` object and
controller based on `BehaviorSubject` stream controller.

Both gives you ability to get error messages or an `ErrorProvider` in a
sync way.

Also both give you a sync access to an error `Map` and validation
status.

Controller also gives you ability to add or remove any validation error
massage from the error bucket manually. It can be particularly useful if
you validated your values, submit data to the server (if it's valid) and
receive validation error, which you want to show to the user.

**Important** Don't forget to `dispose` your controller when you're
done.

### Invoke validation

To invoke validation against all attached connectors, just call
`validate` method. It resolves `Future` as soon as validation is
finished.

### StreamValidationController

`StreamValidationController`, which is implemented by the
`SubjectStreamValidationController` aside of default access methods
gives you access error streams. Like `isValidStream`, `errorsStream`,
`fieldErrorStream` etc.

Also, this implementation provides you extended `ErrorProvider` that
contains reference to the stream with a field error.

**Note** Since `SubjectStreamValidationController` uses
`BehaviorSubject` from the RxDart, `StreamErrorProvider` also ensures
that provided stream won't emit value as soon as anyone subscribes on
it.

## Validation connectors

Package provides 2 types of validation connectors. Both define
relationship between the value, that needs to be validated, and
validation rules.

Each of them start to track value changes as soon as it attached to the
controller.

Package allows to use both connector types within the same controller
instance, as long as they're using the same field type.

### ValueListenableValidationConnector

This validation connector is needed to attach validation rules to the
`ValueListenable` object.

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

To prevent the collision, connector can't invoke validation on change
and clear validation error on change. Which means that both
`validateOnChange` and `clearOnChange` can't be `true` in the same time

### StreamValidationConnector

This validation connector is needed to attach validation rules to the
Stream object.

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
clear validation error on change. Which means that both
`validateOnChange` and `clearOnChange` can't be `true` in the same time.

#### Stream validation specific

Take into account that this connector will validate value only after at
least one event was emitted in the `Stream`. If you want to validate
value even if no event was emitted, oyu need to use
`StreamValidationConnector.seeded` constructor. Or use stream from the
RxDart's `BehaviorSubject` controller, so event could be fired as soon
as connector subscribes to it during the attach.

### Create validation connector

Validation connector can be created in 2 ways. First one with just
constructor

```dart
final valueConnector = ValueListenableValidationConnector(...);
/// Or
final streamConnector = StreamValidationConnector(...);
```

And second one with extensions, that package provides

```dart
final valueConnector = valueListenable.connectValidator(...);
/// Or
final streamConnector = streamListenable.connectValidator(...);
```

## Validators

Each connector requires `validator` to be provided.

By default Validator is a callable instance, that returns error message
if provided value is not valid.

All build-in validators has 2 type of constructors.
- constructor with predefined error message with ability to override it
- constructor with fully custom error message

Some default validators can be found
[here](https://pub.dev/documentation/reactive_validator/latest/) .

### Validation against multiple validators

If more than one validator is required for your field, you can use
`AndValidator` or `OrValidator`.

Most commonly used is `AndValidator`, which ensures that value is
validated against all provided validators. It stops as soon as any child
validator returns error message.

Less commonly used is `OrValidator`. But it may be useful if you have
field that may have 2 valid states. For instance if you have not
required field, that can be empty string or `null` or, if provided,
contains not less than 6 symbols.

```dart
OrValidator([
  IsNullValidator(),
  EmptyStringValidator(),
  MinCharactersValidator(6),
])
```

Keep in mind that this validator will validate value against all child
validators, until any child validator says that value is valid. Which
means that validation error message (if the's any) will be returned from
the last not valid validator. So ensure that your primary validator is a
last one in the `OrValidator` group.

### Custom validation

If you need any custom validation or you want to use some external
package validators, you have 3 options:

1. Implement `Validator` interface

```dart
class SomeValidator<I> implements Validator<I> {
  String call(I value) {
    /// Your validation goes here.
    /// Ensure that this method returns error message if [value] is invalid.
    /// 
    /// If it returns [null] validation result will be treated as successful
  }
}
```

2. Extend from `FieldValidator`

```dart
class SomeValidator extends FieldValidator<String> {
  /// implement your constructor
  const SomeValidator({
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    message: errorMessage ?? 'value should be a valid',
  );

  @override
  bool isValid(value) {
    /// your validation goes here
  }
}
```

3. Use `CustomValidator`

```dart
  final validator = CustomValidator<String>(
    fieldName: 'Field name',
    message: (String value) {
      /// return error message
      /// 
      /// Callback will be invoked only when [isValid] returns false
    },
    isValid: (String value) {
      /// validate [value]
    },
    ignoreNullable: true, /// if nullable value should be treated as valid value
  );
  
  /// Or
  final validator = CustomValidator<String>.withMessage(
    message: (String value) {
      /// return error message
      /// 
      /// Callback will be invoked only when [isValid] returns false
    },
    isValid: (String value) {
      /// validate [value]
    },
    ignoreNullable: true, /// if nullable value should be treated as valid value
  );
```

With default `CustomValidator` constructor result error message will be
concatenation of the `fieldName` and the message from the `message`
callback.

`CustomValidator.withMessage` will use error message from the builder as
it is. So ensure that error message is returned, otherwise
`ValidationConnector` will think that validation was successful.

### Cross field validation

Most simple way to provide cross field validation is to use
`CustomValidator` to get value from another field when it's time to
validate target field. It may look something like this

```dart
  final connector = StreamValidationConnector<String, String>(
    field: 'password2',
    stream: stateStream.map((state) => state.password2),
    validator: CustomValidator<String>.withMessage(
      message: (_) => 'Password doesn\'t match',
      isValid: (String value) {
        return state.password == value;
      },
    ),
  );
```

Another possible solution could be is to validate value in the connected
stream with bool validator usage:

```dart
  final connector = StreamValidationConnector<String, String>(
    field: 'password2',
    stream: stateStream.map((state) => state.password == state.password2),
    validator: IsTrueValidator.withMessage('Password doesn\'t match'),
  );
```

### External validator package usage

If needed, this package can use any external validator packages. For
instance you can take a look at `EmailValidator`, which uses
[email_validator](https://pub.dev/packages/email_validator) package to
validate if value is a valid email value.

Or, if external package validators has right interface signature, you
can use them as they are.

## Tests

Before run tests, ensure to generate mocks for mockito

```
flutter pub run build_runner build
```

## Changelog

Please see the
[Changelog](https://github.com/TatsuUkraine/flutter_reactive_validator/blob/master/CHANGELOG.md)
page to know what's recently changed.

## Bugs/Requests

If you encounter any problems feel free to open an
[issue](https://github.com/TatsuUkraine/flutter_reactive_validator/issues).
If you feel the library is missing a feature, please raise a ticket on
Github and I'll look into it.

Pull requests with validators, bug fixes or improvements are also
welcome.
