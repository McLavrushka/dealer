import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final cardChild = Padding(
      padding: padding,
      child: child,
    );

    if (onTap == null) {
      return Card(child: cardChild);
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: cardChild,
      ),
    );
  }
}

