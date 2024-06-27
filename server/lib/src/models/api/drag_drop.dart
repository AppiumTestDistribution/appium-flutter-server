import 'package:appium_flutter_server/src/models/api/find_element.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:appium_flutter_server/src/models/api/element.dart';

part 'generated/drag_drop.g.dart';

@JsonSerializable()
class DragAndDropModel {
  ElementModel source;
  ElementModel target;
  int? dragDuration;

  DragAndDropModel(
      {required this.source,
        required this.target,
      this.dragDuration});

  factory DragAndDropModel.fromJson(Map<String, dynamic> json) =>
      _$DragAndDropModelFromJson(json);

  Map<String, dynamic> toJson() => _$DragAndDropModelToJson(this);
}
