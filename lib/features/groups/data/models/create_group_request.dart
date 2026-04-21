import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_group_request.freezed.dart';
part 'create_group_request.g.dart';

@freezed
abstract class CreateGroupRequest with _$CreateGroupRequest {
  const factory CreateGroupRequest({
    required String name,
    required String currency,
  }) = _CreateGroupRequest;

  factory CreateGroupRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateGroupRequestFromJson(json);
}

