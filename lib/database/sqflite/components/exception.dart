class SqfliteException implements Exception {
  SqfliteException({
    required this.errorCode,
    required this.errorDetails,
  });

  final String errorCode;
  final String errorDetails;
}
