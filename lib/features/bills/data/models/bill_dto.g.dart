// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BillDto _$BillDtoFromJson(Map<String, dynamic> json) => _BillDto(
  id: json['id'] as String,
  groupId: json['groupId'] as String,
  title: json['title'] as String,
  total: json['total'] as num,
  currency: json['currency'] as String,
  status: json['status'] as String,
  receiptUrl: json['receiptUrl'] as String?,
  spunWinnerId: json['spunWinnerId'] as String?,
  createdAt: json['createdAt'] as String,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => BillItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <BillItemDto>[],
);

Map<String, dynamic> _$BillDtoToJson(_BillDto instance) => <String, dynamic>{
  'id': instance.id,
  'groupId': instance.groupId,
  'title': instance.title,
  'total': instance.total,
  'currency': instance.currency,
  'status': instance.status,
  'receiptUrl': instance.receiptUrl,
  'spunWinnerId': instance.spunWinnerId,
  'createdAt': instance.createdAt,
  'items': instance.items.map((e) => e.toJson()).toList(),
};
