import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

enum WidgetName { Icon }

bool isIconWidget(Widget widget) {
  return filterByWidgetName(WidgetName.Icon.name)(widget);
}

WidgetPredicate filterByWidgetName(String name) {
  return (Widget widget) {
    return widget.runtimeType.toString() == name;
  };
}

WidgetPredicate filterByIconCode(int iconCode) {
  return (Widget widget) {
    if (!isIconWidget(widget)) {
      return false;
    }
    Icon iconWidget = widget as Icon;
    return iconWidget.icon!.codePoint == iconCode;
  };
}
