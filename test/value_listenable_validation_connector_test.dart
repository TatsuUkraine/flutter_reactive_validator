import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_validator/contracts/validator.dart';
import 'package:stream_validator/stream_validator.dart';
import 'package:stream_validator/value_listenable_validation_connector.dart';

class MockedValidator extends Mock implements Validator<String> {}
class MockedController extends Mock implements ValidationController<String> {}
class MockedListenable extends Mock implements ValueListenable<String> {}

void main() {
  test('should throw error on attach', () {
    final controller = ValueListenableValidationController<String>();

    final connector = ValueListenableValidationConnector(
      field: 'field',
      validator: MockedValidator(),
      valueListenable: MockedListenable(),
    );

    connector.attach(controller);

    expect(() => connector.attach(controller), throwsUnsupportedError);
  });

  test('should attach controller', () {
    final controller = MockedController();
    final listenable = MockedListenable();
    final validator = MockedValidator();

    final connector = ValueListenableValidationConnector(
      field: 'field',
      validator: validator,
      valueListenable: listenable,
    );

    connector.attach(controller);

    verify(controller.addConnector(connector)).called(1);
    verify(listenable.addListener(argThat(anything))).called(1);
    verifyNever(validator.call(argThat(anything)));
  });

  test('should attach controller and validate', () {
    final controller = MockedController();
    final listenable = MockedListenable();
    final validator = MockedValidator();

    final connector = ValueListenableValidationConnector(
      field: 'field',
      validator: validator,
      valueListenable: listenable,
      validateOnAttach: true,
    );

    when(listenable.value).thenReturn('value');

    connector.attach(controller);

    verify(controller.addConnector(connector)).called(1);
    verify(listenable.addListener(argThat(anything))).called(1);
    verify(validator.call('value')).called(1);
    verify(controller.clearFieldError('field')).called(1);
  });

  test('should throw error on detach', () {
    final connector = ValueListenableValidationConnector(
      field: 'field',
      validator: MockedValidator(),
      valueListenable: MockedListenable(),
    );

    expect(() => connector.detach(), throwsUnsupportedError);
  });

  test('should detach', () {
    final controller = ValueListenableValidationController<String>();
    final listenable = MockedListenable();

    final connector = ValueListenableValidationConnector(
      field: 'field',
      validator: MockedValidator(),
      valueListenable: listenable,
    );

    connector.attach(controller);
    connector.detach();

    verify(listenable.removeListener(argThat(anything))).called(1);
  });

  test('should clear on change', () {
    final controller = MockedController();
    final listenable = ValueNotifier('');
    final validator = MockedValidator();

    final connector = ValueListenableValidationConnector(
      field: 'field',
      validator: validator,
      valueListenable: listenable,
      clearOnChange: true,
      validateOnChange: false,
    );

    connector.attach(controller);

    listenable.value = 'value';

    verify(controller.clearFieldError('field')).called(1);
  });

  test('should validate on change', () {
    final controller = MockedController();
    final listenable = ValueNotifier('');
    final validator = MockedValidator();

    final connector = ValueListenableValidationConnector(
      field: 'field',
      validator: validator,
      valueListenable: listenable,
      clearOnChange: false,
      validateOnChange: true,
    );

    connector.attach(controller);

    when(validator.call('value')).thenReturn(null);
    when(validator.call('value2')).thenReturn('Error validation');

    listenable.value = 'value';
    listenable.value = 'value2';

    verify(controller.clearFieldError('field')).called(1);
    verify(controller.addFieldError('field', 'Error validation')).called(1);
  });
}