import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/context_l10n.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/snackbars.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../data/models/add_bill_item_request.dart';
import '../data/models/bill_dto.dart';
import '../data/models/bill_item_dto.dart';
import '../data/models/patch_bill_item_request.dart';
import 'bill_view_model.dart';

class BillItemsScreen extends ConsumerWidget {
  const BillItemsScreen({super.key, required this.billId});

  final String billId;

  static num _lineTotal(BillItemDto i) => i.price * i.quantity;

  static num _billTotal(BillDto b) =>
      b.items.fold<num>(0, (s, i) => s + _lineTotal(i));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(billViewModelProvider(billId), (prev, next) {
      final err = next.error;
      if (err != null) Snackbars.showError(context, err);
    });

    final asyncBill = ref.watch(billViewModelProvider(billId));
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: asyncBill.maybeWhen(
          data: (b) => Text(b.title),
          orElse: () => Text(l10n.billFallbackTitle),
        ),
        actions: [
          if (!kIsWeb)
            IconButton(
              tooltip: l10n.scanReceiptTooltip,
              onPressed: asyncBill.isLoading
                  ? null
                  : () => context.push(AppRoutes.billScanPath(billId)),
              icon: const Icon(Icons.qr_code_scanner_rounded),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: asyncBill.isLoading
            ? null
            : () => _openItemEditor(context, ref, billId, null),
        child: const Icon(Icons.add_rounded),
      ),
      body: asyncBill.when(
        loading: () => const SkeletonList(),
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () => ref.read(billViewModelProvider(billId).notifier).refresh(),
        ),
        data: (bill) {
          if (bill.items.isEmpty) {
            return EmptyState(
              icon: Icons.receipt_long_outlined,
              title: l10n.noLineItemsTitle,
              message: l10n.noLineItemsMessage,
              actionLabel: l10n.addItemButton,
              onAction: () => _openItemEditor(context, ref, billId, null),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              120,
            ),
            itemCount: bill.items.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final item = bill.items[index];
              return ListTile(
                key: ValueKey(item.id),
                dense: true,
                contentPadding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  4,
                  AppSpacing.sm,
                ),
                tileColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                title: Text(item.name),
                subtitle: Text(
                  '${item.price} × ${item.quantity} = ${_lineTotal(item)}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppSpacing.xs,
                  children: [
                    IconButton(
                      tooltip: l10n.editTooltip,
                      iconSize: 22,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      constraints:
                          const BoxConstraints.tightFor(width: 36, height: 36),
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: asyncBill.isLoading
                          ? null
                          : () => _openItemEditor(context, ref, billId, item),
                    ),
                    IconButton(
                      tooltip: l10n.deleteTooltip,
                      iconSize: 22,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      constraints:
                          const BoxConstraints.tightFor(width: 36, height: 36),
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: asyncBill.isLoading
                          ? null
                          : () => _confirmDeleteLineItem(
                                context,
                                ref,
                                billId,
                                item,
                              ),
                    ),
                  ],
                ),
                onTap: asyncBill.isLoading
                    ? null
                    : () => _openItemEditor(context, ref, billId, item),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: asyncBill.maybeWhen(
            data: (bill) {
              final total = _billTotal(bill);
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.totalLabel,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Text(
                        '${total.toStringAsFixed(2)} ${bill.currency}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(
                    label: l10n.splitButton,
                    onPressed: bill.items.isEmpty || asyncBill.isLoading
                        ? null
                        : () => context.push(AppRoutes.billSplitPath(billId)),
                  ),
                ],
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  static Future<void> _confirmDeleteLineItem(
    BuildContext context,
    WidgetRef ref,
    String billId,
    BillItemDto item,
  ) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteLineItemDialogTitle),
        content: Text(l10n.deleteLineItemDialogContent(item.name)),
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
      await ref.read(billViewModelProvider(billId).notifier).deleteItem(item.id);
    } catch (e) {
      await ref.read(billViewModelProvider(billId).notifier).refresh();
      if (context.mounted) Snackbars.showError(context, e);
    }
  }

  static Future<void> _openItemEditor(
    BuildContext context,
    WidgetRef ref,
    String billId,
    BillItemDto? existing,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => _ItemEditorSheet(
        billId: billId,
        existing: existing,
      ),
    );
  }
}

class _ItemEditorSheet extends ConsumerStatefulWidget {
  const _ItemEditorSheet({required this.billId, this.existing});

  final String billId;
  final BillItemDto? existing;

  @override
  ConsumerState<_ItemEditorSheet> createState() => _ItemEditorSheetState();
}

class _ItemEditorSheetState extends ConsumerState<_ItemEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _qty = TextEditingController(text: '1');
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _name.text = e.name;
      _price.text = e.price.toString();
      _qty.text = e.quantity.toString();
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _qty.dispose();
    super.dispose();
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
              widget.existing == null
                  ? l10n.addItemSheetTitle
                  : l10n.editItemSheetTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _name,
              label: l10n.nameLabel,
              validator: (v) => Validators.requiredField(l10n, v),
              enabled: !_loading,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              controller: _price,
              label: l10n.priceLabel,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => _numString(l10n, v),
              enabled: !_loading,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              controller: _qty,
              label: l10n.quantityLabel,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => _numString(l10n, v),
              enabled: !_loading,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: widget.existing == null
                  ? l10n.addSheetButton
                  : l10n.saveSheetButton,
              isLoading: _loading,
              onPressed: _loading ? null : _submit,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  String? _numString(AppLocalizations l10n, String? v) {
    final r = Validators.requiredField(l10n, v);
    if (r != null) return r;
    if (num.tryParse(v!.trim()) == null) return l10n.invalidNumberValidation;
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      final price = num.parse(_price.text.trim());
      final qty = num.parse(_qty.text.trim());
      final vm = ref.read(billViewModelProvider(widget.billId).notifier);
      if (widget.existing == null) {
        await vm.addItem(
          AddBillItemRequest(
            name: _name.text.trim(),
            price: price,
            quantity: qty,
          ),
        );
      } else {
        await vm.updateItem(
          widget.existing!.id,
          PatchBillItemRequest(
            name: _name.text.trim(),
            price: price,
            quantity: qty,
          ),
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) Snackbars.showError(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
