import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/exceptions/no_driver_exception.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/logger.dart';
import 'package:appium_flutter_server/src/models/appium_response.dart';

import 'package:shelf_plus/shelf_plus.dart';

class DeleteSessionHandler extends RequestHandler {
  DeleteSessionHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    var sessionId = getSessionId(request);
    var session = FlutterDriver.instance.getSessionOrThrow();
    log("Session id : ${sessionId}");
    if (session == null || sessionId != session.sessionId) {
      throw NoSuchDriverException("The session $sessionId cannot be found");
    }

    return AppiumResponse(sessionId, null);
  }
}
