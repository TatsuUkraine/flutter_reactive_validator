import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reactive_validator/contracts/validation_connector.dart';
import 'package:reactive_validator/contracts/validation_controller.dart';
import 'package:reactive_validator/contracts/validator.dart';
import 'package:reactive_validator/stream_validation_connector.dart';

import 'stream_validation_connector_test.mocks.dart';

class MockedStream extends Mock implements Stream<String> {
  @override
  StreamSubscription<String> listen(void Function(String event)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return super.noSuchMethod(
      Invocation.method(#listen, [onData], {#onError: onError, #onDone: onDone, #cancelOnError: cancelOnError}),
      returnValue: MockStreamSubscription<String>(),
      returnValueForMissingStub: MockStreamSubscription<String>(),
    );
  }
}

//class MockedSubscription extends Mock implements StreamSubscription<String> {}

@GenerateMocks([ValidationController, Validator, StreamSubscription, StreamController])
void main() {
  test('should throw error on attach', () {
    final controller = MockValidationController<String>();
    final stream = MockedStream();

    final connector = StreamValidationConnector(
      field: 'field',
      validator: MockValidator<String>(),
      stream: stream,
    );

    connector.attach(controller);

    expect(() => connector.attach(controller), throwsUnsupportedError);
  });

  test('should attach controller', () {
    final controller = MockValidationController<String>();
    final validator = MockValidator<String>();
    final stream = MockedStream();

    final connector = StreamValidationConnector(
      field: 'field',
      validator: validator,
      stream: stream,
    );

    connector.attach(controller);

    verify(controller.addConnector(connector)).called(1);
    verify(stream.listen(argThat(anything))).called(1);
    verifyNever(validator.call(argThat(anything)));
  });

  test('should attach controller and validate', () {
    final controller = MockValidationController<String>();
    final stream = MockedStream();
    final validator = MockValidator<String>();

    when(validator.call(any)).thenAnswer((_) => null);

    final connector = StreamValidationConnector.seeded(
      field: 'field',
      validator: validator,
      stream: stream,
      validateOnAttach: true,
      initialValue: 'value',
    );

    connector.attach(controller);

    verify(controller.addConnector(connector)).called(1);
    verify(stream.listen(argThat(anything))).called(1);
    verify(validator.call('value')).called(1);
    verify(controller.clearFieldError('field')).called(1);
  });

  test('shouldn\'t validate if value is empty', () {
    final controller = MockValidationController<String>();
    final stream = MockedStream();
    final validator = MockValidator<String>();

    final connector = StreamValidationConnector(
      field: 'field',
      validator: validator,
      stream: stream,
      validateOnAttach: true,
    );

    connector.attach(controller);

    verify(controller.addConnector(connector)).called(1);
    verify(stream.listen(argThat(anything))).called(1);
    verifyNever(controller.clearFieldError(argThat(anything)));
    verifyNever(validator.call(argThat(anything)));
  });

  test('should throw error on detach', () {
    final stream = MockedStream();

    final connector = StreamValidationConnector(
      field: 'field',
      validator: MockValidator<String>(),
      stream: stream,
    );

    expect(() => connector.detach(), throwsUnsupportedError);
  });

  test('should detach', () {
    final controller = MockValidationController<String>();
    final stream = MockedStream();
    final subscription = MockStreamSubscription<String>();

    final connector = StreamValidationConnector(
      field: 'field',
      validator: MockValidator<String>(),
      stream: stream,
    );

    when(stream.listen(argThat(anything))).thenReturn(subscription);

    connector.attach(controller);
    connector.detach();

    verify(subscription.cancel()).called(1);
    verify(controller.removeConnector(connector)).called(1);
  });

  test('should clear on change', () {
    final controller = MockValidationController<String>();
    final stream = StreamController(sync: true);
    final validator = MockValidator<String>();

    final connector = StreamValidationConnector(
      field: 'field',
      validator: validator,
      stream: stream.stream,
      clearOnChange: true,
      validateOnChange: false,
    );

    connector.attach(controller);

    stream.sink.add('value');

    verify(controller.clearFieldError('field')).called(1);

    stream.close();
  });

  test('should validate on change', () {
    final controller = MockValidationController<String>();
    final stream = StreamController(sync: true);
    final validator = MockValidator<String>();

    final connector = StreamValidationConnector(
      field: 'field',
      validator: validator,
      stream: stream.stream,
      clearOnChange: false,
      validateOnChange: true,
    );

    connector.attach(controller);

    when(validator.call('value')).thenReturn(null);
    when(validator.call('value2')).thenReturn('Error validation');

    stream.sink.add('value');
    stream.sink.add('value2');

    verify(controller.clearFieldError('field')).called(1);
    verify(controller.addFieldError('field', 'Error validation')).called(1);

    stream.close();
  });

  test('should connect validator to the notifier', () {
    final controller = StreamController();
    final connector = controller.stream
        .connectValidator(field: 'field', validator: MockValidator<String>());

    expect(connector, isInstanceOf<ValidationConnector>());
    expect(connector.field, 'field');

    controller.close();
  });
}
