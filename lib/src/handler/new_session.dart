import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/models/appium_response.dart';
import 'package:shelf/shelf.dart';

class NewSessionHandler extends RequestHandler {
  NewSessionHandler(super.route);

  @override
  AppiumResponse handle(Request request) {
    // TODO: implement handle
    throw UnimplementedError();
  }
}
