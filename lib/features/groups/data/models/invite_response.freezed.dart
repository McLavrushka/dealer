// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invite_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InviteResponse {

 String get inviteCode; String get deepLink;
/// Create a copy of InviteResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InviteResponseCopyWith<InviteResponse> get copyWith => _$InviteResponseCopyWithImpl<InviteResponse>(this as InviteResponse, _$identity);

  /// Serializes this InviteResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InviteResponse&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inviteCode,deepLink);

@override
String toString() {
  return 'InviteResponse(inviteCode: $inviteCode, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class $InviteResponseCopyWith<$Res>  {
  factory $InviteResponseCopyWith(InviteResponse value, $Res Function(InviteResponse) _then) = _$InviteResponseCopyWithImpl;
@useResult
$Res call({
 String inviteCode, String deepLink
});




}
/// @nodoc
class _$InviteResponseCopyWithImpl<$Res>
    implements $InviteResponseCopyWith<$Res> {
  _$InviteResponseCopyWithImpl(this._self, this._then);

  final InviteResponse _self;
  final $Res Function(InviteResponse) _then;

/// Create a copy of InviteResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inviteCode = null,Object? deepLink = null,}) {
  return _then(_self.copyWith(
inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,deepLink: null == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InviteResponse].
extension InviteResponsePatterns on InviteResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InviteResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InviteResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InviteResponse value)  $default,){
final _that = this;
switch (_that) {
case _InviteResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InviteResponse value)?  $default,){
final _that = this;
switch (_that) {
case _InviteResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String inviteCode,  String deepLink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InviteResponse() when $default != null:
return $default(_that.inviteCode,_that.deepLink);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String inviteCode,  String deepLink)  $default,) {final _that = this;
switch (_that) {
case _InviteResponse():
return $default(_that.inviteCode,_that.deepLink);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String inviteCode,  String deepLink)?  $default,) {final _that = this;
switch (_that) {
case _InviteResponse() when $default != null:
return $default(_that.inviteCode,_that.deepLink);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InviteResponse implements InviteResponse {
  const _InviteResponse({required this.inviteCode, required this.deepLink});
  factory _InviteResponse.fromJson(Map<String, dynamic> json) => _$InviteResponseFromJson(json);

@override final  String inviteCode;
@override final  String deepLink;

/// Create a copy of InviteResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteResponseCopyWith<_InviteResponse> get copyWith => __$InviteResponseCopyWithImpl<_InviteResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InviteResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteResponse&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inviteCode,deepLink);

@override
String toString() {
  return 'InviteResponse(inviteCode: $inviteCode, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class _$InviteResponseCopyWith<$Res> implements $InviteResponseCopyWith<$Res> {
  factory _$InviteResponseCopyWith(_InviteResponse value, $Res Function(_InviteResponse) _then) = __$InviteResponseCopyWithImpl;
@override @useResult
$Res call({
 String inviteCode, String deepLink
});




}
/// @nodoc
class __$InviteResponseCopyWithImpl<$Res>
    implements _$InviteResponseCopyWith<$Res> {
  __$InviteResponseCopyWithImpl(this._self, this._then);

  final _InviteResponse _self;
  final $Res Function(_InviteResponse) _then;

/// Create a copy of InviteResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inviteCode = null,Object? deepLink = null,}) {
  return _then(_InviteResponse(
inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,deepLink: null == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
