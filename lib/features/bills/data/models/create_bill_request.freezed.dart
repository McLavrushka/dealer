// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_bill_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateBillRequest {

 String get groupId; String get title; String get currency;
/// Create a copy of CreateBillRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateBillRequestCopyWith<CreateBillRequest> get copyWith => _$CreateBillRequestCopyWithImpl<CreateBillRequest>(this as CreateBillRequest, _$identity);

  /// Serializes this CreateBillRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateBillRequest&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.title, title) || other.title == title)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,title,currency);

@override
String toString() {
  return 'CreateBillRequest(groupId: $groupId, title: $title, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $CreateBillRequestCopyWith<$Res>  {
  factory $CreateBillRequestCopyWith(CreateBillRequest value, $Res Function(CreateBillRequest) _then) = _$CreateBillRequestCopyWithImpl;
@useResult
$Res call({
 String groupId, String title, String currency
});




}
/// @nodoc
class _$CreateBillRequestCopyWithImpl<$Res>
    implements $CreateBillRequestCopyWith<$Res> {
  _$CreateBillRequestCopyWithImpl(this._self, this._then);

  final CreateBillRequest _self;
  final $Res Function(CreateBillRequest) _then;

/// Create a copy of CreateBillRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = null,Object? title = null,Object? currency = null,}) {
  return _then(_self.copyWith(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateBillRequest].
extension CreateBillRequestPatterns on CreateBillRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateBillRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateBillRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateBillRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateBillRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateBillRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateBillRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String groupId,  String title,  String currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateBillRequest() when $default != null:
return $default(_that.groupId,_that.title,_that.currency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String groupId,  String title,  String currency)  $default,) {final _that = this;
switch (_that) {
case _CreateBillRequest():
return $default(_that.groupId,_that.title,_that.currency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String groupId,  String title,  String currency)?  $default,) {final _that = this;
switch (_that) {
case _CreateBillRequest() when $default != null:
return $default(_that.groupId,_that.title,_that.currency);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateBillRequest implements CreateBillRequest {
  const _CreateBillRequest({required this.groupId, required this.title, required this.currency});
  factory _CreateBillRequest.fromJson(Map<String, dynamic> json) => _$CreateBillRequestFromJson(json);

@override final  String groupId;
@override final  String title;
@override final  String currency;

/// Create a copy of CreateBillRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateBillRequestCopyWith<_CreateBillRequest> get copyWith => __$CreateBillRequestCopyWithImpl<_CreateBillRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateBillRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateBillRequest&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.title, title) || other.title == title)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,title,currency);

@override
String toString() {
  return 'CreateBillRequest(groupId: $groupId, title: $title, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$CreateBillRequestCopyWith<$Res> implements $CreateBillRequestCopyWith<$Res> {
  factory _$CreateBillRequestCopyWith(_CreateBillRequest value, $Res Function(_CreateBillRequest) _then) = __$CreateBillRequestCopyWithImpl;
@override @useResult
$Res call({
 String groupId, String title, String currency
});




}
/// @nodoc
class __$CreateBillRequestCopyWithImpl<$Res>
    implements _$CreateBillRequestCopyWith<$Res> {
  __$CreateBillRequestCopyWithImpl(this._self, this._then);

  final _CreateBillRequest _self;
  final $Res Function(_CreateBillRequest) _then;

/// Create a copy of CreateBillRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = null,Object? title = null,Object? currency = null,}) {
  return _then(_CreateBillRequest(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
