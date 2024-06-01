import 'package:appium_flutter_server/src/models/api/find_element.dart';
import 'package:flutter/rendering.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generated/scroll_till_visible.g.dart';

@JsonSerializable()
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
      _$ScrollTillVisibleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScrollTillVisibleModelToJson(this);
}
