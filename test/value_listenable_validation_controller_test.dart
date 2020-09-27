import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reactive_validator/contracts/error_provider.dart';
import 'package:reactive_validator/contracts/validation_connector.dart';
import 'package:reactive_validator/value_listenable_validation_controller.dart';

class MockedConnector extends Mock
    implements ValidationConnector<String, String> {}

void main() {
  test('should create empty validation controller', () {
    final controller = ValueListenableValidationController<String>();

    expect(controller.errors, {});
    expect(controller.isValid, isTrue);

    controller.dispose();
  });

  test('should create seeded validation controller', () {
    final controller =
        ValueListenableValidationController<String>.seeded({'field': 'value'});

    expect(controller.errors, {
      'field': 'value',
    });
    expect(controller.isValid, isFalse);

    controller.dispose();
  });

  test('should return error provider', () {
    final controller =
        ValueListenableValidationController<String>.seeded({'field': 'value'});
    final provider = controller.fieldErrorProvider('field');

    expect(provider, isInstanceOf<ErrorProvider<String>>());
    expect(provider.field, 'field');
    expect(provider.value, 'value');
    expect(provider.hasError, isTrue);

    controller.dispose();
  });

  test('should update error map', () {
    final controller = ValueListenableValidationController<String>();

    expect(controller.errors, {});
    expect(controller.isValid, isTrue);

    controller.addErrors({
      'field': 'value',
    });

    expect(controller.errors, {
      'field': 'value',
    });
    expect(controller.isValid, isFalse);

    controller.dispose();
  });

  test('should add field error message', () {
    final controller = ValueListenableValidationController<String>();

    controller.addFieldError('field', 'error');
    expect(controller.errors, {
      'field': 'error',
    });
    expect(controller.isValid, isFalse);

    controller.dispose();
  });

  test('should clear field error message', () {
    final controller = ValueListenableValidationController<String>.seeded({
      'field': 'error',
    });

    expect(controller.errors, {
      'field': 'error',
    });
    expect(controller.isValid, isFalse);

    controller.clearFieldError('field');

    expect(controller.errors, {});
    expect(controller.isValid, isTrue);

    controller.dispose();
  });

  test('should clear all error messages', () {
    final controller = ValueListenableValidationController<String>.seeded({
      'field1': 'error1',
      'field2': 'error2',
    });

    expect(controller.isValid, isFalse);

    controller.clearErrors();

    expect(controller.errors, {});
    expect(controller.isValid, isTrue);

    controller.dispose();
  });

  test('should remove connector and clear error field', () {
    final controller = ValueListenableValidationController<String>();
    final connector = MockedConnector();

    controller.addConnector(connector);

    when(connector.field).thenReturn('field');

    controller.addFieldError('field', 'error');

    expect(controller.isValid, isFalse);
    controller.removeConnector(connector);

    expect(controller.isValid, isTrue);

    controller.dispose();
  });

  test('should validate across all connectors', () async {
    final controller = ValueListenableValidationController<String>();
    final connector = MockedConnector();

    controller.addConnector(connector);

    when(connector.field).thenReturn('field');
    when(connector.validate()).thenReturn('error');

    expect(controller.isValid, isTrue);

    await controller.validate();

    expect(controller.errors, {
      'field': 'error',
    });
    expect(controller.isValid, isFalse);

    controller.dispose();
  });

  test('should attach connectors on create', () {
    final connector = MockedConnector();
    final controller = ValueListenableValidationController<String>(
      connectors: [
        connector,
      ],
    );

    verify(connector.attach(controller)).called(1);
  });

  test('should attach connectors on seeded controller create', () {
    final connector = MockedConnector();
    final controller = ValueListenableValidationController<String>.seeded(
      {},
      connectors: [
        connector,
      ],
    );

    verify(connector.attach(controller)).called(1);
  });

  test('should attach connectors', () {
    final connector = MockedConnector();
    final controller = ValueListenableValidationController<String>();

    controller.attachConnectors([connector]);

    verify(connector.attach(controller)).called(1);
  });
}
