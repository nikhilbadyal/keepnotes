class DatabaseExceptions implements Exception {
  DatabaseExceptions(this.errorCode);

  final String errorCode;

  @override
  String toString() => 'DBError $errorCode';
}
