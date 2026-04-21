import 'package:dio/dio.dart';

import '../../../core/network/api_config.dart';
import '../../bills/data/models/bill_dto.dart';
import '../domain/join_invite_code.dart';
import 'group_repository.dart';
import 'models/balance_response.dart';
import 'models/create_group_request.dart';
import 'models/group_dto.dart';
import 'models/invite_response.dart';

class GroupRepositoryImpl implements GroupRepository {
  GroupRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<GroupDto> create(CreateGroupRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${ApiConfig.apiV1}/groups',
      data: request.toJson(),
    );
    return GroupDto.fromJson(response.data!);
  }

  @override
  Future<GroupDto> join(String code) async {
    final safeCode = Uri.encodeComponent(JoinInviteCode.normalize(code));
    final response = await _dio.post<Map<String, dynamic>>(
      '${ApiConfig.apiV1}/groups/join/$safeCode',
    );
    return GroupDto.fromJson(response.data!);
  }

  @override
  Future<GroupDto> getById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConfig.apiV1}/groups/$id',
    );
    return GroupDto.fromJson(response.data!);
  }

  @override
  Future<GroupDto> update(String id, {String? name, String? currency}) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '${ApiConfig.apiV1}/groups/$id',
      data: {
        if (name != null) 'name': name,
        if (currency != null) 'currency': currency,
      },
    );
    return GroupDto.fromJson(response.data!);
  }

  @override
  Future<void> delete(String id) async {
    await _dio.delete<void>('${ApiConfig.apiV1}/groups/$id');
  }

  @override
  Future<InviteResponse> invite(String id) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${ApiConfig.apiV1}/groups/$id/invite',
    );
    return InviteResponse.fromJson(response.data!);
  }

  @override
  Future<List<BillDto>> bills(String id) async {
    final response = await _dio.get<List<dynamic>>(
      '${ApiConfig.apiV1}/groups/$id/bills',
    );
    final list = response.data ?? const [];
    return list
        .whereType<Map>()
        .map((e) => BillDto.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<BalanceResponse> balance(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConfig.apiV1}/groups/$id/balance',
    );
    return BalanceResponse.fromJson(response.data!);
  }

  @override
  Future<void> removeMember(String id, String userId) async {
    await _dio.delete<void>('${ApiConfig.apiV1}/groups/$id/members/$userId');
  }
}

