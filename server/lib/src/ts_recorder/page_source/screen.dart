// ----- TESTSIGMA CHANGES START -----
import 'dart:ui';

import 'package:flutter/widgets.dart';

// Screen values in logical pixels.
class Screen {
  final Size size;
  final double devicePixelRatio;
  final EdgeInsets padding;
  final EdgeInsets viewInsets;

  Screen(
      {required this.size,
      required this.devicePixelRatio,
      required this.padding,
      required this.viewInsets});

  factory Screen.fromView(FlutterView view) {
    final double ratio = view.devicePixelRatio;
    return Screen(
      size: view.physicalSize / ratio,
      devicePixelRatio: ratio,
      padding: EdgeInsets.fromViewPadding(view.padding, ratio),
      viewInsets: EdgeInsets.fromViewPadding(view.viewInsets, ratio),
    );
  }

  Rect get rect => Offset.zero & size;

  String get orientation => size.width > size.height ? "landscape" : "portrait";

  Map<String, dynamic> toJson() => {
        "width": size.width,
        "height": size.height,
        "devicePixelRatio": devicePixelRatio,
        "padding": {
          "top": padding.top,
          "bottom": padding.bottom,
          "left": padding.left,
          "right": padding.right,
        },
        "viewInsets": {"bottom": viewInsets.bottom},
        "orientation": orientation,
      };
}
// ----- TESTSIGMA CHANGES END -----
