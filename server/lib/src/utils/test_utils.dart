import 'dart:io';

import 'package:appium_flutter_server/src/logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';

bool enumContains<T extends Enum>(List<T> _enum, dynamic value) {
  return _enum.map((e) => e.name).contains(value);
}

Future<int?> readPortFromFile() async {
  if (!Platform.isIOS) {
    return null;
  }
  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo ios = await deviceInfo.iosInfo;
    /* To support parallel execution in ios Simulators
     * custom port can be passed from the file.
     * Documents directory are unique to each simulator and  will look like
     * /Users/<user>/Library/Developer/CoreSimulator/Devices/C886DFF0-7975-41B4-B75D-323321302DB8/data/Containers/Data/Application/E967B44A-98D6-4640-82A0-2D2A5EBB5772/Documents
     */
    log("Ios Device info $ios");
    if (!ios.isPhysicalDevice) {
      final documentDirectory = await getApplicationDocumentsDirectory();
      final serverFile = File(
          "${documentDirectory.path}${Platform.pathSeparator}flutter_server.txt");
      if (serverFile.existsSync()) {
        log("flutter server config exists in path $serverFile");
        return int.parse(serverFile.readAsStringSync());
      } else {
        log("flutter server config not present in path $serverFile");
      }
    }
  } catch (err) {
    log("Error reading PORT from flutter server file $err");
    return null;
  }
  return null;
}
