class SqfliteException implements Exception {
  SqfliteException({
    required final this.errorCode,
    required this.errorDetails,
  });

  final String errorCode;
  final String errorDetails;
}
