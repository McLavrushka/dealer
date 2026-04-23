import 'package:freezed_annotation/freezed_annotation.dart';

import 'member_dto.dart';

part 'group_dto.freezed.dart';
part 'group_dto.g.dart';

@freezed
abstract class GroupDto with _$GroupDto {
  const factory GroupDto({
    required String id,
    required String name,
    required String ownerId,
    String? inviteCode,
    required String currency,
    required String createdAt,
    @Default(<MemberDto>[]) List<MemberDto> members,
  }) = _GroupDto;

  factory GroupDto.fromJson(Map<String, dynamic> json) =>
      _$GroupDtoFromJson(json);
}

