// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'split_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SplitDto {

 String get id; String get userId; num get shareAmount;
/// Create a copy of SplitDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SplitDtoCopyWith<SplitDto> get copyWith => _$SplitDtoCopyWithImpl<SplitDto>(this as SplitDto, _$identity);

  /// Serializes this SplitDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SplitDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.shareAmount, shareAmount) || other.shareAmount == shareAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,shareAmount);

@override
String toString() {
  return 'SplitDto(id: $id, userId: $userId, shareAmount: $shareAmount)';
}


}

/// @nodoc
abstract mixin class $SplitDtoCopyWith<$Res>  {
  factory $SplitDtoCopyWith(SplitDto value, $Res Function(SplitDto) _then) = _$SplitDtoCopyWithImpl;
@useResult
$Res call({
 String id, String userId, num shareAmount
});




}
/// @nodoc
class _$SplitDtoCopyWithImpl<$Res>
    implements $SplitDtoCopyWith<$Res> {
  _$SplitDtoCopyWithImpl(this._self, this._then);

  final SplitDto _self;
  final $Res Function(SplitDto) _then;

/// Create a copy of SplitDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? shareAmount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,shareAmount: null == shareAmount ? _self.shareAmount : shareAmount // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [SplitDto].
extension SplitDtoPatterns on SplitDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SplitDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SplitDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SplitDto value)  $default,){
final _that = this;
switch (_that) {
case _SplitDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SplitDto value)?  $default,){
final _that = this;
switch (_that) {
case _SplitDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  num shareAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SplitDto() when $default != null:
return $default(_that.id,_that.userId,_that.shareAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  num shareAmount)  $default,) {final _that = this;
switch (_that) {
case _SplitDto():
return $default(_that.id,_that.userId,_that.shareAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  num shareAmount)?  $default,) {final _that = this;
switch (_that) {
case _SplitDto() when $default != null:
return $default(_that.id,_that.userId,_that.shareAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SplitDto implements SplitDto {
  const _SplitDto({required this.id, required this.userId, required this.shareAmount});
  factory _SplitDto.fromJson(Map<String, dynamic> json) => _$SplitDtoFromJson(json);

@override final  String id;
@override final  String userId;
@override final  num shareAmount;

/// Create a copy of SplitDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SplitDtoCopyWith<_SplitDto> get copyWith => __$SplitDtoCopyWithImpl<_SplitDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SplitDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SplitDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.shareAmount, shareAmount) || other.shareAmount == shareAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,shareAmount);

@override
String toString() {
  return 'SplitDto(id: $id, userId: $userId, shareAmount: $shareAmount)';
}


}

/// @nodoc
abstract mixin class _$SplitDtoCopyWith<$Res> implements $SplitDtoCopyWith<$Res> {
  factory _$SplitDtoCopyWith(_SplitDto value, $Res Function(_SplitDto) _then) = __$SplitDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, num shareAmount
});




}
/// @nodoc
class __$SplitDtoCopyWithImpl<$Res>
    implements _$SplitDtoCopyWith<$Res> {
  __$SplitDtoCopyWithImpl(this._self, this._then);

  final _SplitDto _self;
  final $Res Function(_SplitDto) _then;

/// Create a copy of SplitDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? shareAmount = null,}) {
  return _then(_SplitDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,shareAmount: null == shareAmount ? _self.shareAmount : shareAmount // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
