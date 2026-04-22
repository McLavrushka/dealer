import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/context_l10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/settings/app_settings_provider.dart';
import '../../../core/storage/hive_service.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/snackbars.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton_loader.dart';
import 'auth_view_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _currency = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _currency.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (prev, next) {
      final error = next.error;
      if (error != null) Snackbars.showError(context, error);

      final user = next.valueOrNull;
      if (user == null && !(next.isLoading)) {
        context.go(AppRoutes.login);
      }
    });

    final state = ref.watch(authViewModelProvider);
    final appSettings = ref.watch(appSettingsProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
      ),
      body: SafeArea(
        child: state.when(
          loading: () => const SkeletonLoader(
            child: _ProfileSkeleton(),
          ),
          error: (e, _) => ErrorView(
            message: e.toString(),
            onRetry: () => ref.read(authViewModelProvider.notifier).refreshMe(),
          ),
          data: (user) {
            if (user == null) {
              return const SizedBox.shrink();
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              if (_name.text != user.name) _name.text = user.name;
              final nextCurrency = user.currencyDefault ?? '';
              if (_currency.text != nextCurrency) _currency.text = nextCurrency;
            });

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      controller: _name,
                      label: l10n.nameLabel,
                      validator: (v) => Validators.requiredField(l10n, v),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(
                      controller: _currency,
                      label: l10n.defaultCurrencyLabel,
                      hint: l10n.currencyCodeHint,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l10n.settingsAppearanceSection,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.settingsThemeLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        ChoiceChip(
                          label: Text(l10n.themeOptionSystem),
                          selected: appSettings.themeMode == ThemeMode.system,
                          onSelected: (selected) {
                            if (!selected) return;
                            ref
                                .read(appSettingsProvider.notifier)
                                .setThemeMode(ThemeMode.system);
                          },
                        ),
                        ChoiceChip(
                          label: Text(l10n.themeOptionLight),
                          selected: appSettings.themeMode == ThemeMode.light,
                          onSelected: (selected) {
                            if (!selected) return;
                            ref
                                .read(appSettingsProvider.notifier)
                                .setThemeMode(ThemeMode.light);
                          },
                        ),
                        ChoiceChip(
                          label: Text(l10n.themeOptionDark),
                          selected: appSettings.themeMode == ThemeMode.dark,
                          onSelected: (selected) {
                            if (!selected) return;
                            ref
                                .read(appSettingsProvider.notifier)
                                .setThemeMode(ThemeMode.dark);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.settingsLanguageLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        ChoiceChip(
                          label: Text(l10n.languageOptionSystem),
                          selected:
                              appSettings.localePreference == AppLocalePreference.system,
                          onSelected: (selected) {
                            if (!selected) return;
                            ref
                                .read(appSettingsProvider.notifier)
                                .setLocalePreference(AppLocalePreference.system);
                          },
                        ),
                        ChoiceChip(
                          label: Text(l10n.languageOptionRussian),
                          selected:
                              appSettings.localePreference == AppLocalePreference.ru,
                          onSelected: (selected) {
                            if (!selected) return;
                            ref
                                .read(appSettingsProvider.notifier)
                                .setLocalePreference(AppLocalePreference.ru);
                          },
                        ),
                        ChoiceChip(
                          label: Text(l10n.languageOptionEnglish),
                          selected:
                              appSettings.localePreference == AppLocalePreference.en,
                          onSelected: (selected) {
                            if (!selected) return;
                            ref
                                .read(appSettingsProvider.notifier)
                                .setLocalePreference(AppLocalePreference.en);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: l10n.saveButton,
                      onPressed: () => _save(),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppButton(
                      label: l10n.logoutButton,
                      variant: AppButtonVariant.secondary,
                      onPressed: () async {
                        await ref.read(authViewModelProvider.notifier).logout();
                      },
                    ),
                    if (kDebugMode) ...[
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: l10n.debugClearHiveButton,
                        variant: AppButtonVariant.secondary,
                        onPressed: _clearHiveForDebug,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _clearHiveForDebug() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.clearStorageDialogTitle),
        content: Text(l10n.clearStorageDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.clearButton),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(authViewModelProvider.notifier).logout();
    } catch (_) {
      // Ignore: we still want to clear local storage even if network/logout fails.
    }

    await HiveService.instance.clearAll();
    if (!mounted) return;
    Snackbars.showSuccess(context, context.l10n.localStorageClearedMessage);
    context.go(AppRoutes.login);
  }

  Future<void> _save() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    await ref.read(authViewModelProvider.notifier).updateProfile(
          name: _name.text.trim(),
          currencyDefault: _currency.text.trim().isEmpty
              ? null
              : _currency.text.trim().toUpperCase(),
        );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: const [
        SkeletonBox(height: 56),
        SizedBox(height: AppSpacing.sm),
        SkeletonBox(height: 56),
        SizedBox(height: AppSpacing.lg),
        SkeletonBox(height: 48),
        SizedBox(height: AppSpacing.sm),
        SkeletonBox(height: 48),
      ],
    );
  }
}

