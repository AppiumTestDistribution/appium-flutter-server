import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/handler/request/no_session_command_handler.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/models/session.dart';
import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';

// Increase this value only when the recorder response shape changes.
const recorderApiVersion = 1;

// Tell the client that this app has the Testsigma recorder, and which version.
class AboutHandler extends RequestHandler implements NoSessionCommandHandler {
  AboutHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    String? sessionId = FlutterDriver.instance.getSession()?.sessionId;
    return AppiumResponse(sessionId ?? Session.NO_ID, {
      "recorderApi": recorderApiVersion,
      "serverVersion": FlutterDriver.instance.serverVersion,
      "sessionId": sessionId,
      "platform": defaultTargetPlatform.name.toLowerCase(),
    });
  }
}
