import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/context_l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/snackbars.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/bill_providers.dart';
import '../../data/models/create_bill_request.dart';
import '../../../groups/presentation/group_view_model.dart';

Future<void> showCreateBillSheet({
  required BuildContext context,
  required WidgetRef ref,
  required String groupId,
  required String currency,
}) {
  final parentContext = context;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => _CreateBillOptions(
      ref: ref,
      parentContext: parentContext,
      groupId: groupId,
      currency: currency,
    ),
  );
}

class _CreateBillOptions extends StatelessWidget {
  const _CreateBillOptions({
    required this.ref,
    required this.parentContext,
    required this.groupId,
    required this.currency,
  });

  final WidgetRef ref;
  final BuildContext parentContext;
  final String groupId;
  final String currency;

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.newBillSheetTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (kIsWeb) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: Text(
                  l10n.scanningMobileOnlyBanner,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            if (!kIsWeb) ...[
              ListTile(
                leading: const Icon(Icons.qr_code_scanner_rounded),
                title: Text(l10n.scanReceiptQrOption),
                onTap: () => _createBillAndOpenScan(sheetContext: context),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(l10n.photoReceiptOcrOption),
                onTap: () => _createBillAndOpenScan(
                  sheetContext: context,
                  openOcrTab: true,
                ),
              ),
            ],
            ListTile(
              leading: const Icon(Icons.edit_note_rounded),
              title: Text(l10n.enterManuallyOption),
              onTap: () async {
                Navigator.of(context).pop();
                if (!parentContext.mounted) return;
                await showModalBottomSheet<void>(
                  context: parentContext,
                  isScrollControlled: true,
                  showDragHandle: true,
                  builder: (ctx) => _ManualBillSheet(
                    groupId: groupId,
                    currency: currency,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Creates an empty bill, then opens the scan screen. Uses [parentContext] so
  /// UI still works after the bottom sheet route is popped.
  Future<void> _createBillAndOpenScan({
    required BuildContext sheetContext,
    bool openOcrTab = false,
  }) async {
    Navigator.of(sheetContext).pop();
    if (!parentContext.mounted) return;

    showDialog<void>(
      context: parentContext,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final l10n = parentContext.l10n;
      final repo = ref.read(billRepositoryProvider);
      final bill = await repo.create(
        CreateBillRequest(
          groupId: groupId,
          title: l10n.createBillDefaultReceiptTitle,
          currency: currency,
        ),
      );
      await ref.read(groupViewModelProvider(groupId).notifier).refresh();
      if (!parentContext.mounted) return;
      Navigator.of(parentContext).pop();
      await parentContext.push(
        AppRoutes.billScanPath(bill.id),
        extra: openOcrTab ? BillScanExtra.openOcrTab : null,
      );
    } catch (e) {
      if (parentContext.mounted) {
        Navigator.of(parentContext).pop();
        Snackbars.showError(parentContext, e);
        await showModalBottomSheet<void>(
          context: parentContext,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (ctx) => _ManualBillSheet(
            groupId: groupId,
            currency: currency,
          ),
        );
      }
    }
  }
}

class _ManualBillSheet extends ConsumerStatefulWidget {
  const _ManualBillSheet({
    required this.groupId,
    required this.currency,
  });

  final String groupId;
  final String currency;

  @override
  ConsumerState<_ManualBillSheet> createState() => _ManualBillSheetState();
}

class _ManualBillSheetState extends ConsumerState<_ManualBillSheet> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  bool _loading = false;
  bool _titleSeeded = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_titleSeeded) {
      _title.text = context.l10n.createBillManualDefaultTitle;
      _titleSeeded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, bottom),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.billDetailsTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _title,
              label: l10n.titleFieldLabel,
              validator: (v) => Validators.requiredField(l10n, v),
              enabled: !_loading,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: l10n.createButton,
              isLoading: _loading,
              onPressed: _loading ? null : _submit,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      final repo = ref.read(billRepositoryProvider);
      final bill = await repo.create(
        CreateBillRequest(
          groupId: widget.groupId,
          title: _title.text.trim(),
          currency: widget.currency,
        ),
      );
      await ref.read(groupViewModelProvider(widget.groupId).notifier).refresh();
      if (!mounted) return;
      Navigator.of(context).pop();
      context.push(AppRoutes.billPath(bill.id));
    } catch (e) {
      if (mounted) Snackbars.showError(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
