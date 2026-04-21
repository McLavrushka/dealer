import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/auth_view_model.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/profile_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/bills/presentation/bill_items_screen.dart';
import '../../features/bills/presentation/bill_result_screen.dart';
import '../../features/bills/presentation/roulette_screen.dart';
import '../../features/bills/presentation/split_screen.dart';
import '../../features/receipt_scan/presentation/scan_screen.dart';
import '../../features/groups/presentation/group_screen.dart';
import '../../features/groups/presentation/groups_screen.dart';
import '../../features/groups/presentation/join_from_link_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../storage/hive_service.dart';
import 'post_auth_route.dart';

part 'app_router.g.dart';

bool _isJoinUri(GoRouterState state) {
  final p = state.uri.path;
  return p == '/join' || p.startsWith('/join/');
}

String? _joinCodeFromState(GoRouterState state) {
  final q = state.uri.queryParameters['code'] ?? state.uri.queryParameters['invite'];
  if (q != null && q.trim().isNotEmpty) return q.trim();
  final segs = state.uri.pathSegments.where((e) => e.isNotEmpty).toList();
  final i = segs.indexWhere((e) => e.toLowerCase() == 'join');
  if (i >= 0 && i + 1 < segs.length) return segs[i + 1].trim();
  return null;
}

void _persistJoinCodeIfAny(GoRouterState state) {
  final c = _joinCodeFromState(state);
  if (c != null && c.isNotEmpty) {
    HiveService.instance.setPendingInviteCode(c);
  }
}

String _resolveInitialLocation() {
  final token = HiveService.instance.accessToken;
  if (token == null) return AppRoutes.login;
  if (!HiveService.instance.onboardingShown) return AppRoutes.onboarding;
  return AppRoutes.groups;
}

abstract final class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const onboarding = '/onboarding';
  static const groups = '/groups';
  static const group = '/groups/:id';
  static const bill = '/bills/:id';
  static const billScanRoute = '/bills/:id/scan';
  static const billSplitRoute = '/bills/:id/split';
  static const billResultRoute = '/bills/:id/result';
  static const billRouletteRoute = '/bills/:id/roulette';
  static const profile = '/profile';
  static const notifications = '/notifications';
  static const join = '/join';

  static String groupPath(String id) => '/groups/$id';
  static String billPath(String id) => '/bills/$id';
  static String billScanPath(String id) => '/bills/$id/scan';
  static String billSplitPath(String id) => '/bills/$id/split';
  static String billResultPath(String id) => '/bills/$id/result';
  static String billRoulettePath(String id) => '/bills/$id/roulette';
}

/// Use as `context.push(..., extra: BillScanExtra.openOcrTab)` to open OCR first.
abstract final class BillScanExtra {
  static const openOcrTab = 'billScanOpenOcrTab';
}

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: _resolveInitialLocation(),
    routes: [
      GoRoute(
        path: '${AppRoutes.join}/:code',
        builder: (context, state) => JoinFromLinkScreen(
          initialCode: state.pathParameters['code'],
        ),
      ),
      GoRoute(
        path: AppRoutes.join,
        builder: (context, state) => JoinFromLinkScreen(
          initialCode: state.uri.queryParameters['code'] ??
              state.uri.queryParameters['invite'],
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.groups,
        builder: (context, state) => const GroupsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) => GroupScreen(
              groupId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.billScanRoute,
        builder: (context, state) {
          final openOcr = state.extra == BillScanExtra.openOcrTab;
          return ScanScreen(
            billId: state.pathParameters['id']!,
            initialTabIndex: openOcr ? 1 : 0,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.billSplitRoute,
        builder: (context, state) => SplitScreen(
          billId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.billResultRoute,
        builder: (context, state) => BillResultScreen(
          billId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.billRouletteRoute,
        builder: (context, state) => RouletteScreen(
          billId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.bill,
        builder: (context, state) => BillItemsScreen(
          billId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
    errorPageBuilder: (context, state) =>
        const MaterialPage(child: _RedirectToGroups()),
    redirect: (context, state) {
      final auth = ref.watch(authViewModelProvider);
      final isAuthed =
          auth.valueOrNull != null || HiveService.instance.accessToken != null;

      final location = state.matchedLocation;
      if (location.isEmpty) return _resolveInitialLocation();

      final isOnAuth =
          location == AppRoutes.login || location == AppRoutes.register;
      final isOnboarding = location == AppRoutes.onboarding;

      if (!isAuthed) {
        if (isOnboarding) return AppRoutes.login;
        if (_isJoinUri(state)) {
          _persistJoinCodeIfAny(state);
        }
        if (!isOnAuth) return AppRoutes.login;
        return null;
      }

      if (!HiveService.instance.onboardingShown) {
        if (_isJoinUri(state)) {
          _persistJoinCodeIfAny(state);
        }
        if (!isOnboarding) return AppRoutes.onboarding;
        return null;
      }

      if (isOnboarding) return resolvePostAuthDestination();
      if (isOnAuth) return resolvePostAuthDestination();

      return null;
    },
  );
}

class _RedirectToGroups extends StatelessWidget {
  const _RedirectToGroups();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) context.go(AppRoutes.groups);
    });
    return const SizedBox.shrink();
  }
}

