# Reactive Validator

Reactive Validator is a type safe validation manager package for Streams
and Value Notifiers.

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

## Validation controller

Controller is a manager of your validation state.

Package provides controller based on `ValueNotifier` object and
controller based on `BehaviorSubject` stream controller.

Both gives you ability to get error messages or `ErrorProvider` in a
sync way.

Also they're gives you sync access to the all errors `Map` and
validation status.

Controller also gives you ability to add or remove any validation error
massage from the error bucket. It can be particularly useful if you
validate your values, submit data to the server (if it's valid) and
receive validation error, which you want to show to the user.

**Important** Don't forget to `dispose` your controller when you no need
it anymore.

### Invoke validation

To invoke validation against all attached connectors, just call
`validate` method. It returns `Future` as soon as validation is
finished.

### StreamValidationController

`StreamValidationController`, which is implemented by
`SubjectStreamValidationController` aside of default access methods,
also gives you access error streams. Like `isValidStream`,
`errorsStream`, `fieldErrorStream` etc.

Also, this implementation provides you extended `ErrorProvider` that
contains reference to the stream with field error.

**Note** Since `SubjectStreamValidationController` uses
`BehaviorSubject` from the RxDart, `StreamErrorProvider` also ensures
that provided stream won't emit value as soon as anyone subscribes on
it.

## Validation connectors

Package provides 2 types of validation connectors. Both define relation
between value that needs to be validated and validation rules.

Each of them starts to track value changes as soon as it attached to the
controller.

Package allows to use both connector types within the same controller
instance as long as they using the same field type.

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
clear validation error on change. Which means that both `validateOnChange`
and `clearOnChange` can't be `true` in the same time

### StreamValidationConnector

This validation connector is needed to attach validation rules to a
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
clear validation error on change. Which means that both `validateOnChange`
and `clearOnChange` can't be `true` in the same time.

## Validators

Each connector requires `validator` to be provided.

By default Validator is a callable instance, that returns error message
when it's invoked with value.

All build in validators has 2 type of constructors.
- constructor with predefined error message with ability to override it
- constructor with fully custom error message

Some default validators can be found here.

### Validation against multiple validators

If more than one validator is required for your field, you can use
`AndValidator` or `OrValidator`.

Most commonly used is `AndValidator`, which ensures that value is
validated against all provided validators. It stops as soon as any child
validator returns error message.

Less commonly used is `OrValidator`. But it's useful if you have field
that may have 2 valid states. For instance if you have not required
field, that can be empty string or `null` or, if provided, contains not
less than 6 symbols.

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
package validators, you have 2 options.

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
    /// you validation goes here
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

First constructor will concat `fieldName` and message from the `message`
callback.

Second one - will use error message from the builder as it is. So ensure
that error message is returned, otherwise `ValidationConnector` will
think that validation is valid

### External validator package usage

If needed, this package can use any external validator packages. For
instance you can take a look at `EmailValidator`, which uses
[email_validator](https://pub.dev/packages/email_validator) package to
validate if value is a valid email value.

## Changelog

Please see the
[Changelog](https://github.com/TatsuUkraine/flutter_reactive_validator/blob/master/CHANGELOG.md)
page to know what's recently changed.

## Bugs/Requests

If you encounter any problems feel free to open an
[issue](https://github.com/TatsuUkraine/flutter_reactive_validator/issues).
If you feel the library is missing a feature, please raise a ticket on
Github and I'll look into it.

Pull request are also welcome.
