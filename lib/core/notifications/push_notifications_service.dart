import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../features/auth/data/models/fcm_token_request.dart';
import '../../firebase_options.dart';
import 'local_notifications_service.dart';

typedef RegisterFcmFn = Future<void> Function(FcmTokenRequest request);

/// Push delivery via FCM only. Access tokens for the app come from your backend
/// (`POST /api/v1/auth/...`, stored in Hive); this service registers the device
/// token with `POST /api/v1/users/me/fcm-token`. No-ops on web if Firebase init fails.
class PushNotificationsService {
  PushNotificationsService._();

  static final PushNotificationsService instance = PushNotificationsService._();

  bool _initialized = false;
  StreamSubscription<String>? _tokenRefreshSub;

  Future<void> init() async {
    if (kIsWeb || _initialized) return;
    if (!firebaseAppOptionsAreConfigured()) {
      debugPrint(
        'PushNotificationsService: skipped (run `flutterfire configure` or add GoogleService-Info.plist).',
      );
      return;
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await LocalNotificationsService.instance.init();

      final messaging = FirebaseMessaging.instance;
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final n = message.notification;
        final title = n?.title ?? message.data['title']?.toString() ?? 'Dealer';
        final body = n?.body ?? message.data['body']?.toString();
        unawaited(
          LocalNotificationsService.instance.showPush(title: title, body: body),
        );
      });

      _initialized = true;
    } catch (e, st) {
      debugPrint(
        'PushNotificationsService.init failed '
        '(check firebase_options / GoogleService-Info.plist / google-services.json): '
        '$e\n$st',
      );
    }
  }

  /// Call after login / session restore when [register] can reach the API.
  Future<void> syncToken(RegisterFcmFn register) async {
    if (kIsWeb || !_initialized) return;

    final messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();
    if (token == null) return;

    await _sendToken(register, token);

    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = messaging.onTokenRefresh.listen((t) {
      unawaited(_sendToken(register, t));
    });
  }

  Future<void> _sendToken(RegisterFcmFn register, String token) async {
    try {
      await register(
        FcmTokenRequest(
          fcmToken: token,
          platform: _platformLabel(),
        ),
      );
    } catch (e, st) {
      debugPrint('registerFcmToken failed: $e\n$st');
    }
  }

  Future<void> clearLocalRegistration() async {
    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;
    if (kIsWeb || !_initialized) return;
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      debugPrint('deleteToken: $e');
    }
  }

  static String _platformLabel() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.android:
        return 'android';
      default:
        return 'other';
    }
  }
}

/// Register in `main()` before `runApp`: `FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);`
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
