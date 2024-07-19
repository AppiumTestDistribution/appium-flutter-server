import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/models/api/activate_inject_image.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/utils/camera_mocking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../logger.dart';

class ActivateInjectImage extends RequestHandler {
  ActivateInjectImage(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    log('ActivateInjectImageHandler');
    ActivateInjectImageModal activateInjectImageModal = ActivateInjectImageModal.fromJson(await request.body.asJson);

    String activeMockedImage = activateInjectedImage(activateInjectImageModal.imageId.toString());

    return AppiumResponse(getSessionId(request), activeMockedImage);
  }
}
