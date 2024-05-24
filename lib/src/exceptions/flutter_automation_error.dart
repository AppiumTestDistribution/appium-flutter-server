import 'dart:io';

class FlutterAutomationException implements Exception {
  String _message =
      "An unknown server-side error occurred while processing the command";

  FlutterAutomationException(this._message);

  String getMessage() {
    return _message;
  }

  int getStatusCode() {
    return HttpStatus.internalServerError;
  }
}
