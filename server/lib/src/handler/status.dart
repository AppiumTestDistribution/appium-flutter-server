import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/handler/request/no_session_command_handler.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/models/session.dart';
import 'package:shelf/shelf.dart';

class StatusHandler extends RequestHandler implements NoSessionCommandHandler {
  StatusHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    String? sessionId;
    try {
      sessionId = FlutterDriver.instance.getSessionOrThrow()!.sessionId;
    } catch (err) {
      sessionId = Session.NO_ID;
    }
    return AppiumResponse(sessionId, {
      "message": "Flutter driver is ready to accept new connections",
      "appInfo": FlutterDriver.instance.appInfo.data,
      "serverVersion": FlutterDriver.instance.serverVersion,
    });
  }
}
