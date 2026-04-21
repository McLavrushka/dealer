// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_bill_item_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddBillItemRequest _$AddBillItemRequestFromJson(Map<String, dynamic> json) =>
    _AddBillItemRequest(
      name: json['name'] as String,
      price: json['price'] as num,
      quantity: json['quantity'] as num,
    );

Map<String, dynamic> _$AddBillItemRequestToJson(_AddBillItemRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
    };
