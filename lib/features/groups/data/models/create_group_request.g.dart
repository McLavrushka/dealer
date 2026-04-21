// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_group_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateGroupRequest _$CreateGroupRequestFromJson(Map<String, dynamic> json) =>
    _CreateGroupRequest(
      name: json['name'] as String,
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$CreateGroupRequestToJson(_CreateGroupRequest instance) =>
    <String, dynamic>{'name': instance.name, 'currency': instance.currency};
