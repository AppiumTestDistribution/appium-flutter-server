import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/utils/element_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:appium_flutter_server/src/models/api/drag_drop.dart';

class DragAndDrop extends RequestHandler {
  DragAndDrop(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    var sessionId = getSessionId(request);
    DragAndDropModel model =
    DragAndDropModel.fromJson(await request.body.asJson);
    await ElementHelper.dragAndDrop(model);
    return AppiumResponse(sessionId, null);
  }
}
