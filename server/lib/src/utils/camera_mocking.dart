
import 'dart:convert';
import 'dart:typed_data';

import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/logger.dart';
import 'package:appium_flutter_server/src/utils/test_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
class MockImagePicker extends ImagePickerPlatform {

  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async {
    String? image = FlutterDriver.instance.getActiveMockImage();
    return XFile(image!);
  }
  Future<LostDataResponse> getLostData() {
    return Future.value(LostDataResponse.empty());
  }
}

String activateInjectedImage(String imageId) {
  if (FlutterDriver.instance.isCameraMocked) {
    FlutterDriver.instance.setActiveMockImage(imageId);
    return FlutterDriver.instance.getActiveMockImage()!;
  } else {
    throw Exception("Make sure you have enabled the capability 'flutterEnableMockCamera: true' and inject an image before activating");
  }
}

Future<String>  saveImageToDevice(String base64String) async {
  if (FlutterDriver.instance.isCameraMocked) {
    Directory directory;
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.version.sdkInt}');
      PermissionStatus permission;
      if (androidInfo.version.sdkInt < 33) {
        permission = await Permission.storage.request();
      } else {
        permission = await Permission.manageExternalStorage.request();
      }
      if (permission.isGranted) {
        log('Injected Image will be saved in path ${await getDownloadsDirectory()}');
        directory = (await getDownloadsDirectory())!;
      } else {
        throw Exception("Storage permission not granted");
      }
    } else if (Platform.isIOS) {
      log('Injected Image will be saved in path ${await getApplicationDocumentsDirectory()}');
      directory = await getApplicationDocumentsDirectory();
    } else {
      throw UnsupportedError("Unsupported platform");
    }
    String fileName = "${generateUUID()}.png";
    String filePath = path.join(directory.path, fileName);
    Uint8List bytes;
    bytes = const Base64Decoder().convert(base64String);


    File file = File(filePath);
    await file.writeAsBytes(bytes);
    log('File saved to $filePath');
    FlutterDriver.instance.saveFileInfo(fileName, filePath);
    FlutterDriver.instance.setActiveMockImage(fileName);
    return fileName;
  } else {
    throw Exception("Make sure you have enabled the capability 'flutterEnableMockCamera: true'");
  }
}
