// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authViewModelHash() => r'cd1d7efe23c45da60458261a0ab189345f6b6ff7';

/// Not autoDispose: otherwise after login/navigation there can be a moment with
/// no listeners, the provider is disposed, and the next [build] calls `me()` again
/// → many `GET /api/v1/users/me` in a row (GoRouter `redirect` re-reads auth).
///
/// Copied from [AuthViewModel].
@ProviderFor(AuthViewModel)
final authViewModelProvider =
    AsyncNotifierProvider<AuthViewModel, UserDto?>.internal(
      AuthViewModel.new,
      name: r'authViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthViewModel = AsyncNotifier<UserDto?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
