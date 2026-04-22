import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/context_l10n.dart';
import '../../../core/network/dio_error_user_message.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/snackbars.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton_loader.dart';
import 'groups_view_model.dart';
import 'widgets/group_card.dart';

class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(groupsViewModelProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.groupsTitle),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.notifications),
            icon: const Icon(Icons.notifications_outlined),
            tooltip: l10n.notificationsTooltip,
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.profile),
            icon: const Icon(Icons.person_outline_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openActions(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: state.when(
          loading: () => const SkeletonList(),
          error: (e, _) => ErrorView(
            message: userMessageForApiError(e),
            onRetry: () => ref.read(groupsViewModelProvider.notifier).refresh(),
          ),
          data: (groups) {
            if (groups.isEmpty) {
              return EmptyState(
                icon: Icons.group_outlined,
                title: l10n.noGroupsTitle,
                message: l10n.noGroupsMessage,
                actionLabel: l10n.addGroupButton,
                onAction: () => _openActions(context, ref),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: groups.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final group = groups[index];
                return GroupCard(
                  group: group,
                  onTap: () => context.push('/groups/${group.id}'),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _openActions(BuildContext context, WidgetRef ref) async {
    final action = await showModalBottomSheet<_GroupsAction>(
      context: context,
      showDragHandle: true,
      builder: (_) => const _GroupsActionsSheet(),
    );
    if (action == null || !context.mounted) return;

    switch (action) {
      case _GroupsAction.create:
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => _CreateGroupSheet(ref: ref),
        );
      case _GroupsAction.join:
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => _JoinGroupSheet(ref: ref, parentContext: context),
        );
    }
  }
}

enum _GroupsAction { create, join }

class _GroupsActionsSheet extends StatelessWidget {
  const _GroupsActionsSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.create_new_folder_outlined),
              title: Text(l10n.createGroupMenu),
              onTap: () => Navigator.of(context).pop(_GroupsAction.create),
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_2_rounded),
              title: Text(l10n.joinByCodeMenu),
              onTap: () => Navigator.of(context).pop(_GroupsAction.join),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateGroupSheet extends ConsumerStatefulWidget {
  const _CreateGroupSheet({required this.ref});

  final WidgetRef ref;

  @override
  ConsumerState<_CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends ConsumerState<_CreateGroupSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _currency = TextEditingController(text: 'RUB');
  bool _isLoading = false;

  @override
  void dispose() {
    _name.dispose();
    _currency.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, bottom),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.createGroupSheetTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _name,
                label: l10n.nameLabel,
                validator: (v) => Validators.requiredField(l10n, v),
                enabled: !_isLoading,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _currency,
                label: l10n.currencyLabel,
                hint: l10n.currencyCodeHint,
                validator: (v) => Validators.requiredField(l10n, v),
                enabled: !_isLoading,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: l10n.createButton,
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _submit,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(groupsViewModelProvider.notifier).createGroup(
            name: _name.text.trim(),
            currency: _currency.text.trim().toUpperCase(),
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) Snackbars.showError(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class _JoinGroupSheet extends ConsumerStatefulWidget {
  const _JoinGroupSheet({
    required this.ref,
    required this.parentContext,
  });

  final WidgetRef ref;
  /// [GroupsScreen] context — still valid after the sheet is popped (unlike the
  /// sheet’s own [BuildContext] for [GoRouter.push]).
  final BuildContext parentContext;

  @override
  ConsumerState<_JoinGroupSheet> createState() => _JoinGroupSheetState();
}

class _JoinGroupSheetState extends ConsumerState<_JoinGroupSheet> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, bottom),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.joinGroupSheetTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _code,
                label: l10n.inviteCodeLabel,
                hint: l10n.inviteCodeHint,
                validator: (v) => Validators.requiredField(l10n, v),
                enabled: !_isLoading,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: l10n.joinButton,
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _submit,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() => _isLoading = true);
    try {
      final joined = await ref.read(groupsViewModelProvider.notifier).joinGroup(
            code: _code.text,
          );
      if (!mounted) return;
      final groupId = joined.id;
      final parent = widget.parentContext;
      Navigator.of(context).pop();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!parent.mounted) return;
        GoRouter.of(parent).push(AppRoutes.groupPath(groupId));
      });
    } catch (e) {
      if (mounted) Snackbars.showError(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

