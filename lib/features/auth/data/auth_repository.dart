import 'models/auth_response.dart';
import 'models/fcm_token_request.dart';
import 'models/login_request.dart';
import 'models/register_request.dart';
import 'models/update_profile_request.dart';
import 'models/user_dto.dart';

abstract interface class AuthRepository {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest request);

  Future<void> logout({required String refreshToken});

  Future<UserDto> me();
  Future<UserDto> updateMe(UpdateProfileRequest request);

  Future<void> registerFcmToken(FcmTokenRequest request);
}

