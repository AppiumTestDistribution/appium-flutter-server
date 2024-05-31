import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shelf_plus/shelf_plus.dart';

class PressBackHandler extends RequestHandler {
  PressBackHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    var sessionId = getSessionId(request);
    FlutterDriver.instance.getSessionOrThrow();

    await FlutterDriver.instance.tester.pageBack();
    return AppiumResponse(sessionId, null);
  }
}
