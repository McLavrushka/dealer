import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/context_l10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/snackbars.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../data/models/notification_dto.dart';
import 'notifications_view_model.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationsViewModelProvider);
    final l10n = context.l10n;

    ref.listen(notificationsViewModelProvider, (prev, next) {
      final err = next.error;
      if (err != null) Snackbars.showError(context, err);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.groups);
            }
          },
        ),
      ),
      body: state.when(
        loading: () => const SkeletonList(),
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () => ref.read(notificationsViewModelProvider.notifier).refresh(),
        ),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.notifications_none_rounded,
              title: l10n.noNotificationsTitle,
              message: l10n.noNotificationsMessage,
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(notificationsViewModelProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: items.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final n = items[index];
                return _NotificationTile(
                  localeTag: Localizations.localeOf(context).toLanguageTag(),
                  notification: n,
                  onTap: () {
                    if (!n.read) {
                      ref.read(notificationsViewModelProvider.notifier).markRead(n.id);
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.localeTag,
    required this.notification,
    required this.onTap,
  });

  final String localeTag;
  final NotificationDto notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final parsed = DateTime.tryParse(notification.createdAt);
    final subtitle = parsed != null
        ? DateFormat.yMMMd(localeTag).add_jm().format(parsed.toLocal())
        : notification.createdAt;

    return Material(
      color: notification.read
          ? scheme.surfaceContainerLow
          : scheme.primaryContainer.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      notification.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight:
                                notification.read ? FontWeight.w600 : FontWeight.w800,
                          ),
                    ),
                  ),
                  if (!notification.read)
                    Icon(Icons.circle, size: 10, color: scheme.primary),
                ],
              ),
              if (notification.body != null && notification.body!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  notification.body!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
