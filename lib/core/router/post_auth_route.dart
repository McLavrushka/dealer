import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../storage/hive_service.dart';
import 'app_router.dart';

/// After login / register / onboarding, land on join flow if an invite link was deferred.
String resolvePostAuthDestination() {
  final p = HiveService.instance.pendingInviteCode;
  if (p != null && p.isNotEmpty) {
    return '${AppRoutes.join}?code=${Uri.encodeQueryComponent(p)}';
  }
  return AppRoutes.groups;
}

/// [GoRouter] redirect reads Riverpod [ref] while auth listeners may still be
/// notifying — a synchronous [context.go] from [ref.listen] can trigger
/// `!_didChangeDependency`. Schedule navigation after the frame.
void scheduleRouterGo(BuildContext context, String location) {
  Future.microtask(() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) context.go(location);
    });
  });
}
