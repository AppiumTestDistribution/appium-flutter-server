import 'dart:async';

import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/appium_test_bindings.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appium_flutter_server/src/server.dart';
import 'package:image_picker/image_picker.dart';
import 'package:integration_test/integration_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

    // ImagePicker.instance = MockImagePickerAndroid();

    final binaryBinding =   TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    List<MethodCall> calls = [];
    const channel = MethodChannel('dev.flutter.pigeon.image_picker_android.ImagePickerApi.pickImages');
    print(channel);
    Completer completer = Completer();
    binaryBinding.setMockMethodCallHandler(
      channel,
          (MethodCall call) async {
            calls.add(call);
           XFile file =  XFile("/data/user/0/com.example.appium_testing_app/cache/test.png");
              print('CallMethod');
              print(call.method);
           // (((__pigeon_replyList)[0] as List<Object?>)[0]) as String
           Object? obj = "/data/user/0/com.example.appium_testing_app/cache/6701d669-5e67-42e5-ad32-de39e816e00c7800027760059733985.jpg";
           obj = "/data/user/0/com.example.appium_testing_app/cache/148f847a-16a6-42f4-94e6-6f25fef712a63468100313382166415.jpg";//ACTUALL
           List<Object?>? list = [obj] as List<Object?>?;
           List<Object?>? list2 = [list] as List<Object?>?;
            completer.complete();
              return list2;
          },

    );


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
    await completer.future;
    await Completer<void>().future;
  }, timeout: const Timeout(Duration(seconds: MAX_TEST_DURATION_SECS)));
}
