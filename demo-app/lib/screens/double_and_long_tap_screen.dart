import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class DoubleTapScreen extends StatefulWidget {
  final String title;

  // final bool isLongTap;

  const DoubleTapScreen({required this.title, super.key});

  @override
  State<DoubleTapScreen> createState() => _DoubleTapScreenState();
}

class _DoubleTapScreenState extends State<DoubleTapScreen> {
  Offset? tapCoordinates;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.title),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Semantics(
              label: "double_tap_button",
              key: const ValueKey("double_tap_button"),
              explicitChildNodes: true,
              container: true,
              child: GestureDetector(
                onDoubleTap: () async {
                  await _showDoubleTapPopup();
                },
                onDoubleTapDown: (TapDownDetails? details) => {
                  if (details != null) {tapCoordinates = details.globalPosition}
                },
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: const Center(
                    child: Text(
                      "Double Tap",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _showDoubleTapPopup() async {
    String tapDetails = tapCoordinates != null
        ? 'X: ${tapCoordinates!.dx.toStringAsFixed(0)}, Y: ${tapCoordinates!.dy.toStringAsFixed(0)}'
        : "";
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Double Tap"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                label: "double_tap_message",
                child: const Text("Double Tap Successful"),
              ),
              Semantics(
                label: "double_tap_details",
                child: Text(tapDetails),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            )
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  Future _showLongPressPopup() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Long Press"),
          content: const Text("It was a long press"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            )
          ],
        );
      },
      barrierDismissible: false,
    );
  }
}

class LongPressScreen extends StatefulWidget {
  final String title;

  const LongPressScreen({required this.title, super.key});

  @override
  State<LongPressScreen> createState() => _LongPressScreenState();
}

class _LongPressScreenState extends State<LongPressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.title),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
              child: InkWell(
                key: const ValueKey("long_press_button"),
                onLongPress: () async {
                  await _showLongPressPopup();
                },
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: const Center(
                    child: Text(
                      "Long Press",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
          )
        ],
      ),
    );
  }

  Future _showLongPressPopup() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Long Press"),
          content: const Text("It was a long press"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            )
          ],
        );
      },
      barrierDismissible: false,
    );
  }
}
