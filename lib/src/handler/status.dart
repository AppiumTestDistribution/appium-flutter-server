import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/models/appium_response.dart';
import 'package:shelf/shelf.dart';

class StatusHandler extends RequestHandler {
  StatusHandler(super.route);

  @override
  AppiumResponse handle(Request request) {
    return AppiumResponse(
        "NO_ID", "Flutter driver is ready to accept new connections");
  }
}
