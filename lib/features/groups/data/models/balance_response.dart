import 'package:freezed_annotation/freezed_annotation.dart';

part 'balance_response.freezed.dart';
part 'balance_response.g.dart';

@freezed
abstract class BalanceUserDto with _$BalanceUserDto {
  const factory BalanceUserDto({
    required String userId,
    required String name,
    required num balance,
  }) = _BalanceUserDto;

  factory BalanceUserDto.fromJson(Map<String, dynamic> json) =>
      _$BalanceUserDtoFromJson(json);
}

@freezed
abstract class BalanceResponse with _$BalanceResponse {
  const factory BalanceResponse({
    required String groupId,
    @Default(<BalanceUserDto>[]) List<BalanceUserDto> balances,
  }) = _BalanceResponse;

  factory BalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$BalanceResponseFromJson(json);
}

