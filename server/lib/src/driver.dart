import 'package:appium_flutter_server/src/exceptions/no_driver_exception.dart';
import 'package:appium_flutter_server/src/models/session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

class FlutterDriver {
  late WidgetTester _tester;
  late IntegrationTestWidgetsFlutterBinding _binding;
  late PackageInfo _appInfo;

  Session? _session;

  FlutterDriver._();

  static final FlutterDriver _instance = FlutterDriver._();
  static FlutterDriver get instance => _instance;

  WidgetTester get tester => _tester;
  IntegrationTestWidgetsFlutterBinding get binding => _binding;
  PackageInfo get appInfo => _appInfo;

  void initialize(
      {required WidgetTester tester,
      required IntegrationTestWidgetsFlutterBinding binding,
      required PackageInfo appInfo}) async {
    _tester = tester;
    _binding = binding;
    _appInfo = appInfo;
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
