import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reactive_validator/contracts/validation_connector.dart';
import 'package:reactive_validator/contracts/validation_controller.dart';
import 'package:reactive_validator/contracts/validator.dart';
import 'package:reactive_validator/value_listenable_validation_connector.dart';

import 'value_listenable_validation_connector_test.mocks.dart';

@GenerateMocks([ValueListenable, ValidationController, Validator])
void main() {
  test('should throw error on attach', () {
    final controller = MockValidationController<String>();

    final connector = ValueListenableValidationConnector(
      field: 'field',
      validator: MockValidator(),
      valueListenable: MockValueListenable(),
    );

    connector.attach(controller);

    expect(() => connector.attach(controller), throwsUnsupportedError);
  });

  test('should attach controller', () {
    final controller = MockValidationController<String>();
    final listenable = MockValueListenable();
    final validator = MockValidator();

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
    final controller = MockValidationController<String>();
    final listenable = MockValueListenable();
    final validator = MockValidator<String>();

    when(validator.call(any)).thenReturn(null);

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
      validator: MockValidator(),
      valueListenable: MockValueListenable(),
    );

    expect(() => connector.detach(), throwsUnsupportedError);
  });

  test('should detach', () {
    final controller = MockValidationController<String>();
    final listenable = MockValueListenable();

    final connector = ValueListenableValidationConnector(
      field: 'field',
      validator: MockValidator(),
      valueListenable: listenable,
    );

    connector.attach(controller);
    connector.detach();

    verify(listenable.removeListener(argThat(anything))).called(1);
    verify(controller.removeConnector(connector)).called(1);
  });

  test('should clear on change', () {
    final controller = MockValidationController<String>();
    final listenable = ValueNotifier('');
    final validator = MockValidator();

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
    final controller = MockValidationController<String>();
    final listenable = ValueNotifier('');
    final validator = MockValidator();

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

  test('should connect validator to the notifier', () {
    final notifier = ValueNotifier('');
    final connector =
        notifier.connectValidator(field: 'field', validator: MockValidator());

    expect(connector, isInstanceOf<ValidationConnector>());
    expect(connector.field, 'field');
  });
}
