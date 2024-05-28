import 'package:json_annotation/json_annotation.dart';

part 'generated/error.g.dart';

@JsonSerializable()
class ErrorModel {
  String error;
  String message;
  String? stackTrace;

  ErrorModel({required this.error, required this.message, this.stackTrace});

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorModelToJson(this);
}
