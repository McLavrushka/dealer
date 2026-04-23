// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BillItemDto _$BillItemDtoFromJson(Map<String, dynamic> json) => _BillItemDto(
  id: json['id'] as String,
  name: json['name'] as String,
  price: json['price'] as num,
  quantity: json['quantity'] as num,
  splits:
      (json['splits'] as List<dynamic>?)
          ?.map((e) => SplitDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SplitDto>[],
);

Map<String, dynamic> _$BillItemDtoToJson(_BillItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'splits': instance.splits.map((e) => e.toJson()).toList(),
    };
