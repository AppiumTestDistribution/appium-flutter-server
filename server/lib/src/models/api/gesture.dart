import 'package:appium_flutter_server/src/models/api/element.dart';
import 'package:appium_flutter_server/src/models/api/find_element.dart';
import 'package:appium_flutter_server/src/models/api/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generated/gesture.g.dart';
@JsonSerializable()
class GestureModel {
  ElementModel? origin;
  FindElementModel? locator;
  PointModel? offset;

  GestureModel({required this.origin, required this.locator, this.offset});

  factory GestureModel.fromJson(Map<String, dynamic> json) =>
      _$GestureModelFromJson(json);

  Map<String, dynamic> toJson() => _$GestureModelToJson(this);
}
