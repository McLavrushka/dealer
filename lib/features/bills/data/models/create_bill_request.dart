import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_bill_request.freezed.dart';
part 'create_bill_request.g.dart';

@freezed
abstract class CreateBillRequest with _$CreateBillRequest {
  const factory CreateBillRequest({
    required String groupId,
    required String title,
    required String currency,
  }) = _CreateBillRequest;

  factory CreateBillRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBillRequestFromJson(json);
}
