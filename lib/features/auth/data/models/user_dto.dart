// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

/// Backend may use camelCase or snake_case for optional user fields.
Object? _readAvatarUrl(Map json, String key) =>
    json['avatarUrl'] ?? json['avatar_url'];

Object? _readCurrencyDefault(Map json, String key) =>
    json['currencyDefault'] ?? json['currency_default'];

Object? _readTransferComment(Map json, String key) =>
    json['transferComment'] ?? json['transfer_comment'];

@freezed
abstract class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String name,
    required String email,
    @JsonKey(readValue: _readAvatarUrl) String? avatarUrl,
    @JsonKey(readValue: _readCurrencyDefault) String? currencyDefault,
    @JsonKey(readValue: _readTransferComment) String? transferComment,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
}

