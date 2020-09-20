import 'package:flutter/foundation.dart';

import 'field_validator.dart';

/// Check if value is valid URI string
class UriValidator extends FieldValidator<String> {
  final String host;
  final String scheme;
  final int port;
  final String path;
  
  const UriValidator({
    this.path,
    this.host,
    this.scheme,
    this.port,
    String fieldName,
    String errorMessage,
  })  : super(
    fieldName: fieldName,
    message: errorMessage ?? 'should be a valid Uri',
  );

  const UriValidator.withMessage({
    @required String message,
    this.path,
    this.scheme,
    this.host,
    this.port,
  })  : super.withMessage(
        message: message,
      );

  @override
  bool isValid(String value) {
    final Uri uri = Uri.tryParse(value);
    
    if (uri == null) {
      return false;
    }

    if (scheme != null && scheme != uri.scheme) {
      return false;
    }
    
    if (host != null && host != uri.host) {
      return false;
    }

    if (port != null && port != uri.port) {
      return false;
    }

    if (path != null && path != uri.path) {
      return false;
    }
    
    return true;
  }


}