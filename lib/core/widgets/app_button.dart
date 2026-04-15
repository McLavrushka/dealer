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

    final content = _Content(
      label: label,
      isLoading: isLoading,
      leading: leading,
      trailing: trailing,
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
  });

  final String label;
  final bool isLoading;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spinner = SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          theme.colorScheme.onPrimary,
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

