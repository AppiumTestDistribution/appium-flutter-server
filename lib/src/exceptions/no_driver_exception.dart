import 'dart:io';

import 'package:appium_flutter_server/src/exceptions/flutter_automation_error.dart';

class NoSuchDriverException extends FlutterAutomationException {
  NoSuchDriverException(super.message);

  @override
  int getStatusCode() {
    return HttpStatus.notFound;
  }
}
