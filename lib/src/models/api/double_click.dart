import 'package:appium_flutter_server/src/models/api/element.dart';
import 'package:appium_flutter_server/src/models/api/find_element.dart';
import 'package:appium_flutter_server/src/models/api/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generated/double_click.g.dart';

@JsonSerializable()
class DoubleClickModel {
  ElementModel? origin;
  FindElementModel? locator;
  PointModel? offset;

  DoubleClickModel({required this.origin, required this.locator, this.offset});

  factory DoubleClickModel.fromJson(Map<String, dynamic> json) =>
      _$DoubleClickModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoubleClickModelToJson(this);
}
