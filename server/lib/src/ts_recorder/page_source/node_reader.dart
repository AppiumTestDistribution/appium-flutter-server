// ----- TESTSIGMA CHANGES START -----
import 'package:appium_flutter_server/src/ts_recorder/page_source/node.dart';
import 'package:flutter/material.dart';

class NodeReader {
  // Read the finder values and the state of one widget into the node.
  // The first value wins, because the outermost widget is read first.
  static void read(Element element, Node node) {
    final Widget widget = element.widget;
    node.addType(widget.runtimeType.toString());

    // find.byKey matches only ValueKey<String>. Do not report other key types.
    final Key? key = widget.key;
    if (key is ValueKey<String>) node.key ??= key.value;

    if (widget is Text) {
      node.text ??= widget.data ?? widget.textSpan?.toPlainText();
    } else if (widget is EditableText) {
      // Show the typed value only. Typing changes it, so it is not a locator.
      node.inputValue ??= widget.controller.text;
      node.focusable = true;
      node.focused = widget.focusNode.hasFocus;
    } else if (widget is Tooltip) {
      node.tooltip ??= widget.message;
    } else if (widget is Icon) {
      node.icon ??= widget.icon?.codePoint;
    } else if (widget is TextField) {
      node.hint ??= widget.decoration?.hintText;
      node.label ??= widget.decoration?.labelText;
      node.enabled ??= widget.enabled ?? widget.decoration?.enabled ?? true;
    } else if (widget is ButtonStyleButton) {
      node.enabled ??= widget.enabled;
    } else if (widget is IconButton) {
      node.enabled ??= widget.onPressed != null;
    } else if (widget is InkResponse) {
      node.enabled ??= widget.onTap != null ||
          widget.onLongPress != null ||
          widget.onDoubleTap != null;
    } else if (widget is ListTile) {
      node.enabled ??= widget.enabled;
    } else if (widget is Focus && widget is! FocusScope) {
      // Every route has a FocusScope. Do not mark pages as focusable.
      node.focusable = node.focusable || widget.canRequestFocus;
    }

    // Checkbox, Switch and Radio, Material and Cupertino, use this state.
    if (element is StatefulElement) {
      final State state = element.state;
      if (state is ToggleableStateMixin) {
        node.checked ??= state.value ?? false;
        node.enabled ??= state.isInteractive;
      }
    }

    // Debug builds only. The semantics label finder reads the same value.
    if (element is RenderObjectElement) {
      final String? semanticsLabel = element.renderObject.debugSemantics?.label;
      if (semanticsLabel != null && semanticsLabel.isNotEmpty) {
        node.semanticsLabel ??= semanticsLabel;
      }
    }
  }
}
// ----- TESTSIGMA CHANGES END -----
