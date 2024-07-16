import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/exceptions/invalid_argument_exception.dart';
import 'package:appium_flutter_server/src/handler/request/no_session_command_handler.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/models/api/create_session.dart';
import 'package:appium_flutter_server/src/utils/w3c_capabilities.dart';
import 'package:shelf_plus/shelf_plus.dart';

class NewSessionHandler extends RequestHandler
    implements NoSessionCommandHandler {
  static const String _CAPABILITIES_KEY = "capabilities";
  NewSessionHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    var session = CreateSessionModel.fromJson(await request.body.asJson);
    if (session.capabilities == null) {
      throw InvalidArgumentException(
          "'$_CAPABILITIES_KEY' are mandatory for session creation");
    }
    Map<String, dynamic> parsedCaps =
        W3CCapsUtils.parseCapabilities(session.capabilities!);

    String sessionId =
        FlutterDriver.instance.initializeSession(session.capabilities!);
    //MockingService
    return AppiumResponse(sessionId, parsedCaps);
  }
}
