import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/context_l10n.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/snackbars.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../groups/data/group_providers.dart';
import '../../groups/data/models/group_dto.dart';
import '../../groups/data/models/member_dto.dart';
import '../data/models/bill_dto.dart';
import '../domain/set_splits_use_case.dart';
import 'bill_view_model.dart';

class SplitScreen extends ConsumerStatefulWidget {
  const SplitScreen({super.key, required this.billId});

  final String billId;

  @override
  ConsumerState<SplitScreen> createState() => _SplitScreenState();
}

class _SplitScreenState extends ConsumerState<SplitScreen> {
  static const _useCase = SetSplitsUseCase();

  final Map<String, Set<String>> _selection = {};
  bool _defaultsScheduled = false;

  @override
  Widget build(BuildContext context) {
    final billAsync = ref.watch(billViewModelProvider(widget.billId));
    final l10n = context.l10n;

    ref.listen(billViewModelProvider(widget.billId), (prev, next) {
      final err = next.error;
      if (err != null) Snackbars.showError(context, err);
    });

    return billAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.splitScreenTitle)),
        body: ErrorView(
          message: e.toString(),
          onRetry: () => ref.read(billViewModelProvider(widget.billId).notifier).refresh(),
        ),
      ),
      data: (BillDto bill) {
        final groupAsync = ref.watch(groupDetailProvider(bill.groupId));
        return groupAsync.when(
          loading: () => Scaffold(
            body: SkeletonLoader(
              child: Center(child: Text(l10n.loadingText)),
            ),
          ),
          error: (e, _) => Scaffold(
            appBar: AppBar(title: Text(l10n.splitScreenTitle)),
            body: ErrorView(
              message: e.toString(),
              onRetry: () => ref.invalidate(groupDetailProvider(bill.groupId)),
            ),
          ),
          data: (GroupDto group) {
            _scheduleDefaultSelections(bill, group);

            final rows = _useCase.compute(bill: bill, selections: _selection);
            final totals = _useCase.totalsByUser(rows);

            return Scaffold(
              appBar: AppBar(title: Text(l10n.splitScreenTitle)),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: bill.items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final item = bill.items[index];
                        final line = item.price * item.quantity;
                        return _ItemSplitCard(
                          itemName: item.name,
                          lineTotalLabel: l10n.lineTotalLabel(
                            line.toStringAsFixed(2),
                          ),
                          members: group.members,
                          selected: _selection[item.id] ?? {},
                          onToggle: (userId, value) {
                            setState(() {
                              final set =
                                  _selection.putIfAbsent(item.id, () => <String>{});
                              if (value) {
                                set.add(userId);
                              } else {
                                set.remove(userId);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  _SummaryFooter(
                    l10n: l10n,
                    members: group.members,
                    totals: totals,
                    currency: bill.currency,
                    isBusy: billAsync.isLoading,
                    onDone: () => _submit(context, bill),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _scheduleDefaultSelections(BillDto bill, GroupDto group) {
    if (_defaultsScheduled) return;
    if (bill.items.isEmpty || group.members.isEmpty) return;
    _defaultsScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        for (final it in bill.items) {
          if (it.splits.isNotEmpty) {
            // Restore who pays for this line from the last saved split (server).
            _selection[it.id] = {for (final s in it.splits) s.userId};
          } else {
            _selection[it.id] = {for (final m in group.members) m.userId};
          }
        }
      });
    });
  }

  Future<void> _submit(BuildContext context, BillDto billDto) async {
    for (final item in billDto.items) {
      final line = item.price * item.quantity;
      if (line <= 0) continue;
      final sel = _selection[item.id] ?? {};
      if (sel.isEmpty) {
        Snackbars.showError(
          context,
          context.l10n.splitSelectAtLeastOnePerson(item.name),
        );
        return;
      }
    }

    final rows = _useCase.compute(bill: billDto, selections: _selection);
    try {
      await ref.read(billViewModelProvider(widget.billId).notifier).submitSplits(rows);
      if (!context.mounted) return;
      context.pushReplacement(AppRoutes.billResultPath(widget.billId));
    } catch (e) {
      if (!context.mounted) return;
      Snackbars.showError(context, e);
    }
  }
}

class _ItemSplitCard extends StatelessWidget {
  const _ItemSplitCard({
    required this.itemName,
    required this.lineTotalLabel,
    required this.members,
    required this.selected,
    required this.onToggle,
  });

  final String itemName;
  final String lineTotalLabel;
  final List<MemberDto> members;
  final Set<String> selected;
  final void Function(String userId, bool value) onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              itemName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(lineTotalLabel),
            const SizedBox(height: AppSpacing.sm),
            ...members.map((m) {
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: selected.contains(m.userId),
                onChanged: (v) => onToggle(m.userId, v ?? false),
                title: Text(m.name),
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SummaryFooter extends StatelessWidget {
  const _SummaryFooter({
    required this.l10n,
    required this.members,
    required this.totals,
    required this.currency,
    required this.isBusy,
    required this.onDone,
  });

  final AppLocalizations l10n;
  final List<MemberDto> members;
  final Map<String, num> totals;
  final String currency;
  final bool isBusy;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.summaryLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...members.map((m) {
                final t = totals[m.userId] ?? 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(m.name),
                      Text('${t.toStringAsFixed(2)} $currency'),
                    ],
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: l10n.doneButton,
                isLoading: isBusy,
                onPressed: isBusy ? null : onDone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
