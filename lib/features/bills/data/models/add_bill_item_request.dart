import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_bill_item_request.freezed.dart';
part 'add_bill_item_request.g.dart';

@freezed
abstract class AddBillItemRequest with _$AddBillItemRequest {
  const factory AddBillItemRequest({
    required String name,
    required num price,
    required num quantity,
  }) = _AddBillItemRequest;

  factory AddBillItemRequest.fromJson(Map<String, dynamic> json) =>
      _$AddBillItemRequestFromJson(json);
}
