// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../double_click.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoubleClickModel _$DoubleClickModelFromJson(Map<String, dynamic> json) =>
    DoubleClickModel(
      origin: json['origin'] == null
          ? null
          : ElementModel.fromJson(json['origin'] as Map<String, dynamic>),
      locator: json['locator'] == null
          ? null
          : FindElementModel.fromJson(json['locator'] as Map<String, dynamic>),
      offset: json['offset'] == null
          ? null
          : PointModel.fromJson(json['offset'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DoubleClickModelToJson(DoubleClickModel instance) =>
    <String, dynamic>{
      'origin': instance.origin,
      'locator': instance.locator,
      'offset': instance.offset,
    };
