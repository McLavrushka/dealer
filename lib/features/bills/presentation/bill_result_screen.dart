import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/l10n/context_l10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/snackbars.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../groups/data/group_providers.dart';
import '../../groups/data/models/group_dto.dart';
import '../data/models/bill_dto.dart';
import 'bill_view_model.dart';

class BillResultScreen extends ConsumerWidget {
  const BillResultScreen({super.key, required this.billId});

  final String billId;

  static Map<String, num> _totalsFromSplits(BillDto bill) {
    final m = <String, num>{};
    for (final it in bill.items) {
      for (final s in it.splits) {
        m[s.userId] = (m[s.userId] ?? 0) + s.shareAmount;
      }
    }
    return m;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billState = ref.watch(billViewModelProvider(billId));
    final l10n = context.l10n;

    ref.listen(billViewModelProvider(billId), (prev, next) {
      final err = next.error;
      if (err != null) Snackbars.showError(context, err);
    });

    return billState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.resultTitle)),
        body: ErrorView(
          message: e.toString(),
          onRetry: () => ref.read(billViewModelProvider(billId).notifier).refresh(),
        ),
      ),
      data: (BillDto bill) {
        final totals = _totalsFromSplits(bill);
        final groupAsync = ref.watch(groupDetailProvider(bill.groupId));

        return groupAsync.when(
          loading: () => Scaffold(
            body: SkeletonLoader(
              child: Center(child: Text(l10n.loadingText)),
            ),
          ),
          error: (e, _) => Scaffold(
            appBar: AppBar(title: Text(l10n.resultTitle)),
            body: ErrorView(
              message: e.toString(),
              onRetry: () => ref.invalidate(groupDetailProvider(bill.groupId)),
            ),
          ),
          data: (GroupDto group) {
            final settled =
                bill.status.toUpperCase().contains('SETTLED') ||
                    bill.status.toUpperCase().contains('CLOSED');
            return Scaffold(
              appBar: AppBar(
                title: Text(l10n.billSummaryTitle),
                leading: IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => context.go(AppRoutes.groupPath(bill.groupId)),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.casino_rounded),
                    tooltip: l10n.whoPaysTooltip,
                    onPressed: () =>
                        context.push(AppRoutes.billRoulettePath(billId)),
                  ),
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  Text(
                    bill.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text('${bill.total} ${bill.currency} • ${bill.status}'),
                  const SizedBox(height: AppSpacing.lg),
                  ...group.members.map((m) {
                    final t = totals[m.userId] ?? 0;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(m.name),
                      trailing: Text('${t.toStringAsFixed(2)} ${bill.currency}'),
                    );
                  }),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: l10n.changeSplitButton,
                    variant: AppButtonVariant.secondary,
                    onPressed: settled || billState.isLoading
                        ? null
                        : () => context.push(AppRoutes.billSplitPath(billId)),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: l10n.settleBillButton,
                    onPressed: billState.isLoading || settled
                        ? null
                        : () async {
                            try {
                              await ref
                                  .read(billViewModelProvider(billId).notifier)
                                  .settle();
                              if (!context.mounted) return;
                              Snackbars.showSuccess(context, l10n.billSettledMessage);
                            } catch (e) {
                              if (!context.mounted) return;
                              Snackbars.showError(context, e);
                            }
                          },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(
                    label: l10n.shareButton,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => _share(context, bill, group, totals),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _share(
    BuildContext context,
    BillDto bill,
    GroupDto group,
    Map<String, num> totals,
  ) async {
    final buf = StringBuffer()
      ..writeln(bill.title)
      ..writeln('${bill.total} ${bill.currency} (${bill.status})')
      ..writeln();
    for (final m in group.members) {
      final t = totals[m.userId] ?? 0;
      buf.writeln('${m.name}: ${t.toStringAsFixed(2)} ${bill.currency}');
    }
    await Share.share(buf.toString());
    if (!context.mounted) return;
  }
}
