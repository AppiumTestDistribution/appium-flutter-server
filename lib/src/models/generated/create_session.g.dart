// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../create_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSession _$CreateSessionFromJson(Map<String, dynamic> json) =>
    CreateSession(
      (json['capabilities'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, e as Object),
      ),
    );

Map<String, dynamic> _$CreateSessionToJson(CreateSession instance) =>
    <String, dynamic>{
      'capabilities': instance.capabilities,
    };
