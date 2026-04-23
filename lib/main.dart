import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/notifications/push_enabled.dart';
import 'core/notifications/push_notifications_service.dart';
import 'core/storage/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: 'assets/dotenv/app.env');
  } catch (e, st) {
    debugPrint('dotenv load failed (optional): $e\n$st');
  }
  // FCM only (not Firebase Auth). JWT auth is via Dio + Hive.
  if (pushMessagingEnabled) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
  await HiveService.instance.init();

  runApp(
    const ProviderScope(
      child: DealerApp(),
    ),
  );

  // After first frame: push stack (Firebase / local notifications) must not block UI.
  // If init throws, the app still runs; check console / Xcode for native crashes.
  if (pushMessagingEnabled) {
    unawaited(
      PushNotificationsService.instance.init().catchError((Object e, StackTrace st) {
        debugPrint('PushNotificationsService.init failed: $e\n$st');
      }),
    );
  }
}
