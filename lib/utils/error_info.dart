import 'package:traewelcross/enums/error_type.dart';

class ErrorInfo implements Exception {
  final String message;
  final int? httpStatusCode;
  final Object? exception;
  final ErrorType type;
  const ErrorInfo(
    this.message, {
    required this.type,
    this.httpStatusCode,
    this.exception,
  });
}
