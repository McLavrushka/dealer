// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupDto _$GroupDtoFromJson(Map<String, dynamic> json) => _GroupDto(
  id: json['id'] as String,
  name: json['name'] as String,
  ownerId: json['ownerId'] as String,
  inviteCode: json['inviteCode'] as String?,
  currency: json['currency'] as String,
  createdAt: json['createdAt'] as String,
  members:
      (json['members'] as List<dynamic>?)
          ?.map((e) => MemberDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MemberDto>[],
);

Map<String, dynamic> _$GroupDtoToJson(_GroupDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'ownerId': instance.ownerId,
  'inviteCode': instance.inviteCode,
  'currency': instance.currency,
  'createdAt': instance.createdAt,
  'members': instance.members.map((e) => e.toJson()).toList(),
};
