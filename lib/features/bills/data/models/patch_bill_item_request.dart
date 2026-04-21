import 'package:freezed_annotation/freezed_annotation.dart';

part 'patch_bill_item_request.freezed.dart';
part 'patch_bill_item_request.g.dart';

@freezed
abstract class PatchBillItemRequest with _$PatchBillItemRequest {
  const factory PatchBillItemRequest({
    String? name,
    num? price,
    num? quantity,
  }) = _PatchBillItemRequest;

  factory PatchBillItemRequest.fromJson(Map<String, dynamic> json) =>
      _$PatchBillItemRequestFromJson(json);
}
