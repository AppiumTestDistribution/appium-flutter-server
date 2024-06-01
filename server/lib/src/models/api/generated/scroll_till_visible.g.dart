// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../scroll_till_visible.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScrollTillVisibleModel _$ScrollTillVisibleModelFromJson(
        Map<String, dynamic> json) =>
    ScrollTillVisibleModel(
      finder: FindElementModel.fromJson(json['finder'] as Map<String, dynamic>),
      scrollView: json['scrollView'] == null
          ? null
          : FindElementModel.fromJson(
              json['scrollView'] as Map<String, dynamic>),
      delta: (json['delta'] as num?)?.toDouble(),
      scrollDirection:
          $enumDecodeNullable(_$AxisDirectionEnumMap, json['scrollDirection']),
      settleBetweenScrollsTimeout:
          (json['settleBetweenScrollsTimeout'] as num?)?.toInt(),
      dragDuration: (json['dragDuration'] as num?)?.toInt(),
    )..maxScrolls = (json['maxScrolls'] as num?)?.toInt();

Map<String, dynamic> _$ScrollTillVisibleModelToJson(
        ScrollTillVisibleModel instance) =>
    <String, dynamic>{
      'finder': instance.finder,
      'scrollView': instance.scrollView,
      'delta': instance.delta,
      'scrollDirection': _$AxisDirectionEnumMap[instance.scrollDirection],
      'maxScrolls': instance.maxScrolls,
      'settleBetweenScrollsTimeout': instance.settleBetweenScrollsTimeout,
      'dragDuration': instance.dragDuration,
    };

const _$AxisDirectionEnumMap = {
  AxisDirection.up: 'up',
  AxisDirection.right: 'right',
  AxisDirection.down: 'down',
  AxisDirection.left: 'left',
};
