import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class DragAndDropScreen extends StatefulWidget {
  final String title;

  const DragAndDropScreen({required this.title, super.key});

  @override
  State<DragAndDropScreen> createState() => _DragAndDropScreenState();
}

class _DragAndDropScreenState extends State<DragAndDropScreen> {
  bool selected = false;
  int animationSpeed = 0;
  double initialX = 50;
  double initialY = 50;
  late double x = initialX;
  late double y = initialY;

  bool showDraggable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.title),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            Semantics(
              label: "drop_zone",
              explicitChildNodes: true,
              container: true,
              child: DragTarget<int>(
                builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                ) {
                  return Container(
                    height: 100.0,
                    width: 100.0,
                    color: Colors.cyan,
                    child: const Center(
                      child: Text('Drop here'),
                    ),
                  );
                },
                onAcceptWithDetails: (DragTargetDetails<int> details) {
                  setState(() {
                    showDraggable = !showDraggable;
                  });
                },
              ),
            ),
            showDraggable
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(40),
                    child: Semantics(
                        label: "box_dropped_text",
                        child: const Text("The box is dropped")),
                  ),
            showDraggable
                ? SizedBox(
                    width: 200,
                    height: 350,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        AnimatedPositioned(
                          top: y,
                          left: x,
                          duration: Duration(seconds: animationSpeed),
                          curve: Curves.fastOutSlowIn,
                          child: GestureDetector(
                            onTap: () {},
                            child: Semantics(
                              label: "drag_me",
                              explicitChildNodes: true,
                              container: true,
                              child: Draggable<int>(
                                onDragStarted: () {},
                                onDragUpdate: (details) => {
                                  setState(() {
                                    animationSpeed = 0;
                                    x = x + details.delta.dx;
                                    y = y + details.delta.dy;
                                  })
                                },
                                onDraggableCanceled: (velocity, offset) {
                                  setState(() {
                                    animationSpeed = 1;
                                    x = initialX;
                                    y = initialY;
                                  });
                                },
                                onDragEnd: (details) {},
                                data: 10,
                                feedback: Container(
                                  color: Colors.lightGreenAccent,
                                  height: 100,
                                  width: 100,
                                  child: const Center(
                                    child: Text(
                                      'Draggable',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  height: 100.0,
                                  width: 100.0,
                                  color: Colors.lightGreenAccent,
                                  child: const Center(
                                    child: Text('Draggable'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(
                    width: 200,
                    height: 350,
                  ),
          ],
        ),
      ),
    );
  }
}
