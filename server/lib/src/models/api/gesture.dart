import 'package:appium_flutter_server/src/models/api/element.dart';
import 'package:appium_flutter_server/src/models/api/find_element.dart';
import 'package:appium_flutter_server/src/models/api/point.dart';

class GestureModel {
  ElementModel? origin;
  FindElementModel? locator;
  PointModel? offset;

  GestureModel({required this.origin, required this.locator, this.offset});

  factory GestureModel.fromJson(Map<String, dynamic> json) => GestureModel(
        origin: json['origin'] == null
            ? null
            : ElementModel.fromJson(json['origin'] as Map<String, dynamic>),
        locator: json['locator'] == null
            ? null
            : FindElementModel.fromJson(
                json['locator'] as Map<String, dynamic>),
        offset: json['offset'] == null
            ? null
            : PointModel.fromJson(json['offset'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'origin': origin,
        'locator': locator,
        'offset': offset,
      };
}
