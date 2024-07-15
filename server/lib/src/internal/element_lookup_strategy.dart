import 'package:appium_flutter_server/src/internal/widget_predicates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

enum ElementLookupStrategy {
  BY_KEY,
  BY_SEMANTICS_LABEL,
  BY_TOOLTIP,
  BY_TEXT,
  BY_TEXT_CONTAINING,
  BY_TYPE,
  BY_ICON_POINT,
  BY_ICON_NAME
  // BY_ICON,
  // BY_ELEMENT_PREDICATE,
  // BY_SUBTYPE,
  // BY_WIDGET,
  //BY_WIDGET_PREDICATE,
}

var a = Icons.accessible;

extension ElementLookupStrategyExtension on ElementLookupStrategy {
  ElementLookupStrategy ofName(String strategyName) {
    return ElementLookupStrategy.values.byName(strategyName);
  }

  Finder toFinder(dynamic selector) {
    switch (this) {
      case ElementLookupStrategy.BY_KEY:
        return find.byKey(Key(selector), skipOffstage: false);
      case ElementLookupStrategy.BY_SEMANTICS_LABEL:
        return find.bySemanticsLabel(selector, skipOffstage: false);
      case ElementLookupStrategy.BY_TOOLTIP:
        return find.byTooltip(selector, skipOffstage: false);
      case ElementLookupStrategy.BY_TEXT:
        return find.text(selector, skipOffstage: false);
      case ElementLookupStrategy.BY_TEXT_CONTAINING:
        return find.textContaining(selector, skipOffstage: false);
      case ElementLookupStrategy.BY_TYPE:
        return find.byWidgetPredicate(filterByWidgetName(selector),
            skipOffstage: false);
      case ElementLookupStrategy.BY_ICON_POINT:
        return find.byWidgetPredicate(filterByIconCode(int.parse(selector)),
            skipOffstage: false);
      // return find.byIcon(const IconData(0xe0c4));
      // case ElementLookupStrategy.BY_ELEMENT_PREDICATE:
      //   return find.byElementPredicate(Key(selector));
      // case ElementLookupStrategy.BY_SUBTYPE:
      //   return find.bySubtype<SnackBar>();
      // case ElementLookupStrategy.BY_TYPE:
      //   return find.byType(SingleChildRenderObjectElement);
      // case ElementLookupStrategy.BY_WIDGET:
      //   return find.byWidget(SnackBar);
      // case ElementLookupStrategy.BY_WIDGET_PREDICATE:
      //   return find.byWidget(SnackBar);
      default:
        return find.text(selector);
    }
  }

  String get name {
    switch (this) {
      case ElementLookupStrategy.BY_KEY:
        return '-flutter key';
      case ElementLookupStrategy.BY_SEMANTICS_LABEL:
        return '-flutter semantics label';
      case ElementLookupStrategy.BY_TOOLTIP:
        return '-flutter tooltip';
      case ElementLookupStrategy.BY_TEXT:
        return '-flutter text';
      case ElementLookupStrategy.BY_TEXT_CONTAINING:
        return '-flutter text containting';
      case ElementLookupStrategy.BY_TYPE:
        return '-flutter type';
      case ElementLookupStrategy.BY_ICON_POINT:
        return '-flutter icon point';
      case ElementLookupStrategy.BY_ICON_NAME:
        return '-flutter icon name';
      // case ElementLookupStrategy.BY_ICON:
      //   return '-flutter icon';
      // case ElementLookupStrategy.BY_ELEMENT_PREDICATE:
      //   return '-flutter element predicate';
      // case ElementLookupStrategy.BY_SUBTYPE:
      //   return '-flutter subtype';
      // case ElementLookupStrategy.BY_TYPE:
      //   return '-flutter type';
      // case ElementLookupStrategy.BY_WIDGET:
      //   return '-flutter widget';
      // case ElementLookupStrategy.BY_WIDGET_PREDICATE:
      //   return '-flutter widget predicate';
    }
  }
}
