import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
    this.leading,
    this.trailing,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonVariant variant;
  final Widget? leading;
  final Widget? trailing;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final action = enabled ? onPressed : null;

    final scheme = Theme.of(context).colorScheme;
    final spinnerColor = switch (variant) {
      AppButtonVariant.primary => scheme.onPrimary,
      AppButtonVariant.secondary => scheme.primary,
      AppButtonVariant.text => scheme.primary,
    };

    final content = _Content(
      label: label,
      isLoading: isLoading,
      leading: leading,
      trailing: trailing,
      spinnerColor: spinnerColor,
    );

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: action,
          child: content,
        ),
      AppButtonVariant.secondary => OutlinedButton(
          onPressed: action,
          child: content,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: action,
          child: content,
        ),
    };

    if (!expand) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.label,
    required this.isLoading,
    this.leading,
    this.trailing,
    required this.spinnerColor,
  });

  final String label;
  final bool isLoading;
  final Widget? leading;
  final Widget? trailing;
  final Color spinnerColor;

  @override
  Widget build(BuildContext context) {
    final spinner = SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          spinnerColor,
        ),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          spinner,
          const SizedBox(width: AppSpacing.sm),
        ] else if (leading != null) ...[
          leading!,
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (!isLoading && trailing != null) ...[
          const SizedBox(width: AppSpacing.sm),
          trailing!,
        ],
      ],
    );
  }
}

