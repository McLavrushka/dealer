import 'models/balance_response.dart';
import 'models/create_group_request.dart';
import 'models/group_dto.dart';
import 'models/invite_response.dart';

import '../../bills/data/models/bill_dto.dart';

abstract interface class GroupRepository {
  Future<GroupDto> create(CreateGroupRequest request);
  Future<GroupDto> join(String code);
  Future<GroupDto> getById(String id);
  Future<GroupDto> update(String id, {String? name, String? currency});
  Future<void> delete(String id);

  Future<InviteResponse> invite(String id);
  Future<List<BillDto>> bills(String id);
  Future<BalanceResponse> balance(String id);

  Future<void> removeMember(String id, String userId);
}

