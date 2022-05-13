class FirebaseException implements Exception {
  FirebaseException({
    required final this.errorCode,
    required this.errorDetails,
  });

  final String errorCode;
  final String errorDetails;

  @override
  String toString() => 'Firebase $errorCode: $errorDetails';
}
