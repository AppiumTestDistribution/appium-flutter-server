import 'dart:io';

import 'package:appium_flutter_server/src/exceptions/flutter_automation_error.dart';

class InvalidArgumentException extends FlutterAutomationException {
  InvalidArgumentException(super.message);

  @override
  int getStatusCode() {
    return HttpStatus.badRequest;
  }

  @override
  String getError() {
    return "invalid argument";
  }
}
