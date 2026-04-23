import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/context_l10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/storage/hive_service.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/snackbars.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../domain/join_invite_code.dart';
import 'groups_view_model.dart';

/// Deep link `/join?code=` — user confirms and joins the group.
class JoinFromLinkScreen extends ConsumerStatefulWidget {
  const JoinFromLinkScreen({super.key, this.initialCode});

  /// From query `?code=` or path `/join/:code`.
  final String? initialCode;

  @override
  ConsumerState<JoinFromLinkScreen> createState() => _JoinFromLinkScreenState();
}

class _JoinFromLinkScreenState extends ConsumerState<JoinFromLinkScreen> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final raw = widget.initialCode?.trim();
    if (raw != null && raw.isNotEmpty) {
      _code.text = JoinInviteCode.extract(raw);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        HiveService.instance.clearPendingInviteCode();
      });
    }
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.joinGroupSheetTitle),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go(AppRoutes.groups),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.joinFromLinkIntro,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: _code,
                  label: l10n.inviteCodeLabel,
                  hint: l10n.inviteCodeHint,
                  validator: (v) => Validators.requiredField(l10n, v),
                  enabled: !_loading,
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: l10n.joinButton,
                  isLoading: _loading,
                  onPressed: _loading ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      final joined = await ref.read(groupsViewModelProvider.notifier).joinGroup(
            code: _code.text,
          );
      if (!mounted) return;
      context.go(AppRoutes.groupPath(joined.id));
    } catch (e) {
      if (mounted) Snackbars.showError(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
