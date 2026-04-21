// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InviteResponse _$InviteResponseFromJson(Map<String, dynamic> json) =>
    _InviteResponse(
      inviteCode: json['inviteCode'] as String,
      deepLink: json['deepLink'] as String,
    );

Map<String, dynamic> _$InviteResponseToJson(_InviteResponse instance) =>
    <String, dynamic>{
      'inviteCode': instance.inviteCode,
      'deepLink': instance.deepLink,
    };
