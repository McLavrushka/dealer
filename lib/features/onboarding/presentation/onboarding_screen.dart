import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/context_l10n.dart';
import '../../../core/router/post_auth_route.dart';
import '../../../core/storage/hive_service.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                Icons.receipt_long_rounded,
                size: 88,
                color: scheme.primary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.onboardingHeadline,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.onboardingDescription,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const Spacer(),
              AppButton(
                label: l10n.getStartedButton,
                onPressed: () async {
                  await HiveService.instance.setOnboardingShown();
                  if (!context.mounted) return;
                  context.go(resolvePostAuthDestination());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
