class JsonLibException implements Exception {
  final String message;
  const JsonLibException(this.message);

  @override
  String toString() => message;
}
