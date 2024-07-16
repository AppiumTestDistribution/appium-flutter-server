import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/appium_test_bindings.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appium_flutter_server/src/server.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:image_picker_ios/image_picker_ios.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:integration_test/integration_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


const MAX_TEST_DURATION_SECS = 24 * 60 * 60;
const serverVersion = '0.0.18';

// @GenerateMocks([ImagePickerAndroid])

void initializeTest({Widget? app, Function? callback}) async {
  IntegrationTestWidgetsFlutterBinding binding =
      AppiumTestWidgetsFlutterBinding.ensureInitialized();


  binding.ensureSemantics;

  if (app == null && callback == null) {
    throw Exception("App and callback cannot be null");
  }

  testWidgets('appium flutter server', (tester) async {
    //ImagePickerPlatform.instance = MockImagePickerIOS();
    ImagePickerPlatform.instance = MockImagePickerAndroid();
    //await saveDownloadedFile([], "");
    print(ImagePickerPlatform.instance);
    // ImagePicker.instance = MockImagePickerAndroid();



    /* Initialize network tools */
    // final appDocDirectory = await getApplicationDocumentsDirectory();
    // await configureNetworkTools(appDocDirectory.path, enableDebugging: true);
    // tester.binding.defaultBinaryMessenger
    //     .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    //   return "/sdcard/Pictures/test.png";
    // });
    if (callback != null) {
      await callback(tester);
    } else {
      await tester.pumpWidget(app!);
    }

    var appInfo = await PackageInfo.fromPlatform();
    // Need a better way to fetch this for automated release, this needs to be updated along with version bump
    // Can stay for now as it is not a breaking change
    FlutterDriver.instance.initialize(
        tester: tester,
        binding: binding,
        appInfo: appInfo,
        serverVersion: serverVersion);
    //await tester.pumpWidget(app);
    // await tester.tap(find.text("Form widgets"));
    // await tester.pumpAndSettle();
    // await tester.tap(find.byKey(Key("brushed_check_box")));
    // await tester.pumpAndSettle();
    FlutterServer.instance.startServer();

    // To block the test from ending
    await Completer<void>().future;
  }, timeout: const Timeout(Duration(seconds: MAX_TEST_DURATION_SECS)));
}

class MockImagePickerIOS extends ImagePickerIOS {

  Future<PickedFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    return PickedFile("image_path123456");
  }
  //Document Directory real device
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async {
    return XFile("/Users/shebinkoshy/Downloads/appium-flutter-server-qr_code/demo-app/images.jpeg");
  }
}

class MockImagePickerAndroid extends ImagePickerPlatform {

  // Future<PickedFile?> pickImage({
  //   required ImageSource source,
  //   double? maxWidth,
  //   double? maxHeight,
  //   int? imageQuality,
  //   CameraDevice preferredCameraDevice = CameraDevice.rear,
  // }) async {
  //   return PickedFile("image_path123456");
  // }

  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async {
    return XFile("/storage/emulated/0/Android/data/com.example.appium_testing_app/files/QR.png");
  }
  Future<LostDataResponse> getLostData() {
    return Future.value(LostDataResponse.empty());
  }
}

Future<File> saveDownloadedFile(List<int> fileBytes, String fileName) async {
  Directory directory;
  if (Platform.isAndroid) {
    final permission = await Permission.manageExternalStorage.request();
    if (permission.isGranted) {
      directory = (await getExternalStorageDirectory())!;
    } else {
      throw Exception("Storage permission not granted");
    }
  } else if (Platform.isIOS) {
    directory = await getApplicationDocumentsDirectory();
  } else {
    throw UnsupportedError("Unsupported platform");
  }

  String filePath = path.join(directory.path, fileName);

  File file = File(filePath);
  await file.writeAsBytes(fileBytes);

  debugPrint('File saved to $filePath');
  return file;
}
