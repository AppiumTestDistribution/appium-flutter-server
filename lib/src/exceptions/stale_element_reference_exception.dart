import 'dart:io';

import 'package:appium_flutter_server/src/exceptions/flutter_automation_error.dart';

class StaleElementReferenceException extends FlutterAutomationException {
  StaleElementReferenceException(super.message);

  @override
  int getStatusCode() {
    return HttpStatus.notFound;
  }

  @override
  String getError() {
    return "stale element reference";
  }
}
