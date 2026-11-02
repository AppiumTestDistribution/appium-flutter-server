// ----- TESTSIGMA CHANGES START -----
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Rules that find widgets the user cannot see or touch.
class VisibilityRules {
  // Rule 1. Skip the subtree when the parent render object does not paint it.
  static bool isPaintedByParent(Element element) {
    if (element is! RenderObjectElement) return true;
    final RenderObject renderObject = element.renderObject;
    final RenderObject? parent = renderObject.parent;
    return parent == null || parent.paintsChild(renderObject);
  }

  // Rule 2. Overlay disables tickers for routes under an opaque route.
  static bool isCoveredRoute(Widget widget) =>
      widget is TickerMode && !widget.enabled;

  // Rule 3. RenderIndexedStack paints only the child at its index.
  // Returns null when the element is not an IndexedStack.
  static int? paintedChildIndex(Element element) {
    if (element is! RenderObjectElement) return null;
    final RenderObject renderObject = element.renderObject;
    if (renderObject is! RenderIndexedStack) return null;
    return renderObject.index ?? -1;
  }

  // The user cannot touch the subtree of this widget.
  static bool blocksInput(Widget widget) =>
      (widget is IgnorePointer && widget.ignoring) ||
      (widget is AbsorbPointer && widget.absorbing);

  static bool isModalBarrier(Widget widget) => widget is ModalBarrier;

  static bool isOverlay(Widget widget) => widget is Overlay;

  static bool isPlatformView(RenderObject renderObject) =>
      renderObject is PlatformViewRenderBox || renderObject is RenderUiKitView;
}
// ----- TESTSIGMA CHANGES END -----
