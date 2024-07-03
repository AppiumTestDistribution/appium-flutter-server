import 'package:appium_flutter_server/src/models/api/element.dart';
import 'package:appium_flutter_server/src/models/api/find_element.dart';

class WaitModel {
  ElementModel? element;
  FindElementModel? locator;
  Duration? timeout = const Duration(seconds: 5);

  WaitModel({required this.element, required this.locator, this.timeout});

  static int _durationToJson(Duration? value) {
    return value != null ? value.inSeconds : 5;
  }

  static Duration _durationFromJson(int? value) {
    return Duration(seconds: value ?? 5);
  }

  factory WaitModel.fromJson(Map<String, dynamic> json) => WaitModel(
        element: json['element'] == null
            ? null
            : ElementModel.fromJson(json['element'] as Map<String, dynamic>),
        locator: json['locator'] == null
            ? null
            : FindElementModel.fromJson(
                json['locator'] as Map<String, dynamic>),
        timeout:
            WaitModel._durationFromJson((json['timeout'] as num?)?.toInt()),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'element': element,
        'locator': locator,
        'timeout': WaitModel._durationToJson(timeout),
      };
}
