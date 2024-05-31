import 'package:appium_flutter_server/src/internal/widget_predicates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

enum ElementLookupStrategy {
  BY_KEY,
  BY_SEMANTICS_LABEL,
  BY_TOOLTIP,
  BY_TEXT,
  BY_TEXT_CONTAINING,
  // BY_ICON,
  // BY_ELEMENT_PREDICATE,
  // BY_SUBTYPE,
  // BY_TYPE,
  // BY_WIDGET,
  //BY_WIDGET_PREDICATE,

  //Custom Selectors
  BY_WIDGET_NAME,
  BY_ICON_POINT,
  BY_ICON_NAME
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
      case ElementLookupStrategy.BY_WIDGET_NAME:
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
        return 'key';
      case ElementLookupStrategy.BY_SEMANTICS_LABEL:
        return 'semantics label';
      case ElementLookupStrategy.BY_TOOLTIP:
        return 'tooltip';
      case ElementLookupStrategy.BY_TEXT:
        return 'text';
      case ElementLookupStrategy.BY_TEXT_CONTAINING:
        return 'text containting';

      case ElementLookupStrategy.BY_WIDGET_NAME:
        return 'widget name';
      case ElementLookupStrategy.BY_ICON_POINT:
        return 'icon point';
      case ElementLookupStrategy.BY_ICON_NAME:
        return 'icon name';
      // case ElementLookupStrategy.BY_ICON:
      //   return 'icon';
      // case ElementLookupStrategy.BY_ELEMENT_PREDICATE:
      //   return 'element predicate';
      // case ElementLookupStrategy.BY_SUBTYPE:
      //   return 'subtype';
      // case ElementLookupStrategy.BY_TYPE:
      //   return 'type';
      // case ElementLookupStrategy.BY_WIDGET:
      //   return 'widget';
      // case ElementLookupStrategy.BY_WIDGET_PREDICATE:
      //   return 'widget predicate';
    }
  }
}
