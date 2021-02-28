import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reactive_validator/reactive_validator.dart';

class ValidationPage extends StatefulWidget {
  @override
  _ValidationPageState createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  final StreamValidationController<_Fields> _controller =
      SubjectStreamValidationController<_Fields>();
  final StreamController<RegisterState> _stateController =
      StreamController.broadcast();

  late StreamSubscription<RegisterState> _subscription;
  RegisterState? _lastValue;

  @override
  void initState() {
    _subscription = _stateController.stream.listen((event) {
      _lastValue = event;
    });

    final now = DateTime.now();

    _controller.attachConnectors([
      StreamValidationConnector<_Fields, String?>(
        field: _Fields.EMAIL,
        stream: _stateController.stream.map((state) => state.email).distinct(),
        validator: const AndValidator(const [
          const IsNotNullValidator(),
          const NotEmptyStringValidator(),
          const EmailValidator(),
        ]),
      ),
      StreamValidationConnector<_Fields, String?>(
        field: _Fields.PASSWORD,
        stream:
            _stateController.stream.map((state) => state.password).distinct(),
        validator: const AndValidator(const [
          const IsNotNullValidator(),
          const NotEmptyStringValidator(),
          const MinCharactersValidator(6),
        ]),
      ),
      StreamValidationConnector<_Fields, DateTime?>(
        field: _Fields.BIRTHDAY,
        stream:
            _stateController.stream.map((state) => state.birthday).distinct(),
        validator: AndValidator([
          const IsNotNullValidator(),
          BeforeDateTimeValidator.withMessage(
              DateTime(now.year, now.month, now.day), 'Date should be in past'),
        ]),
      ),
    ]);

    _stateController.add(RegisterState());

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Validation'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<String?>(
                  stream: _controller.fieldErrorStream(_Fields.EMAIL),
                  builder: (context, snapshot) => TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: snapshot.data,
                    ),
                    onChanged: (value) {
                      _stateController.add(_lastValue!.copyWith(
                        email: value,
                      ));
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<String?>(
                  stream: _controller.fieldErrorStream(_Fields.PASSWORD),
                  builder: (context, snapshot) => TextField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: snapshot.data,
                    ),
                    onChanged: (value) {
                      _stateController.add(_lastValue!.copyWith(
                        password: value,
                      ));
                    },
                  ),
                ),
              ),
              StreamBuilder<String?>(
                stream: _controller.fieldErrorStream(_Fields.BIRTHDAY),
                builder: (context, snapshot) => Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            errorText: snapshot.data,
                          ),
                          child: Text(_lastValue?.birthday?.toString() ??
                              'No date selected'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          icon: Icon(Icons.event),
                          onPressed: () async {
                            final dateTime = await showDatePicker(
                              context: context,
                              initialDate:
                                  _lastValue?.birthday ?? DateTime.now(),
                              firstDate: DateTime(DateTime.now().year - 2),
                              lastDate: DateTime(DateTime.now().year + 2),
                            );

                            if (dateTime == null) {
                              return;
                            }

                            _stateController.add(_lastValue!.copyWith(
                              birthday: dateTime,
                            ));
                          }),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                child: Text('Validate'),
                onPressed: () {
                  _controller.validate();
                }),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    _subscription.cancel();
    _controller.dispose();
    _stateController.close();

    super.dispose();
  }
}

enum _Fields {
  EMAIL,
  PASSWORD,
  BIRTHDAY,
}

class RegisterState {
  final String? email;
  final String? password;
  final DateTime? birthday;

  RegisterState({this.email, this.password, this.birthday});

  RegisterState copyWith({
    String? email,
    String? password,
    DateTime? birthday,
  }) =>
      RegisterState(
        email: email ?? this.email,
        password: password ?? this.password,
        birthday: birthday ?? this.birthday,
      );
}
