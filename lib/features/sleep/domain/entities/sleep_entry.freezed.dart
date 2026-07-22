// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sleep_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SleepEntry {

 String get id; DateTime get bedtime; DateTime get wakeTime; SleepQuality? get quality; String? get note; DateTime get createdAt;
/// Create a copy of SleepEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SleepEntryCopyWith<SleepEntry> get copyWith => _$SleepEntryCopyWithImpl<SleepEntry>(this as SleepEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SleepEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.bedtime, bedtime) || other.bedtime == bedtime)&&(identical(other.wakeTime, wakeTime) || other.wakeTime == wakeTime)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,bedtime,wakeTime,quality,note,createdAt);

@override
String toString() {
  return 'SleepEntry(id: $id, bedtime: $bedtime, wakeTime: $wakeTime, quality: $quality, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SleepEntryCopyWith<$Res>  {
  factory $SleepEntryCopyWith(SleepEntry value, $Res Function(SleepEntry) _then) = _$SleepEntryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime bedtime, DateTime wakeTime, SleepQuality? quality, String? note, DateTime createdAt
});




}
/// @nodoc
class _$SleepEntryCopyWithImpl<$Res>
    implements $SleepEntryCopyWith<$Res> {
  _$SleepEntryCopyWithImpl(this._self, this._then);

  final SleepEntry _self;
  final $Res Function(SleepEntry) _then;

/// Create a copy of SleepEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bedtime = null,Object? wakeTime = null,Object? quality = freezed,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bedtime: null == bedtime ? _self.bedtime : bedtime // ignore: cast_nullable_to_non_nullable
as DateTime,wakeTime: null == wakeTime ? _self.wakeTime : wakeTime // ignore: cast_nullable_to_non_nullable
as DateTime,quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as SleepQuality?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SleepEntry].
extension SleepEntryPatterns on SleepEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SleepEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SleepEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SleepEntry value)  $default,){
final _that = this;
switch (_that) {
case _SleepEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SleepEntry value)?  $default,){
final _that = this;
switch (_that) {
case _SleepEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime bedtime,  DateTime wakeTime,  SleepQuality? quality,  String? note,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SleepEntry() when $default != null:
return $default(_that.id,_that.bedtime,_that.wakeTime,_that.quality,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime bedtime,  DateTime wakeTime,  SleepQuality? quality,  String? note,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SleepEntry():
return $default(_that.id,_that.bedtime,_that.wakeTime,_that.quality,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime bedtime,  DateTime wakeTime,  SleepQuality? quality,  String? note,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SleepEntry() when $default != null:
return $default(_that.id,_that.bedtime,_that.wakeTime,_that.quality,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _SleepEntry extends SleepEntry {
  const _SleepEntry({required this.id, required this.bedtime, required this.wakeTime, this.quality, this.note, required this.createdAt}): super._();
  

@override final  String id;
@override final  DateTime bedtime;
@override final  DateTime wakeTime;
@override final  SleepQuality? quality;
@override final  String? note;
@override final  DateTime createdAt;

/// Create a copy of SleepEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SleepEntryCopyWith<_SleepEntry> get copyWith => __$SleepEntryCopyWithImpl<_SleepEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SleepEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.bedtime, bedtime) || other.bedtime == bedtime)&&(identical(other.wakeTime, wakeTime) || other.wakeTime == wakeTime)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,bedtime,wakeTime,quality,note,createdAt);

@override
String toString() {
  return 'SleepEntry(id: $id, bedtime: $bedtime, wakeTime: $wakeTime, quality: $quality, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SleepEntryCopyWith<$Res> implements $SleepEntryCopyWith<$Res> {
  factory _$SleepEntryCopyWith(_SleepEntry value, $Res Function(_SleepEntry) _then) = __$SleepEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime bedtime, DateTime wakeTime, SleepQuality? quality, String? note, DateTime createdAt
});




}
/// @nodoc
class __$SleepEntryCopyWithImpl<$Res>
    implements _$SleepEntryCopyWith<$Res> {
  __$SleepEntryCopyWithImpl(this._self, this._then);

  final _SleepEntry _self;
  final $Res Function(_SleepEntry) _then;

/// Create a copy of SleepEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bedtime = null,Object? wakeTime = null,Object? quality = freezed,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_SleepEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bedtime: null == bedtime ? _self.bedtime : bedtime // ignore: cast_nullable_to_non_nullable
as DateTime,wakeTime: null == wakeTime ? _self.wakeTime : wakeTime // ignore: cast_nullable_to_non_nullable
as DateTime,quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as SleepQuality?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
