import 'custom_validator.dart';
import '../contracts/validator.dart';

/// Checks value on `isEmpty`
class EmptyValidator {
  static String _defaultErrorMessage = 'should be empty';

  /// Checks if string is not empty
  static Validator<String> string({
    String fieldName,
    String errorMessage,
  }) => CustomValidator<String>(
    fieldName: fieldName,
    message: (_) => errorMessage ?? _defaultErrorMessage,
    isValid: (value) => value.isEmpty,
  );

  /// Checks if string is not empty. Defines full error message
  static Validator<String> stringWithMessage(String message) =>
      CustomValidator<String>.withMessage(
        message: (_) => message,
        isValid: (value) => value.isEmpty,
      );

  /// Checks if [Iterable] is not empty
  static Validator<Iterable<I>> iterable<I>({
    String fieldName,
    String errorMessage,
  }) => CustomValidator<Iterable<I>>(
    fieldName: fieldName,
    message: (_) => errorMessage ?? _defaultErrorMessage,
    isValid: (value) => value.isEmpty,
  );

  /// Checks if [Iterable] is not empty. Defines full error message
  static Validator<Iterable<I>> iterableWithMessage<I>(String message) =>
      CustomValidator<Iterable<I>>.withMessage(
        message: (_) => message,
        isValid: (value) => value.isEmpty,
      );

  /// Checks if [Map] is not empty
  static Validator<Map<K,V>> map<K,V>({
    String fieldName,
    String errorMessage,
  }) => CustomValidator<Map<K,V>>(
    fieldName: fieldName,
    message: (_) => errorMessage ?? _defaultErrorMessage,
    isValid: (value) => value.isEmpty,
  );

  /// Checks if [Iterable] is not empty. Defines full error message
  static Validator<Map<K,V>> mapWithMessage<K,V>(String message) =>
      CustomValidator<Map<K,V>>.withMessage(
        message: (_) => message,
        isValid: (value) => value.isEmpty,
      );
}