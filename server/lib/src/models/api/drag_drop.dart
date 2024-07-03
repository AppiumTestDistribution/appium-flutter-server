import 'package:appium_flutter_server/src/models/api/element.dart';

class DragAndDropModel {
  ElementModel source;
  ElementModel target;
  int? dragDuration;

  DragAndDropModel(
      {required this.source, required this.target, this.dragDuration});

  factory DragAndDropModel.fromJson(Map<String, dynamic> json) =>
      DragAndDropModel(
        source: ElementModel.fromJson(json['source'] as Map<String, dynamic>),
        target: ElementModel.fromJson(json['target'] as Map<String, dynamic>),
        dragDuration: (json['dragDuration'] as num?)?.toInt(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'source': source,
        'target': target,
        'dragDuration': dragDuration,
      };
}
