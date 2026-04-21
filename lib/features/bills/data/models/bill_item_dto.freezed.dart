// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BillItemDto {

 String get id; String get name; num get price; num get quantity; List<SplitDto> get splits;
/// Create a copy of BillItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BillItemDtoCopyWith<BillItemDto> get copyWith => _$BillItemDtoCopyWithImpl<BillItemDto>(this as BillItemDto, _$identity);

  /// Serializes this BillItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BillItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&const DeepCollectionEquality().equals(other.splits, splits));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,price,quantity,const DeepCollectionEquality().hash(splits));

@override
String toString() {
  return 'BillItemDto(id: $id, name: $name, price: $price, quantity: $quantity, splits: $splits)';
}


}

/// @nodoc
abstract mixin class $BillItemDtoCopyWith<$Res>  {
  factory $BillItemDtoCopyWith(BillItemDto value, $Res Function(BillItemDto) _then) = _$BillItemDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, num price, num quantity, List<SplitDto> splits
});




}
/// @nodoc
class _$BillItemDtoCopyWithImpl<$Res>
    implements $BillItemDtoCopyWith<$Res> {
  _$BillItemDtoCopyWithImpl(this._self, this._then);

  final BillItemDto _self;
  final $Res Function(BillItemDto) _then;

/// Create a copy of BillItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? price = null,Object? quantity = null,Object? splits = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,splits: null == splits ? _self.splits : splits // ignore: cast_nullable_to_non_nullable
as List<SplitDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [BillItemDto].
extension BillItemDtoPatterns on BillItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BillItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BillItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BillItemDto value)  $default,){
final _that = this;
switch (_that) {
case _BillItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BillItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _BillItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  num price,  num quantity,  List<SplitDto> splits)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BillItemDto() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.quantity,_that.splits);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  num price,  num quantity,  List<SplitDto> splits)  $default,) {final _that = this;
switch (_that) {
case _BillItemDto():
return $default(_that.id,_that.name,_that.price,_that.quantity,_that.splits);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  num price,  num quantity,  List<SplitDto> splits)?  $default,) {final _that = this;
switch (_that) {
case _BillItemDto() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.quantity,_that.splits);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BillItemDto implements BillItemDto {
  const _BillItemDto({required this.id, required this.name, required this.price, required this.quantity, final  List<SplitDto> splits = const <SplitDto>[]}): _splits = splits;
  factory _BillItemDto.fromJson(Map<String, dynamic> json) => _$BillItemDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  num price;
@override final  num quantity;
 final  List<SplitDto> _splits;
@override@JsonKey() List<SplitDto> get splits {
  if (_splits is EqualUnmodifiableListView) return _splits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_splits);
}


/// Create a copy of BillItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillItemDtoCopyWith<_BillItemDto> get copyWith => __$BillItemDtoCopyWithImpl<_BillItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BillItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&const DeepCollectionEquality().equals(other._splits, _splits));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,price,quantity,const DeepCollectionEquality().hash(_splits));

@override
String toString() {
  return 'BillItemDto(id: $id, name: $name, price: $price, quantity: $quantity, splits: $splits)';
}


}

/// @nodoc
abstract mixin class _$BillItemDtoCopyWith<$Res> implements $BillItemDtoCopyWith<$Res> {
  factory _$BillItemDtoCopyWith(_BillItemDto value, $Res Function(_BillItemDto) _then) = __$BillItemDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, num price, num quantity, List<SplitDto> splits
});




}
/// @nodoc
class __$BillItemDtoCopyWithImpl<$Res>
    implements _$BillItemDtoCopyWith<$Res> {
  __$BillItemDtoCopyWithImpl(this._self, this._then);

  final _BillItemDto _self;
  final $Res Function(_BillItemDto) _then;

/// Create a copy of BillItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? price = null,Object? quantity = null,Object? splits = null,}) {
  return _then(_BillItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,splits: null == splits ? _self._splits : splits // ignore: cast_nullable_to_non_nullable
as List<SplitDto>,
  ));
}


}

// dart format on
