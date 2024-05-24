// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../find_element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindElementModel _$FindElementModelFromJson(Map<String, dynamic> json) =>
    FindElementModel(
      strategy: json['strategy'] as String,
      selector: json['selector'] as String,
      context: json['context'] as String?,
    );

Map<String, dynamic> _$FindElementModelToJson(FindElementModel instance) =>
    <String, dynamic>{
      'strategy': instance.strategy,
      'selector': instance.selector,
      'context': instance.context,
    };
