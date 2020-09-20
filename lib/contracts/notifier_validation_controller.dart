import 'package:flutter/foundation.dart';

import 'validation_controller.dart';

abstract class NotifierValidationController<K> extends ValidationController<K> {

  /// [ValueNotifier] with all validation error messages.
  ValueNotifier<Map<K, String>> get errorsNotifier;
}