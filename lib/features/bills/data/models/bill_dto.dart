import 'package:freezed_annotation/freezed_annotation.dart';

import 'bill_item_dto.dart';

part 'bill_dto.freezed.dart';
part 'bill_dto.g.dart';

@freezed
abstract class BillDto with _$BillDto {
  const factory BillDto({
    required String id,
    required String groupId,
    required String title,
    required num total,
    required String currency,
    required String status,
    String? receiptUrl,
    String? spunWinnerId,
    required String createdAt,
    @Default(<BillItemDto>[]) List<BillItemDto> items,
  }) = _BillDto;

  factory BillDto.fromJson(Map<String, dynamic> json) => _$BillDtoFromJson(json);
}

