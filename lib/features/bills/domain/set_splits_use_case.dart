import '../data/models/bill_dto.dart';

/// Computes equal per-user shares for each line item (in currency units).
class SetSplitsUseCase {
  const SetSplitsUseCase();

  /// [selections] maps itemId -> selected userIds (must be non-empty for included items).
  List<SplitSubmitRow> compute({
    required BillDto bill,
    required Map<String, Set<String>> selections,
  }) {
    final out = <SplitSubmitRow>[];

    for (final item in bill.items) {
      final users = (selections[item.id] ?? {}).toList()..sort();
      if (users.isEmpty) continue;

      final lineTotal = item.price * item.quantity;
      if (lineTotal <= 0) continue;

      final cents = (lineTotal * 100).round();
      final n = users.length;
      final base = cents ~/ n;
      var remainder = cents % n;

      for (var i = 0; i < n; i++) {
        final add = remainder > 0 ? 1 : 0;
        if (remainder > 0) remainder--;
        final shareCents = base + add;
        out.add(
          SplitSubmitRow(
            itemId: item.id,
            userId: users[i],
            shareAmount: shareCents / 100,
          ),
        );
      }
    }

    return out;
  }

  Map<String, num> totalsByUser(List<SplitSubmitRow> rows) {
    final m = <String, num>{};
    for (final r in rows) {
      m[r.userId] = (m[r.userId] ?? 0) + r.shareAmount;
    }
    return m;
  }
}

class SplitSubmitRow {
  const SplitSubmitRow({
    required this.itemId,
    required this.userId,
    required this.shareAmount,
  });

  final String itemId;
  final String userId;
  final num shareAmount;

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'userId': userId,
        'shareAmount': shareAmount,
      };
}
