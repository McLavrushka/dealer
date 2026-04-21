import 'package:freezed_annotation/freezed_annotation.dart';

part 'invite_response.freezed.dart';
part 'invite_response.g.dart';

@freezed
abstract class InviteResponse with _$InviteResponse {
  const factory InviteResponse({
    required String inviteCode,
    required String deepLink,
  }) = _InviteResponse;

  factory InviteResponse.fromJson(Map<String, dynamic> json) =>
      _$InviteResponseFromJson(json);
}

