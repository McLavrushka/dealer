import 'package:freezed_annotation/freezed_annotation.dart';

import 'split_dto.dart';

part 'bill_item_dto.freezed.dart';
part 'bill_item_dto.g.dart';

@freezed
abstract class BillItemDto with _$BillItemDto {
  const factory BillItemDto({
    required String id,
    required String name,
    required num price,
    required num quantity,
    @Default(<SplitDto>[]) List<SplitDto> splits,
  }) = _BillItemDto;

  factory BillItemDto.fromJson(Map<String, dynamic> json) =>
      _$BillItemDtoFromJson(json);
}

