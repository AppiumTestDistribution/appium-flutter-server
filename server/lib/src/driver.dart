import 'package:appium_flutter_server/src/exceptions/no_driver_exception.dart';
import 'package:appium_flutter_server/src/models/session.dart';
import 'package:appium_flutter_server/src/utils/flutter_settings.dart';
import 'package:appium_flutter_server/src/utils/test_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FlutterDriver {
  late WidgetTester _tester;
  late IntegrationTestWidgetsFlutterBinding _binding;
  late PackageInfo _appInfo;
  String? _serverVersion;
  Session? _session;
  bool _isCameraMocked = false;
  final Map<String, String> _savedFiles = {};
  String? _activeMockImage;
  FlutterSettings settings = FlutterSettings();

  FlutterDriver._();

  static final FlutterDriver _instance = FlutterDriver._();
  static FlutterDriver get instance => _instance;

  WidgetTester get tester => _tester;
  IntegrationTestWidgetsFlutterBinding get binding => _binding;
  PackageInfo get appInfo => _appInfo;
  String? get serverVersion => _serverVersion;
  bool get isCameraMocked => _isCameraMocked;
  String? get activeMockImage => _activeMockImage;

  void initialize(
      {required WidgetTester tester,
      required IntegrationTestWidgetsFlutterBinding binding,
      required PackageInfo appInfo,
      required String serverVersion}) async {
    _tester = tester;
    _binding = binding;
    _appInfo = appInfo;
    _serverVersion = serverVersion;
  }

  String initializeSession(Map<String, dynamic> capabilities) {
    _session = Session(generateUUID(), capabilities);
    settings.updateSetting(capabilities);
    return _session!.sessionId;
  }

  Session? getSessionOrThrow() {
    if (_session == null) {
      throw NoSuchDriverException(
          "A session is either terminated or not started");
    }
    return _session;
  }

  Session? getSession() {
    return _session;
  }

  void resetSession() {
    _session = null;
    settings.reset();
  }

  void setCameraMocked(bool value) {
    _isCameraMocked = value;
  }

  void saveFileInfo(String fileName, String filePath) {
    _savedFiles[fileName] = filePath;
  }

  String? getFilePath(String fileName) {
    return _savedFiles[fileName];
  }

  void setActiveMockImage(String? value) {
    _activeMockImage = value;
  }

  String? getActiveMockImage() {
    return _savedFiles[_activeMockImage];
  }
}
