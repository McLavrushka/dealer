import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

abstract final class AppRoutes {
  static const groups = '/groups';
  static const group = '/groups/:id';
  static const bill = '/bills/:id';
  static const profile = '/profile';
  static const notifications = '/notifications';
}

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.groups,
    routes: [
      GoRoute(
        path: AppRoutes.groups,
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Groups',
          hint: 'Feature groups будет на следующем шаге.',
        ),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) => _PlaceholderScreen(
              title: 'Group',
              hint: 'Group id: ${state.pathParameters['id']}',
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.bill,
        builder: (context, state) => _PlaceholderScreen(
          title: 'Bill',
          hint: 'Bill id: ${state.pathParameters['id']}',
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Profile',
          hint: 'Feature auth/profile будет на следующем шаге.',
        ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Notifications',
          hint: 'Feature notifications будет на следующем шаге.',
        ),
      ),
    ],
    errorPageBuilder: (context, state) =>
        const MaterialPage(child: _RedirectToGroups()),
    redirect: (context, state) {
      final location = state.matchedLocation;
      if (location.isEmpty) return AppRoutes.groups;
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

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title, required this.hint});

  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          hint,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

