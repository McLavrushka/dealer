import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/router/invite_incoming_uri.dart';
import 'core/storage/hive_service.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/adaptive_layout.dart';
import 'l10n/app_localizations.dart';

class DealerApp extends ConsumerStatefulWidget {
  const DealerApp({super.key});

  @override
  ConsumerState<DealerApp> createState() => _DealerAppState();
}

class _DealerAppState extends ConsumerState<DealerApp> {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialUri();
    });
    _linkSubscription = _appLinks.uriLinkStream.listen(_handleExternalUri);
  }

  @override
  void dispose() {
    final sub = _linkSubscription;
    _linkSubscription = null;
    if (sub != null) unawaited(sub.cancel());
    super.dispose();
  }

  Future<void> _handleInitialUri() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) _handleExternalUri(uri);
    } catch (_) {}
  }

  void _handleExternalUri(Uri uri) {
    if (!HiveService.instance.isInitialized) return;
    final code = parseInviteCodeFromIncomingUri(uri);
    if (code == null || code.isEmpty) return;

    final router = ref.read(appRouterProvider);
    final token = HiveService.instance.accessToken;
    final onboarding = HiveService.instance.onboardingShown;

    if (token == null) {
      HiveService.instance.setPendingInviteCode(code);
      router.go(AppRoutes.login);
      return;
    }
    if (!onboarding) {
      HiveService.instance.setPendingInviteCode(code);
      router.go(AppRoutes.onboarding);
      return;
    }
    router.go('${AppRoutes.join}?code=${Uri.encodeQueryComponent(code)}');
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ru'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      builder: (context, child) => AdaptiveLayout(child: child),
    );
  }
}
