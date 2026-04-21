// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_bill_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateBillRequest _$CreateBillRequestFromJson(Map<String, dynamic> json) =>
    _CreateBillRequest(
      groupId: json['groupId'] as String,
      title: json['title'] as String,
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$CreateBillRequestToJson(_CreateBillRequest instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'title': instance.title,
      'currency': instance.currency,
    };
