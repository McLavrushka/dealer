import 'package:dio/dio.dart';

import '../../../core/network/api_config.dart';
import 'auth_repository.dart';
import 'models/auth_response.dart';
import 'models/fcm_token_request.dart';
import 'models/login_request.dart';
import 'models/register_request.dart';
import 'models/update_profile_request.dart';
import 'models/user_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConfig.authLogin,
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data!);
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConfig.authRegister,
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data!);
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    await _dio.delete<void>(
      ApiConfig.authLogout,
      data: {'refreshToken': refreshToken},
    );
  }

  @override
  Future<UserDto> me() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiConfig.usersMe);
    return UserDto.fromJson(response.data!);
  }

  @override
  Future<UserDto> updateMe(UpdateProfileRequest request) async {
    final data = <String, dynamic>{
      if (request.name != null) 'name': request.name,
      if (request.currencyDefault != null) 'currencyDefault': request.currencyDefault,
      // Always send so the backend can clear the field when the user clears the box.
      'transferComment': request.transferComment,
    };
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiConfig.usersMe,
      data: data,
    );
    return UserDto.fromJson(response.data!);
  }

  @override
  Future<void> registerFcmToken(FcmTokenRequest request) async {
    await _dio.post<void>(
      ApiConfig.usersMeFcmToken,
      data: request.toJson(),
    );
  }
}

