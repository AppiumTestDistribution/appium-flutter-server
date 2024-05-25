// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../rect.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RectModel _$RectModelFromJson(Map<String, dynamic> json) => RectModel(
      left: (json['left'] as num).toDouble(),
      top: (json['top'] as num).toDouble(),
      right: (json['right'] as num).toDouble(),
      bottom: (json['bottom'] as num).toDouble(),
    );

Map<String, dynamic> _$RectModelToJson(RectModel instance) => <String, dynamic>{
      'left': instance.left,
      'top': instance.top,
      'right': instance.right,
      'bottom': instance.bottom,
    };
