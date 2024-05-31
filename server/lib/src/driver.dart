import 'package:appium_flutter_server/src/exceptions/no_driver_exception.dart';
import 'package:appium_flutter_server/src/models/session.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:uuid/uuid.dart';

class FlutterDriver {
  late WidgetTester _tester;
  late Widget _app;
  late IntegrationTestWidgetsFlutterBinding _binding;
  Session? _session;

  FlutterDriver._();

  static final FlutterDriver _instance = FlutterDriver._();
  static FlutterDriver get instance => _instance;

  Widget get app => _app;
  WidgetTester get tester => _tester;
  IntegrationTestWidgetsFlutterBinding get binding => _binding;

  void initialize(
      {required WidgetTester tester,
      required Widget app,
      required IntegrationTestWidgetsFlutterBinding binding}) async {
    _tester = tester;
    _app = app;
    _binding = binding;
  }

  String initializeSession(Map<String, dynamic> capabilities) {
    _session = Session(const Uuid().v4(), capabilities);
    return _session!.sessionId;
  }

  Session? getSessionOrThrow() {
    if (_session == null) {
      throw NoSuchDriverException(
          "A session is either terminated or not started");
    }
    return _session;
  }

  void resetSession() {
    _session = null;
  }
}
