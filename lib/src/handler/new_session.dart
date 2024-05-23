import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/models/appium_response.dart';
import 'package:appium_flutter_server/src/models/create_session.dart';
import 'package:shelf_plus/shelf_plus.dart';

class NewSessionHandler extends RequestHandler {
  NewSessionHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    var session = CreateSession.fromJson(await request.body.asJson);
    return AppiumResponse("sessionId", session);
  }
}
