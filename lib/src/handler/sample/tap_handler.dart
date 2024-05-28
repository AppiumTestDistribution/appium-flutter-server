import 'dart:async';

import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf/shelf.dart';

class TapHandler extends RequestHandler {
  TapHandler(super.route);

  @override
  FutureOr<AppiumResponse> handle(Request request) async {
    WidgetTester tester = FlutterDriver.instance.tester;
    return AppiumResponse("NO_ID", {"success": "true"});
  }
}
