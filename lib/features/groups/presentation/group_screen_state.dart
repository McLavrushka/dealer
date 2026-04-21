import '../../bills/data/models/bill_dto.dart';
import '../data/models/balance_response.dart';
import '../data/models/group_dto.dart';

class GroupScreenState {
  const GroupScreenState({
    required this.group,
    required this.balance,
    required this.bills,
  });

  final GroupDto group;
  final BalanceResponse balance;
  final List<BillDto> bills;

  GroupScreenState copyWith({
    GroupDto? group,
    BalanceResponse? balance,
    List<BillDto>? bills,
  }) {
    return GroupScreenState(
      group: group ?? this.group,
      balance: balance ?? this.balance,
      bills: bills ?? this.bills,
    );
  }
}

