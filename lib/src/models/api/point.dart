import 'package:json_annotation/json_annotation.dart';

part 'generated/point.g.dart';

@JsonSerializable()
class PointModel {
  double x;
  double y;

  PointModel({required this.x, required this.y});

  factory PointModel.fromJson(Map<String, dynamic> json) =>
      _$PointModelFromJson(json);

  Map<String, dynamic> toJson() => _$PointModelToJson(this);
}
