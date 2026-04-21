// Replace with output from `flutterfire configure` for production FCM.
//
// Auth is **not** Firebase Auth: login/register use the app backend (JWT in Hive).
// Firebase here is only for Cloud Messaging (FCM device tokens → your API).
// ignore_for_file: lines_longer_than_80_chars

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for FCM (`firebase_messaging`), not for sign-in.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
/// Returns false for placeholder [DefaultFirebaseOptions] shipped in the repo.
/// Native Firebase on iOS **crashes** if API key length ≠ 39, before Dart can catch errors.
bool firebaseAppOptionsAreConfigured() {
  final FirebaseOptions o;
  if (kIsWeb) {
    o = DefaultFirebaseOptions.web;
  } else {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        o = DefaultFirebaseOptions.android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        o = DefaultFirebaseOptions.ios;
      default:
        return false;
    }
  }
  if (o.projectId == 'dealer-placeholder') return false;
  final key = o.apiKey;
  if (key.contains('Placeholder')) return false;
  return key.length == 39 && key.startsWith('AIza');
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyPlaceholderReplaceWithFlutterFireConfigure',
    appId: '1:000000000000:android:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'dealer-placeholder',
    storageBucket: 'dealer-placeholder.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyPlaceholderReplaceWithFlutterFireConfigure',
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'dealer-placeholder',
    storageBucket: 'dealer-placeholder.appspot.com',
    iosBundleId: 'com.lavrova.dealer',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyPlaceholderReplaceWithFlutterFireConfigure',
    appId: '1:000000000000:web:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'dealer-placeholder',
    authDomain: 'dealer-placeholder.firebaseapp.com',
    storageBucket: 'dealer-placeholder.appspot.com',
  );
}
