import 'package:flutter_dotenv/flutter_dotenv.dart';

/// REST API paths. [baseUrl] defaults to local backend; override for staging/prod:
/// `flutter run -d chrome --dart-define=API_BASE_URL=https://api.example.com`
///
/// Use **`https://`** if the server redirects HTTP→HTTPS (301); otherwise Dio may
/// report `DioException [bad response]: 301` on POST `/auth/login`.
///
/// **Flutter Web:** the browser applies CORS. The API must respond with headers that
/// allow the web app’s origin (the Flutter dev server port differs from `:8000`).
/// Example (FastAPI): `CORSMiddleware(..., allow_origin_regex=r"http://localhost:\\d+")`
/// or list concrete origins. Without this, Dio fails with `XMLHttpRequest onError`.
abstract final class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://89.169.134.38.sslip.io',
      // defaultValue: 'http://localhost:8000',
        // defaultValue: 'http://192.168.0.4:8000',

  );

  /// [baseUrl] without trailing `/` — avoids odd merges with path `/api/v1/...`.
  static String get resolvedBaseUrl {
    var s = baseUrl.trim();
    while (s.endsWith('/')) {
      s = s.substring(0, s.length - 1);
    }
    return s;
  }

  static const apiV1 = '/api/v1';

  static const authRegister = '$apiV1/auth/register';
  static const authLogin = '$apiV1/auth/login';
  static const authRefresh = '$apiV1/auth/refresh';
  static const authLogout = '$apiV1/auth/logout';

  static const usersMe = '$apiV1/users/me';
  static const usersMeFcmToken = '$apiV1/users/me/fcm-token';

  /// `POST /api/v1/groups` — create group ([GroupDto] in response).
  static const groups = '$apiV1/groups';

  static const notifications = '$apiV1/notifications';

  /// Base URL for invite deep links (must match Android intent host / iOS universal links).
  /// Override: `--dart-define=INVITE_SHARE_URL=https://your-app.example`
  static const inviteShareUrl = String.fromEnvironment(
    'INVITE_SHARE_URL',
    defaultValue: 'https://89.169.134.38.sslip.io',
  );

  /// `…/join?code=` — opens the app on `/join` with the code (after login if needed).
  static String inviteJoinUrlForCode(String inviteCode) {
    final base = inviteShareUrl.trim().replaceAll(RegExp(r'/+$'), '');
    return '$base/join?code=${Uri.encodeQueryComponent(inviteCode.trim())}';
  }

  /// Official «Проверка чека онлайн» API (`POST https://proverkacheka.com/api/v1/check/get`).
  ///
  /// **Priority:** `String.fromEnvironment` (CI / `--dart-define=PROVERKACHEKA_TOKEN=...`)
  /// wins over [flutter_dotenv] from bundled [assets/dotenv/app.env] (edit locally; do not ship secrets in release builds — use defines).
  static String get proverkachekaToken {
    const fromDefine = String.fromEnvironment(
      'PROVERKACHEKA_TOKEN',
      defaultValue: '',
    );
    if (fromDefine.trim().isNotEmpty) return fromDefine.trim();
    final fromFile = dotenv.maybeGet('PROVERKACHEKA_TOKEN')?.trim();
    return fromFile ?? '';
  }
}
