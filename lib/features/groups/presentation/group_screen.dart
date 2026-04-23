import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/l10n/context_l10n.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/snackbars.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../bills/data/models/bill_dto.dart';
import '../../bills/presentation/widgets/create_bill_sheet.dart';
import '../data/group_providers.dart';
import '../data/models/group_dto.dart';
import 'group_view_model.dart';
import 'groups_view_model.dart';

class GroupScreen extends ConsumerWidget {
  const GroupScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(groupViewModelProvider(groupId), (prev, next) {
      if (next.hasError && next.error != null) {
        Snackbars.showError(context, next.error!);
      }
      final data = next.valueOrNull;
      if (data != null) {
        ref.read(groupsViewModelProvider.notifier).upsertCached(data.group);
      }
    });

    final state = ref.watch(groupViewModelProvider(groupId));
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: state.valueOrNull == null
            ? Text(l10n.groupFallbackTitle)
            : Text(state.value!.group.name),
      ),
      body: SafeArea(
        child: state.when(
          loading: () => const SkeletonLoader(child: _GroupSkeleton()),
          error: (e, _) => ErrorView(
            message: e.toString(),
            onRetry: () => ref.read(groupViewModelProvider(groupId).notifier).refresh(),
          ),
          data: (data) {
            final group = data.group;
            final balances = data.balance.balances;
            final bills = data.bills;

            return RefreshIndicator(
              onRefresh: () => ref.read(groupViewModelProvider(groupId).notifier).refresh(),
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  _Header(
                    group: group,
                    l10n: l10n,
                    onInvite: () => _invite(context, ref, groupId),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.balanceSectionTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (balances.isEmpty)
                    EmptyState(
                      title: l10n.noBalanceTitle,
                      message: l10n.noBalanceMessage,
                    )
                  else
                    ...balances.map((b) {
                      final sign = b.balance >= 0 ? '+' : '−';
                      final abs = b.balance.abs();
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(b.name),
                        trailing: Text('$sign${abs.toStringAsFixed(2)}'),
                      );
                    }),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.billsSectionTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (bills.isEmpty)
                    EmptyState(
                      title: l10n.noBillsTitle,
                      message: l10n.noBillsMessage,
                    )
                  else
                    ...bills.map((bill) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(bill.title),
                        subtitle: Text(
                          '${bill.total.toStringAsFixed(2)} ${bill.currency}',
                        ),
                        trailing: IconButton(
                          tooltip: l10n.deleteBillTooltip,
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () => _deleteBill(
                            context,
                            ref,
                            groupId,
                            bill,
                          ),
                        ),
                        onTap: () async {
                          await context.push(AppRoutes.billPath(bill.id));
                          if (!context.mounted) return;
                          // Bills list payload often contains stale totals (e.g. 0) until refreshed.
                          await ref
                              .read(groupViewModelProvider(groupId).notifier)
                              .refresh();
                        },
                      );
                    }),
                  const SizedBox(height: 96),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: AppButton(
            label: l10n.addBillButton,
            onPressed: state.valueOrNull == null
                ? null
                : () {
                    final g = state.value!.group;
                    showCreateBillSheet(
                      context: context,
                      ref: ref,
                      groupId: g.id,
                      currency: g.currency,
                    );
                  },
          ),
        ),
      ),
    );
  }

  Future<void> _deleteBill(
    BuildContext context,
    WidgetRef ref,
    String gid,
    BillDto bill,
  ) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteBillDialogTitle),
        content: Text(l10n.deleteBillDialogContent(bill.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.deleteButton),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(groupViewModelProvider(gid).notifier).deleteBill(bill.id);
    } catch (e) {
      if (!context.mounted) return;
      Snackbars.showError(context, e);
    }
  }

  Future<void> _invite(BuildContext context, WidgetRef ref, String id) async {
    final l10n = context.l10n;
    try {
      final repo = ref.read(groupRepositoryProvider);
      final invite = await repo.invite(id);
      await ref.read(groupViewModelProvider(groupId).notifier).applyInviteFromServer(invite);
      if (!context.mounted) return;
      await Share.share(
        l10n.shareGroupInviteBody(invite.inviteCode),
      );
    } catch (e) {
      if (!context.mounted) return;
      Snackbars.showError(context, e);
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.group,
    required this.l10n,
    required this.onInvite,
  });

  final GroupDto group;
  final AppLocalizations l10n;
  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    final inviteCode = group.inviteCode?.trim();
    final hasInviteCode = inviteCode != null && inviteCode.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          group.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.membersCurrencyLine(group.members.length, group.currency),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: Text(
                hasInviteCode
                    ? l10n.inviteCodeRow(inviteCode)
                    : l10n.inviteCodeEmpty,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            IconButton(
              tooltip: hasInviteCode
                  ? l10n.copyInviteCodeTooltip
                  : l10n.noInviteCodeTooltip,
              onPressed: hasInviteCode
                  ? () async {
                      await Clipboard.setData(
                        ClipboardData(text: inviteCode),
                      );
                      if (!context.mounted) return;
                      Snackbars.showSuccess(context, l10n.inviteCodeCopiedSnackbar);
                    }
                  : null,
              icon: const Icon(Icons.copy),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: l10n.inviteButton,
          variant: AppButtonVariant.secondary,
          onPressed: onInvite,
        ),
      ],
    );
  }
}

class _GroupSkeleton extends StatelessWidget {
  const _GroupSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: const [
        SkeletonBox(height: 32, width: 220),
        SizedBox(height: AppSpacing.xs),
        SkeletonBox(height: 18, width: 160),
        SizedBox(height: AppSpacing.md),
        SkeletonBox(height: 44),
        SizedBox(height: AppSpacing.lg),
        SkeletonBox(height: 22, width: 120),
        SizedBox(height: AppSpacing.sm),
        SkeletonBox(height: 56),
        SizedBox(height: AppSpacing.sm),
        SkeletonBox(height: 56),
        SizedBox(height: AppSpacing.lg),
        SkeletonBox(height: 22, width: 90),
        SizedBox(height: AppSpacing.sm),
        SkeletonBox(height: 56),
        SizedBox(height: AppSpacing.sm),
        SkeletonBox(height: 56),
      ],
    );
  }
}

