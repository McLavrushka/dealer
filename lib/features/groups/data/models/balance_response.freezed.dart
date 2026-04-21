// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'balance_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BalanceUserDto {

 String get userId; String get name; num get balance;
/// Create a copy of BalanceUserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BalanceUserDtoCopyWith<BalanceUserDto> get copyWith => _$BalanceUserDtoCopyWithImpl<BalanceUserDto>(this as BalanceUserDto, _$identity);

  /// Serializes this BalanceUserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BalanceUserDto&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,name,balance);

@override
String toString() {
  return 'BalanceUserDto(userId: $userId, name: $name, balance: $balance)';
}


}

/// @nodoc
abstract mixin class $BalanceUserDtoCopyWith<$Res>  {
  factory $BalanceUserDtoCopyWith(BalanceUserDto value, $Res Function(BalanceUserDto) _then) = _$BalanceUserDtoCopyWithImpl;
@useResult
$Res call({
 String userId, String name, num balance
});




}
/// @nodoc
class _$BalanceUserDtoCopyWithImpl<$Res>
    implements $BalanceUserDtoCopyWith<$Res> {
  _$BalanceUserDtoCopyWithImpl(this._self, this._then);

  final BalanceUserDto _self;
  final $Res Function(BalanceUserDto) _then;

/// Create a copy of BalanceUserDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? name = null,Object? balance = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [BalanceUserDto].
extension BalanceUserDtoPatterns on BalanceUserDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BalanceUserDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BalanceUserDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BalanceUserDto value)  $default,){
final _that = this;
switch (_that) {
case _BalanceUserDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BalanceUserDto value)?  $default,){
final _that = this;
switch (_that) {
case _BalanceUserDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String name,  num balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BalanceUserDto() when $default != null:
return $default(_that.userId,_that.name,_that.balance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String name,  num balance)  $default,) {final _that = this;
switch (_that) {
case _BalanceUserDto():
return $default(_that.userId,_that.name,_that.balance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String name,  num balance)?  $default,) {final _that = this;
switch (_that) {
case _BalanceUserDto() when $default != null:
return $default(_that.userId,_that.name,_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BalanceUserDto implements BalanceUserDto {
  const _BalanceUserDto({required this.userId, required this.name, required this.balance});
  factory _BalanceUserDto.fromJson(Map<String, dynamic> json) => _$BalanceUserDtoFromJson(json);

@override final  String userId;
@override final  String name;
@override final  num balance;

/// Create a copy of BalanceUserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BalanceUserDtoCopyWith<_BalanceUserDto> get copyWith => __$BalanceUserDtoCopyWithImpl<_BalanceUserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BalanceUserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BalanceUserDto&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,name,balance);

@override
String toString() {
  return 'BalanceUserDto(userId: $userId, name: $name, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$BalanceUserDtoCopyWith<$Res> implements $BalanceUserDtoCopyWith<$Res> {
  factory _$BalanceUserDtoCopyWith(_BalanceUserDto value, $Res Function(_BalanceUserDto) _then) = __$BalanceUserDtoCopyWithImpl;
@override @useResult
$Res call({
 String userId, String name, num balance
});




}
/// @nodoc
class __$BalanceUserDtoCopyWithImpl<$Res>
    implements _$BalanceUserDtoCopyWith<$Res> {
  __$BalanceUserDtoCopyWithImpl(this._self, this._then);

  final _BalanceUserDto _self;
  final $Res Function(_BalanceUserDto) _then;

/// Create a copy of BalanceUserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? name = null,Object? balance = null,}) {
  return _then(_BalanceUserDto(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}


/// @nodoc
mixin _$BalanceResponse {

 String get groupId; List<BalanceUserDto> get balances;
/// Create a copy of BalanceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BalanceResponseCopyWith<BalanceResponse> get copyWith => _$BalanceResponseCopyWithImpl<BalanceResponse>(this as BalanceResponse, _$identity);

  /// Serializes this BalanceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BalanceResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&const DeepCollectionEquality().equals(other.balances, balances));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,const DeepCollectionEquality().hash(balances));

@override
String toString() {
  return 'BalanceResponse(groupId: $groupId, balances: $balances)';
}


}

/// @nodoc
abstract mixin class $BalanceResponseCopyWith<$Res>  {
  factory $BalanceResponseCopyWith(BalanceResponse value, $Res Function(BalanceResponse) _then) = _$BalanceResponseCopyWithImpl;
@useResult
$Res call({
 String groupId, List<BalanceUserDto> balances
});




}
/// @nodoc
class _$BalanceResponseCopyWithImpl<$Res>
    implements $BalanceResponseCopyWith<$Res> {
  _$BalanceResponseCopyWithImpl(this._self, this._then);

  final BalanceResponse _self;
  final $Res Function(BalanceResponse) _then;

/// Create a copy of BalanceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = null,Object? balances = null,}) {
  return _then(_self.copyWith(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,balances: null == balances ? _self.balances : balances // ignore: cast_nullable_to_non_nullable
as List<BalanceUserDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [BalanceResponse].
extension BalanceResponsePatterns on BalanceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BalanceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BalanceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BalanceResponse value)  $default,){
final _that = this;
switch (_that) {
case _BalanceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BalanceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BalanceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String groupId,  List<BalanceUserDto> balances)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BalanceResponse() when $default != null:
return $default(_that.groupId,_that.balances);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String groupId,  List<BalanceUserDto> balances)  $default,) {final _that = this;
switch (_that) {
case _BalanceResponse():
return $default(_that.groupId,_that.balances);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String groupId,  List<BalanceUserDto> balances)?  $default,) {final _that = this;
switch (_that) {
case _BalanceResponse() when $default != null:
return $default(_that.groupId,_that.balances);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BalanceResponse implements BalanceResponse {
  const _BalanceResponse({required this.groupId, final  List<BalanceUserDto> balances = const <BalanceUserDto>[]}): _balances = balances;
  factory _BalanceResponse.fromJson(Map<String, dynamic> json) => _$BalanceResponseFromJson(json);

@override final  String groupId;
 final  List<BalanceUserDto> _balances;
@override@JsonKey() List<BalanceUserDto> get balances {
  if (_balances is EqualUnmodifiableListView) return _balances;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_balances);
}


/// Create a copy of BalanceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BalanceResponseCopyWith<_BalanceResponse> get copyWith => __$BalanceResponseCopyWithImpl<_BalanceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BalanceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BalanceResponse&&(identical(other.groupId, groupId) || other.groupId == groupId)&&const DeepCollectionEquality().equals(other._balances, _balances));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,const DeepCollectionEquality().hash(_balances));

@override
String toString() {
  return 'BalanceResponse(groupId: $groupId, balances: $balances)';
}


}

/// @nodoc
abstract mixin class _$BalanceResponseCopyWith<$Res> implements $BalanceResponseCopyWith<$Res> {
  factory _$BalanceResponseCopyWith(_BalanceResponse value, $Res Function(_BalanceResponse) _then) = __$BalanceResponseCopyWithImpl;
@override @useResult
$Res call({
 String groupId, List<BalanceUserDto> balances
});




}
/// @nodoc
class __$BalanceResponseCopyWithImpl<$Res>
    implements _$BalanceResponseCopyWith<$Res> {
  __$BalanceResponseCopyWithImpl(this._self, this._then);

  final _BalanceResponse _self;
  final $Res Function(_BalanceResponse) _then;

/// Create a copy of BalanceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = null,Object? balances = null,}) {
  return _then(_BalanceResponse(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,balances: null == balances ? _self._balances : balances // ignore: cast_nullable_to_non_nullable
as List<BalanceUserDto>,
  ));
}


}

// dart format on
