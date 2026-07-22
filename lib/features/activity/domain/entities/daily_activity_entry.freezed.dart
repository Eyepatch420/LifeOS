// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_activity_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyActivityEntry {

 String get dayKey; int get steps; int? get distanceMeters; int? get activeMinutes; DateTime get updatedAt;
/// Create a copy of DailyActivityEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyActivityEntryCopyWith<DailyActivityEntry> get copyWith => _$DailyActivityEntryCopyWithImpl<DailyActivityEntry>(this as DailyActivityEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyActivityEntry&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.activeMinutes, activeMinutes) || other.activeMinutes == activeMinutes)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,dayKey,steps,distanceMeters,activeMinutes,updatedAt);

@override
String toString() {
  return 'DailyActivityEntry(dayKey: $dayKey, steps: $steps, distanceMeters: $distanceMeters, activeMinutes: $activeMinutes, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DailyActivityEntryCopyWith<$Res>  {
  factory $DailyActivityEntryCopyWith(DailyActivityEntry value, $Res Function(DailyActivityEntry) _then) = _$DailyActivityEntryCopyWithImpl;
@useResult
$Res call({
 String dayKey, int steps, int? distanceMeters, int? activeMinutes, DateTime updatedAt
});




}
/// @nodoc
class _$DailyActivityEntryCopyWithImpl<$Res>
    implements $DailyActivityEntryCopyWith<$Res> {
  _$DailyActivityEntryCopyWithImpl(this._self, this._then);

  final DailyActivityEntry _self;
  final $Res Function(DailyActivityEntry) _then;

/// Create a copy of DailyActivityEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dayKey = null,Object? steps = null,Object? distanceMeters = freezed,Object? activeMinutes = freezed,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as int?,activeMinutes: freezed == activeMinutes ? _self.activeMinutes : activeMinutes // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyActivityEntry].
extension DailyActivityEntryPatterns on DailyActivityEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyActivityEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyActivityEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyActivityEntry value)  $default,){
final _that = this;
switch (_that) {
case _DailyActivityEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyActivityEntry value)?  $default,){
final _that = this;
switch (_that) {
case _DailyActivityEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String dayKey,  int steps,  int? distanceMeters,  int? activeMinutes,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyActivityEntry() when $default != null:
return $default(_that.dayKey,_that.steps,_that.distanceMeters,_that.activeMinutes,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String dayKey,  int steps,  int? distanceMeters,  int? activeMinutes,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DailyActivityEntry():
return $default(_that.dayKey,_that.steps,_that.distanceMeters,_that.activeMinutes,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String dayKey,  int steps,  int? distanceMeters,  int? activeMinutes,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DailyActivityEntry() when $default != null:
return $default(_that.dayKey,_that.steps,_that.distanceMeters,_that.activeMinutes,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _DailyActivityEntry implements DailyActivityEntry {
  const _DailyActivityEntry({required this.dayKey, required this.steps, this.distanceMeters, this.activeMinutes, required this.updatedAt});
  

@override final  String dayKey;
@override final  int steps;
@override final  int? distanceMeters;
@override final  int? activeMinutes;
@override final  DateTime updatedAt;

/// Create a copy of DailyActivityEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyActivityEntryCopyWith<_DailyActivityEntry> get copyWith => __$DailyActivityEntryCopyWithImpl<_DailyActivityEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyActivityEntry&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.activeMinutes, activeMinutes) || other.activeMinutes == activeMinutes)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,dayKey,steps,distanceMeters,activeMinutes,updatedAt);

@override
String toString() {
  return 'DailyActivityEntry(dayKey: $dayKey, steps: $steps, distanceMeters: $distanceMeters, activeMinutes: $activeMinutes, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DailyActivityEntryCopyWith<$Res> implements $DailyActivityEntryCopyWith<$Res> {
  factory _$DailyActivityEntryCopyWith(_DailyActivityEntry value, $Res Function(_DailyActivityEntry) _then) = __$DailyActivityEntryCopyWithImpl;
@override @useResult
$Res call({
 String dayKey, int steps, int? distanceMeters, int? activeMinutes, DateTime updatedAt
});




}
/// @nodoc
class __$DailyActivityEntryCopyWithImpl<$Res>
    implements _$DailyActivityEntryCopyWith<$Res> {
  __$DailyActivityEntryCopyWithImpl(this._self, this._then);

  final _DailyActivityEntry _self;
  final $Res Function(_DailyActivityEntry) _then;

/// Create a copy of DailyActivityEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dayKey = null,Object? steps = null,Object? distanceMeters = freezed,Object? activeMinutes = freezed,Object? updatedAt = null,}) {
  return _then(_DailyActivityEntry(
dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as int?,activeMinutes: freezed == activeMinutes ? _self.activeMinutes : activeMinutes // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
