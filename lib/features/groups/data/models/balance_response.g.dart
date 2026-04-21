// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BalanceUserDto _$BalanceUserDtoFromJson(Map<String, dynamic> json) =>
    _BalanceUserDto(
      userId: json['userId'] as String,
      name: json['name'] as String,
      balance: json['balance'] as num,
    );

Map<String, dynamic> _$BalanceUserDtoToJson(_BalanceUserDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'balance': instance.balance,
    };

_BalanceResponse _$BalanceResponseFromJson(Map<String, dynamic> json) =>
    _BalanceResponse(
      groupId: json['groupId'] as String,
      balances:
          (json['balances'] as List<dynamic>?)
              ?.map((e) => BalanceUserDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <BalanceUserDto>[],
    );

Map<String, dynamic> _$BalanceResponseToJson(_BalanceResponse instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'balances': instance.balances.map((e) => e.toJson()).toList(),
    };
