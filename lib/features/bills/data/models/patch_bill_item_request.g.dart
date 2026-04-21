// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_bill_item_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PatchBillItemRequest _$PatchBillItemRequestFromJson(
  Map<String, dynamic> json,
) => _PatchBillItemRequest(
  name: json['name'] as String?,
  price: json['price'] as num?,
  quantity: json['quantity'] as num?,
);

Map<String, dynamic> _$PatchBillItemRequestToJson(
  _PatchBillItemRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'price': instance.price,
  'quantity': instance.quantity,
};
