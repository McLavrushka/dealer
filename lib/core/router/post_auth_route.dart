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
