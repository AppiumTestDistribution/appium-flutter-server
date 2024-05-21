import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appium_flutter_server/src/server.dart';

void initializeTest(Widget app) async {
  testWidgets('tap on the floating action button, verify counter',
      (tester) async {
    // tester.view.physicalSize = Size(tester.view.physicalConstraints.maxWidth,
    //     tester.view.physicalConstraints.maxHeight);
    await tester.binding.setSurfaceSize(Size(
      tester.view.physicalConstraints.maxWidth *
          tester.view.physicalSize.aspectRatio,
      tester.view.physicalConstraints.maxHeight *
          tester.view.physicalSize.aspectRatio,
    ));

    await tester.pumpWidget(app);

    await startServer(tester);
  }, timeout: const Timeout(Duration(seconds: 600)));
}
