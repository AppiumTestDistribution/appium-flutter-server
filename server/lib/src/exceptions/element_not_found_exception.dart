import 'dart:io';

import 'package:appium_flutter_server/src/exceptions/flutter_automation_error.dart';

class ElementNotFoundException extends FlutterAutomationException {
  ElementNotFoundException(super.message);

  @override
  int getStatusCode() {
    return HttpStatus.notFound;
  }

  @override
  String getError() {
    return "no such element";
  }
}
