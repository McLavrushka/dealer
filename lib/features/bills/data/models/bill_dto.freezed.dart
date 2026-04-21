// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BillDto {

 String get id; String get groupId; String get title; num get total; String get currency; String get status; String? get receiptUrl; String? get spunWinnerId; String get createdAt; List<BillItemDto> get items;
/// Create a copy of BillDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BillDtoCopyWith<BillDto> get copyWith => _$BillDtoCopyWithImpl<BillDto>(this as BillDto, _$identity);

  /// Serializes this BillDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BillDto&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.title, title) || other.title == title)&&(identical(other.total, total) || other.total == total)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl)&&(identical(other.spunWinnerId, spunWinnerId) || other.spunWinnerId == spunWinnerId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,title,total,currency,status,receiptUrl,spunWinnerId,createdAt,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'BillDto(id: $id, groupId: $groupId, title: $title, total: $total, currency: $currency, status: $status, receiptUrl: $receiptUrl, spunWinnerId: $spunWinnerId, createdAt: $createdAt, items: $items)';
}


}

/// @nodoc
abstract mixin class $BillDtoCopyWith<$Res>  {
  factory $BillDtoCopyWith(BillDto value, $Res Function(BillDto) _then) = _$BillDtoCopyWithImpl;
@useResult
$Res call({
 String id, String groupId, String title, num total, String currency, String status, String? receiptUrl, String? spunWinnerId, String createdAt, List<BillItemDto> items
});




}
/// @nodoc
class _$BillDtoCopyWithImpl<$Res>
    implements $BillDtoCopyWith<$Res> {
  _$BillDtoCopyWithImpl(this._self, this._then);

  final BillDto _self;
  final $Res Function(BillDto) _then;

/// Create a copy of BillDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groupId = null,Object? title = null,Object? total = null,Object? currency = null,Object? status = null,Object? receiptUrl = freezed,Object? spunWinnerId = freezed,Object? createdAt = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as num,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,spunWinnerId: freezed == spunWinnerId ? _self.spunWinnerId : spunWinnerId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<BillItemDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [BillDto].
extension BillDtoPatterns on BillDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BillDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BillDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BillDto value)  $default,){
final _that = this;
switch (_that) {
case _BillDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BillDto value)?  $default,){
final _that = this;
switch (_that) {
case _BillDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groupId,  String title,  num total,  String currency,  String status,  String? receiptUrl,  String? spunWinnerId,  String createdAt,  List<BillItemDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BillDto() when $default != null:
return $default(_that.id,_that.groupId,_that.title,_that.total,_that.currency,_that.status,_that.receiptUrl,_that.spunWinnerId,_that.createdAt,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groupId,  String title,  num total,  String currency,  String status,  String? receiptUrl,  String? spunWinnerId,  String createdAt,  List<BillItemDto> items)  $default,) {final _that = this;
switch (_that) {
case _BillDto():
return $default(_that.id,_that.groupId,_that.title,_that.total,_that.currency,_that.status,_that.receiptUrl,_that.spunWinnerId,_that.createdAt,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groupId,  String title,  num total,  String currency,  String status,  String? receiptUrl,  String? spunWinnerId,  String createdAt,  List<BillItemDto> items)?  $default,) {final _that = this;
switch (_that) {
case _BillDto() when $default != null:
return $default(_that.id,_that.groupId,_that.title,_that.total,_that.currency,_that.status,_that.receiptUrl,_that.spunWinnerId,_that.createdAt,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BillDto implements BillDto {
  const _BillDto({required this.id, required this.groupId, required this.title, required this.total, required this.currency, required this.status, this.receiptUrl, this.spunWinnerId, required this.createdAt, final  List<BillItemDto> items = const <BillItemDto>[]}): _items = items;
  factory _BillDto.fromJson(Map<String, dynamic> json) => _$BillDtoFromJson(json);

@override final  String id;
@override final  String groupId;
@override final  String title;
@override final  num total;
@override final  String currency;
@override final  String status;
@override final  String? receiptUrl;
@override final  String? spunWinnerId;
@override final  String createdAt;
 final  List<BillItemDto> _items;
@override@JsonKey() List<BillItemDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of BillDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillDtoCopyWith<_BillDto> get copyWith => __$BillDtoCopyWithImpl<_BillDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BillDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillDto&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.title, title) || other.title == title)&&(identical(other.total, total) || other.total == total)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl)&&(identical(other.spunWinnerId, spunWinnerId) || other.spunWinnerId == spunWinnerId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,title,total,currency,status,receiptUrl,spunWinnerId,createdAt,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'BillDto(id: $id, groupId: $groupId, title: $title, total: $total, currency: $currency, status: $status, receiptUrl: $receiptUrl, spunWinnerId: $spunWinnerId, createdAt: $createdAt, items: $items)';
}


}

/// @nodoc
abstract mixin class _$BillDtoCopyWith<$Res> implements $BillDtoCopyWith<$Res> {
  factory _$BillDtoCopyWith(_BillDto value, $Res Function(_BillDto) _then) = __$BillDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String groupId, String title, num total, String currency, String status, String? receiptUrl, String? spunWinnerId, String createdAt, List<BillItemDto> items
});




}
/// @nodoc
class __$BillDtoCopyWithImpl<$Res>
    implements _$BillDtoCopyWith<$Res> {
  __$BillDtoCopyWithImpl(this._self, this._then);

  final _BillDto _self;
  final $Res Function(_BillDto) _then;

/// Create a copy of BillDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groupId = null,Object? title = null,Object? total = null,Object? currency = null,Object? status = null,Object? receiptUrl = freezed,Object? spunWinnerId = freezed,Object? createdAt = null,Object? items = null,}) {
  return _then(_BillDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as num,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,spunWinnerId: freezed == spunWinnerId ? _self.spunWinnerId : spunWinnerId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<BillItemDto>,
  ));
}


}

// dart format on
