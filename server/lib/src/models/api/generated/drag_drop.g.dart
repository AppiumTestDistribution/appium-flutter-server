// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../drag_drop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DragAndDropModel _$DragAndDropModelFromJson(Map<String, dynamic> json) =>
    DragAndDropModel(
      source: ElementModel.fromJson(json['source'] as Map<String, dynamic>),
      target: ElementModel.fromJson(json['target'] as Map<String, dynamic>),
      dragDuration: (json['dragDuration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DragAndDropModelToJson(DragAndDropModel instance) =>
    <String, dynamic>{
      'source': instance.source,
      'target': instance.target,
      'dragDuration': instance.dragDuration,
    };
