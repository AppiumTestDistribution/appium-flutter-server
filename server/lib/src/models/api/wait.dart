import 'package:appium_flutter_server/src/models/api/element.dart';
import 'package:appium_flutter_server/src/models/api/find_element.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generated/wait.g.dart';

@JsonSerializable()
class WaitModel {
  ElementModel? element;
  FindElementModel? locator;

  @JsonKey(
    toJson: _durationToJson,
    fromJson: _durationFromJson,
  )
  Duration? timeout = Duration(seconds: 5);

  WaitModel({required this.element, required this.locator, this.timeout});

  static int _durationToJson(Duration? value) {
    return value != null ? value.inSeconds : 5;
  }

  static Duration _durationFromJson(int? value) {
    return Duration(seconds: value ?? 5);
  }

  factory WaitModel.fromJson(Map<String, dynamic> json) =>
      _$WaitModelFromJson(json);

  Map<String, dynamic> toJson() => _$WaitModelToJson(this);
}
