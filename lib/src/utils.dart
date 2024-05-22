import 'package:network_tools/network_tools.dart';

const MIN_PORT = 5000;
const MAX_PORT = 9000;

Future<int> getFreePort() async {
  for (int port = MIN_PORT; port < MAX_PORT; port++) {
    var hosts = await PortScannerService.instance.isOpen("localhost", port);
    if (hosts == null || hosts.openPorts.isEmpty) {
      return port;
    }
  }
  return -1;
}
