// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_bill_item_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddBillItemRequest {

 String get name; num get price; num get quantity;
/// Create a copy of AddBillItemRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddBillItemRequestCopyWith<AddBillItemRequest> get copyWith => _$AddBillItemRequestCopyWithImpl<AddBillItemRequest>(this as AddBillItemRequest, _$identity);

  /// Serializes this AddBillItemRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddBillItemRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,price,quantity);

@override
String toString() {
  return 'AddBillItemRequest(name: $name, price: $price, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $AddBillItemRequestCopyWith<$Res>  {
  factory $AddBillItemRequestCopyWith(AddBillItemRequest value, $Res Function(AddBillItemRequest) _then) = _$AddBillItemRequestCopyWithImpl;
@useResult
$Res call({
 String name, num price, num quantity
});




}
/// @nodoc
class _$AddBillItemRequestCopyWithImpl<$Res>
    implements $AddBillItemRequestCopyWith<$Res> {
  _$AddBillItemRequestCopyWithImpl(this._self, this._then);

  final AddBillItemRequest _self;
  final $Res Function(AddBillItemRequest) _then;

/// Create a copy of AddBillItemRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? price = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [AddBillItemRequest].
extension AddBillItemRequestPatterns on AddBillItemRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddBillItemRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddBillItemRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddBillItemRequest value)  $default,){
final _that = this;
switch (_that) {
case _AddBillItemRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddBillItemRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AddBillItemRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  num price,  num quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddBillItemRequest() when $default != null:
return $default(_that.name,_that.price,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  num price,  num quantity)  $default,) {final _that = this;
switch (_that) {
case _AddBillItemRequest():
return $default(_that.name,_that.price,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  num price,  num quantity)?  $default,) {final _that = this;
switch (_that) {
case _AddBillItemRequest() when $default != null:
return $default(_that.name,_that.price,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddBillItemRequest implements AddBillItemRequest {
  const _AddBillItemRequest({required this.name, required this.price, required this.quantity});
  factory _AddBillItemRequest.fromJson(Map<String, dynamic> json) => _$AddBillItemRequestFromJson(json);

@override final  String name;
@override final  num price;
@override final  num quantity;

/// Create a copy of AddBillItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddBillItemRequestCopyWith<_AddBillItemRequest> get copyWith => __$AddBillItemRequestCopyWithImpl<_AddBillItemRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddBillItemRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddBillItemRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,price,quantity);

@override
String toString() {
  return 'AddBillItemRequest(name: $name, price: $price, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$AddBillItemRequestCopyWith<$Res> implements $AddBillItemRequestCopyWith<$Res> {
  factory _$AddBillItemRequestCopyWith(_AddBillItemRequest value, $Res Function(_AddBillItemRequest) _then) = __$AddBillItemRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, num price, num quantity
});




}
/// @nodoc
class __$AddBillItemRequestCopyWithImpl<$Res>
    implements _$AddBillItemRequestCopyWith<$Res> {
  __$AddBillItemRequestCopyWithImpl(this._self, this._then);

  final _AddBillItemRequest _self;
  final $Res Function(_AddBillItemRequest) _then;

/// Create a copy of AddBillItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? price = null,Object? quantity = null,}) {
  return _then(_AddBillItemRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
