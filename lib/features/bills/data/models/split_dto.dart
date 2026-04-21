import 'package:freezed_annotation/freezed_annotation.dart';

part 'split_dto.freezed.dart';
part 'split_dto.g.dart';

@freezed
abstract class SplitDto with _$SplitDto {
  const factory SplitDto({
    required String id,
    required String userId,
    required num shareAmount,
  }) = _SplitDto;

  factory SplitDto.fromJson(Map<String, dynamic> json) => _$SplitDtoFromJson(json);
}

