abstract final class ApiConfig {
  static const baseUrl = 'http://localhost:8000';
  static const apiV1 = '/api/v1';

  static const authRegister = '$apiV1/auth/register';
  static const authLogin = '$apiV1/auth/login';
  static const authRefresh = '$apiV1/auth/refresh';
  static const authLogout = '$apiV1/auth/logout';
}

