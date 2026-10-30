import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/ts_recorder/about_handler.dart';

// Register the Testsigma recorder routes. This is the only entry point from server.dart.
class RecorderRoutes {
  static void register(void Function(RequestHandler handler) registerGet) {
    registerGet(AboutHandler("/ts/recorder/about"));
  }
}
