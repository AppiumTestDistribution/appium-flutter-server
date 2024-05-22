class FlutterAutomationException implements Exception {
  String message =
      "An unknown server-side error occurred while processing the command";
  static const int DEFAULT_ERROR_STATUS = 500;

  get statusCode => DEFAULT_ERROR_STATUS;

  FlutterAutomationException(this.message);
}
