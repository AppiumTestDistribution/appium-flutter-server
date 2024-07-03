import 'package:appium_flutter_server/src/models/api/find_element.dart';
import 'package:appium_flutter_server/src/utils/json_serialization.dart';
import 'package:flutter/rendering.dart';

const AxisDirectionEnumMap = {
  AxisDirection.up: 'up',
  AxisDirection.right: 'right',
  AxisDirection.down: 'down',
  AxisDirection.left: 'left',
};

class ScrollTillVisibleModel {
  FindElementModel finder;
  FindElementModel? scrollView;
  double? delta;
  AxisDirection? scrollDirection;
  int? maxScrolls;
  int? settleBetweenScrollsTimeout;
  int? dragDuration;

  ScrollTillVisibleModel(
      {required this.finder,
      this.scrollView,
      this.delta,
      this.scrollDirection,
      this.settleBetweenScrollsTimeout,
      this.dragDuration});

  factory ScrollTillVisibleModel.fromJson(Map<String, dynamic> json) =>
      ScrollTillVisibleModel(
        finder:
            FindElementModel.fromJson(json['finder'] as Map<String, dynamic>),
        scrollView: json['scrollView'] == null
            ? null
            : FindElementModel.fromJson(
                json['scrollView'] as Map<String, dynamic>),
        delta: (json['delta'] as num?)?.toDouble(),
        scrollDirection:
            enumDecodeNullable(AxisDirectionEnumMap, json['scrollDirection']),
        settleBetweenScrollsTimeout:
            (json['settleBetweenScrollsTimeout'] as num?)?.toInt(),
        dragDuration: (json['dragDuration'] as num?)?.toInt(),
      )..maxScrolls = (json['maxScrolls'] as num?)?.toInt();

  Map<String, dynamic> toJson() => <String, dynamic>{
        'finder': finder,
        'scrollView': scrollView,
        'delta': delta,
        'scrollDirection': AxisDirectionEnumMap[scrollDirection],
        'maxScrolls': maxScrolls,
        'settleBetweenScrollsTimeout': settleBetweenScrollsTimeout,
        'dragDuration': dragDuration,
      };
}
