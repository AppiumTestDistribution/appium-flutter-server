// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../wait.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaitModel _$WaitModelFromJson(Map<String, dynamic> json) => WaitModel(
      element: json['element'] == null
          ? null
          : ElementModel.fromJson(json['element'] as Map<String, dynamic>),
      locator: json['locator'] == null
          ? null
          : FindElementModel.fromJson(json['locator'] as Map<String, dynamic>),
      timeout: WaitModel._durationFromJson((json['timeout'] as num?)?.toInt()),
    );

Map<String, dynamic> _$WaitModelToJson(WaitModel instance) => <String, dynamic>{
      'element': instance.element,
      'locator': instance.locator,
      'timeout': WaitModel._durationToJson(instance.timeout),
    };
