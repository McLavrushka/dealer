import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({super.key, required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width < 900) return child ?? const SizedBox.shrink();

        final scheme = Theme.of(context).colorScheme;
        final sideBg = scheme.brightness == Brightness.light
            ? AppColors.neutralBg
            : AppColors.neutralBgDark;

        return ColoredBox(
          color: sideBg,
          child: Row(
            children: [
              const Expanded(
                child: _SideTitle(),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 480),
                  child: ColoredBox(
                    color: scheme.surface,
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SideTitle extends StatelessWidget {
  const _SideTitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Dealer',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }
}

