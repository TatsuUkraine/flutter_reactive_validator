import 'package:rxdart/rxdart.dart';

import 'base_validation_controller.dart';
import 'contracts/stream_error_provider.dart';
import 'contracts/stream_validation_controller.dart';
import 'contracts/validation_connector.dart';
import 'mapped_stream_error_provider.dart';



/// Validation controller that contains current state of validation.
///
/// Can be used to insert custom validation messages provided from API
/// or can be managed by [ValidationConnector]'s on data stream changes.
///
/// Works with [BehaviorSubject] stream controller.
///
/// Which means that all streams, that provided by this controller, will emit last value
/// to the listeners as soon as they subscribe.
class SubjectStreamValidationController<K>
    extends BaseValidationController<K>
    implements StreamValidationController<K> {

  final BehaviorSubject<Map<K, String>> _streamController;

  SubjectStreamValidationController({bool sync: false})
      : _streamController = BehaviorSubject<Map<K, String>>(sync: sync);

  SubjectStreamValidationController.seeded(Map<K, String> errors, {bool sync: false})
      : _streamController = BehaviorSubject<Map<K, String>>.seeded(errors, sync: sync);

  @override
  StreamErrorProvider<K> fieldErrorProvider(K field) =>
      MappedStreamErrorProvider<K>(field, _streamController.stream);

  @override
  Stream<String> fieldErrorStream(K field) => errorsStream
      .map((errors) => errors[field]);

  @override
  Stream<Map<K, String>> get errorsStream => _streamController.stream;

  @override
  Map<K, String> get errors => _streamController.value ?? {};
  
  @override
  Stream<bool> get isValidStream => errorsStream.map((errors) => errors.isEmpty);

  @override
  void addErrors(Map<K, String> errors) => _streamController.sink.add(errors);

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}