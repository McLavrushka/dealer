// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupDto {

 String get id; String get name; String get ownerId; String? get inviteCode; String get currency; String get createdAt; List<MemberDto> get members;
/// Create a copy of GroupDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupDtoCopyWith<GroupDto> get copyWith => _$GroupDtoCopyWithImpl<GroupDto>(this as GroupDto, _$identity);

  /// Serializes this GroupDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.members, members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,ownerId,inviteCode,currency,createdAt,const DeepCollectionEquality().hash(members));

@override
String toString() {
  return 'GroupDto(id: $id, name: $name, ownerId: $ownerId, inviteCode: $inviteCode, currency: $currency, createdAt: $createdAt, members: $members)';
}


}

/// @nodoc
abstract mixin class $GroupDtoCopyWith<$Res>  {
  factory $GroupDtoCopyWith(GroupDto value, $Res Function(GroupDto) _then) = _$GroupDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String ownerId, String? inviteCode, String currency, String createdAt, List<MemberDto> members
});




}
/// @nodoc
class _$GroupDtoCopyWithImpl<$Res>
    implements $GroupDtoCopyWith<$Res> {
  _$GroupDtoCopyWithImpl(this._self, this._then);

  final GroupDto _self;
  final $Res Function(GroupDto) _then;

/// Create a copy of GroupDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? ownerId = null,Object? inviteCode = freezed,Object? currency = null,Object? createdAt = null,Object? members = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,inviteCode: freezed == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<MemberDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupDto].
extension GroupDtoPatterns on GroupDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupDto value)  $default,){
final _that = this;
switch (_that) {
case _GroupDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupDto value)?  $default,){
final _that = this;
switch (_that) {
case _GroupDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String ownerId,  String? inviteCode,  String currency,  String createdAt,  List<MemberDto> members)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupDto() when $default != null:
return $default(_that.id,_that.name,_that.ownerId,_that.inviteCode,_that.currency,_that.createdAt,_that.members);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String ownerId,  String? inviteCode,  String currency,  String createdAt,  List<MemberDto> members)  $default,) {final _that = this;
switch (_that) {
case _GroupDto():
return $default(_that.id,_that.name,_that.ownerId,_that.inviteCode,_that.currency,_that.createdAt,_that.members);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String ownerId,  String? inviteCode,  String currency,  String createdAt,  List<MemberDto> members)?  $default,) {final _that = this;
switch (_that) {
case _GroupDto() when $default != null:
return $default(_that.id,_that.name,_that.ownerId,_that.inviteCode,_that.currency,_that.createdAt,_that.members);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupDto implements GroupDto {
  const _GroupDto({required this.id, required this.name, required this.ownerId, this.inviteCode, required this.currency, required this.createdAt, final  List<MemberDto> members = const <MemberDto>[]}): _members = members;
  factory _GroupDto.fromJson(Map<String, dynamic> json) => _$GroupDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String ownerId;
@override final  String? inviteCode;
@override final  String currency;
@override final  String createdAt;
 final  List<MemberDto> _members;
@override@JsonKey() List<MemberDto> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}


/// Create a copy of GroupDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupDtoCopyWith<_GroupDto> get copyWith => __$GroupDtoCopyWithImpl<_GroupDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._members, _members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,ownerId,inviteCode,currency,createdAt,const DeepCollectionEquality().hash(_members));

@override
String toString() {
  return 'GroupDto(id: $id, name: $name, ownerId: $ownerId, inviteCode: $inviteCode, currency: $currency, createdAt: $createdAt, members: $members)';
}


}

/// @nodoc
abstract mixin class _$GroupDtoCopyWith<$Res> implements $GroupDtoCopyWith<$Res> {
  factory _$GroupDtoCopyWith(_GroupDto value, $Res Function(_GroupDto) _then) = __$GroupDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String ownerId, String? inviteCode, String currency, String createdAt, List<MemberDto> members
});




}
/// @nodoc
class __$GroupDtoCopyWithImpl<$Res>
    implements _$GroupDtoCopyWith<$Res> {
  __$GroupDtoCopyWithImpl(this._self, this._then);

  final _GroupDto _self;
  final $Res Function(_GroupDto) _then;

/// Create a copy of GroupDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? ownerId = null,Object? inviteCode = freezed,Object? currency = null,Object? createdAt = null,Object? members = null,}) {
  return _then(_GroupDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,inviteCode: freezed == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<MemberDto>,
  ));
}


}

// dart format on
