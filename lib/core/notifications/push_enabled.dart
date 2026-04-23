import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

/// Set `--dart-define=DISABLE_PUSH=true` to skip FCM.
/// Also false until real Firebase config (`flutterfire configure`); placeholders crash iOS native.
bool get pushMessagingEnabled =>
    !kIsWeb &&
    !const bool.fromEnvironment('DISABLE_PUSH', defaultValue: false) &&
    firebaseAppOptionsAreConfigured();
