import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../bills/data/bill_providers.dart';
import '../data/group_providers.dart';
import '../data/models/invite_response.dart';
import 'group_screen_state.dart';
import 'groups_view_model.dart';

part 'group_view_model.g.dart';

@riverpod
class GroupViewModel extends _$GroupViewModel {
  @override
  Future<GroupScreenState> build(String groupId) async {
    final repo = ref.watch(groupRepositoryProvider);

    final group = await repo.getById(groupId);
    final balance = await repo.balance(groupId);
    final bills = await repo.bills(groupId);

    return GroupScreenState(group: group, balance: balance, bills: bills);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(groupId));
  }

  /// DELETE /api/v1/bills/{id} — removes the bill from this group’s list.
  Future<void> deleteBill(String billId) async {
    await ref.read(billRepositoryProvider).delete(billId);
    final cur = state.valueOrNull;
    if (cur == null) return;
    state = AsyncValue.data(
      cur.copyWith(
        bills: cur.bills.where((b) => b.id != billId).toList(),
      ),
    );
  }

  /// Keeps UI + groups cache aligned with the latest code from [POST /groups/{id}/invite].
  Future<void> applyInviteFromServer(InviteResponse invite) async {
    final cur = state.valueOrNull;
    if (cur == null) return;

    final nextGroup = cur.group.copyWith(inviteCode: invite.inviteCode);
    state = AsyncValue.data(cur.copyWith(group: nextGroup));
    await ref.read(groupsViewModelProvider.notifier).upsertCached(nextGroup);
  }
}

