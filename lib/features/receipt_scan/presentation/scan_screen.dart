import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/l10n/context_l10n.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/snackbars.dart';
import '../../../core/widgets/app_button.dart';
import '../../bills/data/models/add_bill_item_request.dart';
import '../../bills/presentation/bill_view_model.dart';
import '../data/scan_providers.dart';
import '../domain/receipt_line.dart';
import '../domain/receipt_ocr_preprocess.dart';
import '../domain/receipt_ocr_temp.dart';
import '../domain/receipt_ocr_text_builder.dart';

/// QR / OCR scan. On [kIsWeb], only manual paste is available.
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({
    super.key,
    required this.billId,
    this.initialTabIndex = 0,
  });

  final String billId;

  /// Mobile only: `0` = QR, `1` = OCR.
  final int initialTabIndex;

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabs;
  MobileScannerController? _scanner;

  final _manualQr = TextEditingController();
  final _manualOcr = TextEditingController();
  bool _busy = false;
  String? _lastQr;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      final idx = widget.initialTabIndex.clamp(0, 1);
      _tabs = TabController(length: 2, vsync: this, initialIndex: idx);
      _scanner = MobileScannerController();
    }
  }

  @override
  void dispose() {
    _tabs?.dispose();
    _manualQr.dispose();
    _manualOcr.dispose();
    _scanner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(l10n.scanReceiptTitle),
            bottom: kIsWeb
                ? null
                : TabBar(
                    controller: _tabs!,
                    tabs: [
                      Tab(text: l10n.tabQr),
                      Tab(text: l10n.tabOcr),
                    ],
                  ),
          ),
          body: kIsWeb
              ? _buildWebBody(context)
              : TabBarView(
                  controller: _tabs!,
                  children: [
                    _buildQrTab(context),
                    _buildOcrTab(context),
                  ],
                ),
        ),
        if (_busy)
          const ColoredBox(
            color: Color(0x66000000),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildWebBody(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          child: Text(
            l10n.scanWebManualIntro,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _manualQr,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: l10n.fiscalQrLabel,
            hintText: l10n.fiscalQrHint,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: l10n.parseQrButton,
          onPressed: _busy ? null : () => _parseQrString(_manualQr.text),
        ),
        const SizedBox(height: AppSpacing.xl),
        TextField(
          controller: _manualOcr,
          maxLines: 8,
          decoration: InputDecoration(
            labelText: l10n.receiptTextForOcrLabel,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: l10n.parseTextButton,
          variant: AppButtonVariant.secondary,
          onPressed: _busy ? null : () => _parseOcrText(_manualOcr.text),
        ),
      ],
    );
  }

  Widget _buildQrTab(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Expanded(
          child: MobileScanner(
            controller: _scanner!,
            onDetect: (capture) {
              if (_busy) return;
              for (final b in capture.barcodes) {
                final v = b.rawValue;
                if (v == null || v.isEmpty) continue;
                final trimmed = v.trim();
                if (trimmed.isEmpty) continue;
                if (trimmed == _lastQr) continue;
                _lastQr = trimmed;
                _parseQrString(trimmed);
                break;
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Text(
                l10n.qrPointCameraHint,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: l10n.chooseFromGalleryButton,
                variant: AppButtonVariant.secondary,
                onPressed: _busy ? null : _scanQrFromGallery,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOcrTab(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text(
          l10n.scanOcrDescription,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: l10n.takePhotoButton,
          onPressed: _busy ? null : () => _runOcrFromPicker(ImageSource.camera),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: l10n.chooseFromGalleryButton,
          variant: AppButtonVariant.secondary,
          onPressed: _busy ? null : () => _runOcrFromPicker(ImageSource.gallery),
        ),
      ],
    );
  }

  Future<void> _scanQrFromGallery() async {
    final l10n = context.l10n;
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (!mounted) return;
    if (file == null) return;
    setState(() => _busy = true);
    try {
      // ignore: deprecated_member_use
      final scanner = GoogleMlKit.vision.barcodeScanner();
      try {
        final input = InputImage.fromFilePath(file.path);
        final barcodes = await scanner.processImage(input);
        final value = barcodes
            .map((b) => b.rawValue)
            .whereType<String>()
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .cast<String?>()
            .firstWhere((_) => true, orElse: () => null);
        if (value == null) {
          throw StateError(l10n.errorCouldNotParseQrFromImage);
        }
        if (!mounted) return;
        await _parseQrString(value);
      } finally {
        await scanner.close();
      }
    } catch (e) {
      if (mounted) Snackbars.showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _parseQrString(String raw) async {
    if (raw.trim().isEmpty) return;
    setState(() => _busy = true);
    // Prevent repeated detections while we parse/import.
    try {
      await _scanner?.stop();
    } catch (_) {}
    try {
      final lines = await ref
          .read(scanQrUseCaseProvider)
          .run(raw)
          .timeout(const Duration(seconds: 55));
      if (!mounted) return;
      // Stop the blocking overlay before showing the bottom sheet preview.
      setState(() => _busy = false);
      await _previewAndImport(lines);
    } catch (e) {
      if (mounted) Snackbars.showError(context, e);
    } finally {
      try {
        await _scanner?.start();
      } catch (_) {}
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _parseOcrText(String raw) async {
    if (raw.trim().isEmpty) return;
    setState(() => _busy = true);
    try {
      final lines = ref.read(parseOcrUseCaseProvider).run(raw);
      if (lines.isEmpty) {
        throw StateError(context.l10n.errorNoLinesInPaste);
      }
      if (!mounted) return;
      // Stop the blocking overlay before showing the bottom sheet preview.
      setState(() => _busy = false);
      await _previewAndImport(lines);
    } catch (e) {
      if (mounted) Snackbars.showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _runOcrFromPicker(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.rear,
      // Larger resolution helps on-device OCR; quality keeps file size reasonable.
      maxWidth: 2400,
      imageQuality: 92,
    );
    if (file == null) return;
    await _runOcrOnImageFile(file);
  }

  Future<void> _runOcrOnImageFile(XFile file) async {
    final l10n = context.l10n;
    setState(() => _busy = true);
    // ML Kit: [TextRecognitionScript.latin] = Latin / Western script (English, etc.).
    // Default constructor also defaults to Latin; we set it explicitly for clarity.
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    String? tmpPath;
    try {
      final raw = await file.readAsBytes();
      final processed = preprocessReceiptImageForLatinScriptOcr(raw);
      tmpPath = await writeReceiptOcrTempJpeg(processed);

      final input = InputImage.fromFilePath(tmpPath);
      final result = await recognizer.processImage(input);
      final text = ReceiptOcrTextBuilder.build(result);
      if (text.trim().isEmpty) {
        throw StateError(l10n.errorNoTextRecognized);
      }
      final lines = ref.read(parseOcrUseCaseProvider).run(text);
      if (lines.isEmpty) {
        throw StateError(l10n.errorCouldNotParseOcrLines);
      }
      if (!mounted) return;
      setState(() => _busy = false);
      await _previewAndImport(lines);
    } catch (e) {
      if (mounted) Snackbars.showError(context, e);
    } finally {
      await recognizer.close();
      if (tmpPath != null) await deleteReceiptOcrTemp(tmpPath);
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _previewAndImport(List<ReceiptLine> lines) async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        final sheetL10n = AppLocalizations.of(ctx);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  sheetL10n.importLinesQuestion(lines.length),
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 280,
                  child: ListView(
                    children: lines
                        .map(
                          (l) => ListTile(
                            dense: true,
                            title: Text(l.name),
                            trailing: Text(
                              '${l.price} × ${l.quantity}',
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: sheetL10n.importButton,
                  onPressed: () => Navigator.of(ctx).pop(true),
                ),
                AppButton(
                  label: sheetL10n.cancelButton,
                  variant: AppButtonVariant.text,
                  onPressed: () => Navigator.of(ctx).pop(false),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (ok != true || !mounted) return;

    setState(() => _busy = true);
    try {
      final vm = ref.read(billViewModelProvider(widget.billId).notifier);
      for (final l in lines) {
        await vm.addItem(
          AddBillItemRequest(
            name: l.name,
            price: l.price,
            quantity: l.quantity,
          ),
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) Snackbars.showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
