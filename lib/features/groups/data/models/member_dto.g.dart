// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemberDto _$MemberDtoFromJson(Map<String, dynamic> json) => _MemberDto(
  userId: json['userId'] as String,
  name: json['name'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$MemberDtoToJson(_MemberDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'role': instance.role,
    };
