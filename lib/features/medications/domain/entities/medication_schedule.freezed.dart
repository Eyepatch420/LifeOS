// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MedicationTime {

 int get hour; int get minute;
/// Create a copy of MedicationTime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationTimeCopyWith<MedicationTime> get copyWith => _$MedicationTimeCopyWithImpl<MedicationTime>(this as MedicationTime, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationTime&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute));
}


@override
int get hashCode => Object.hash(runtimeType,hour,minute);

@override
String toString() {
  return 'MedicationTime(hour: $hour, minute: $minute)';
}


}

/// @nodoc
abstract mixin class $MedicationTimeCopyWith<$Res>  {
  factory $MedicationTimeCopyWith(MedicationTime value, $Res Function(MedicationTime) _then) = _$MedicationTimeCopyWithImpl;
@useResult
$Res call({
 int hour, int minute
});




}
/// @nodoc
class _$MedicationTimeCopyWithImpl<$Res>
    implements $MedicationTimeCopyWith<$Res> {
  _$MedicationTimeCopyWithImpl(this._self, this._then);

  final MedicationTime _self;
  final $Res Function(MedicationTime) _then;

/// Create a copy of MedicationTime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hour = null,Object? minute = null,}) {
  return _then(_self.copyWith(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationTime].
extension MedicationTimePatterns on MedicationTime {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationTime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationTime() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationTime value)  $default,){
final _that = this;
switch (_that) {
case _MedicationTime():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationTime value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationTime() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int hour,  int minute)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationTime() when $default != null:
return $default(_that.hour,_that.minute);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int hour,  int minute)  $default,) {final _that = this;
switch (_that) {
case _MedicationTime():
return $default(_that.hour,_that.minute);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int hour,  int minute)?  $default,) {final _that = this;
switch (_that) {
case _MedicationTime() when $default != null:
return $default(_that.hour,_that.minute);case _:
  return null;

}
}

}

/// @nodoc


class _MedicationTime implements MedicationTime {
  const _MedicationTime({required this.hour, required this.minute});
  

@override final  int hour;
@override final  int minute;

/// Create a copy of MedicationTime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationTimeCopyWith<_MedicationTime> get copyWith => __$MedicationTimeCopyWithImpl<_MedicationTime>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationTime&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute));
}


@override
int get hashCode => Object.hash(runtimeType,hour,minute);

@override
String toString() {
  return 'MedicationTime(hour: $hour, minute: $minute)';
}


}

/// @nodoc
abstract mixin class _$MedicationTimeCopyWith<$Res> implements $MedicationTimeCopyWith<$Res> {
  factory _$MedicationTimeCopyWith(_MedicationTime value, $Res Function(_MedicationTime) _then) = __$MedicationTimeCopyWithImpl;
@override @useResult
$Res call({
 int hour, int minute
});




}
/// @nodoc
class __$MedicationTimeCopyWithImpl<$Res>
    implements _$MedicationTimeCopyWith<$Res> {
  __$MedicationTimeCopyWithImpl(this._self, this._then);

  final _MedicationTime _self;
  final $Res Function(_MedicationTime) _then;

/// Create a copy of MedicationTime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hour = null,Object? minute = null,}) {
  return _then(_MedicationTime(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$MedicationSchedule {

 List<MedicationTime> get times;/// ISO weekday numbers (1=Mon..7=Sun). `null`/empty means every day.
 Set<int>? get days;
/// Create a copy of MedicationSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationScheduleCopyWith<MedicationSchedule> get copyWith => _$MedicationScheduleCopyWithImpl<MedicationSchedule>(this as MedicationSchedule, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationSchedule&&const DeepCollectionEquality().equals(other.times, times)&&const DeepCollectionEquality().equals(other.days, days));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(times),const DeepCollectionEquality().hash(days));

@override
String toString() {
  return 'MedicationSchedule(times: $times, days: $days)';
}


}

/// @nodoc
abstract mixin class $MedicationScheduleCopyWith<$Res>  {
  factory $MedicationScheduleCopyWith(MedicationSchedule value, $Res Function(MedicationSchedule) _then) = _$MedicationScheduleCopyWithImpl;
@useResult
$Res call({
 List<MedicationTime> times, Set<int>? days
});




}
/// @nodoc
class _$MedicationScheduleCopyWithImpl<$Res>
    implements $MedicationScheduleCopyWith<$Res> {
  _$MedicationScheduleCopyWithImpl(this._self, this._then);

  final MedicationSchedule _self;
  final $Res Function(MedicationSchedule) _then;

/// Create a copy of MedicationSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? times = null,Object? days = freezed,}) {
  return _then(_self.copyWith(
times: null == times ? _self.times : times // ignore: cast_nullable_to_non_nullable
as List<MedicationTime>,days: freezed == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as Set<int>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationSchedule].
extension MedicationSchedulePatterns on MedicationSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationSchedule value)  $default,){
final _that = this;
switch (_that) {
case _MedicationSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MedicationTime> times,  Set<int>? days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationSchedule() when $default != null:
return $default(_that.times,_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MedicationTime> times,  Set<int>? days)  $default,) {final _that = this;
switch (_that) {
case _MedicationSchedule():
return $default(_that.times,_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MedicationTime> times,  Set<int>? days)?  $default,) {final _that = this;
switch (_that) {
case _MedicationSchedule() when $default != null:
return $default(_that.times,_that.days);case _:
  return null;

}
}

}

/// @nodoc


class _MedicationSchedule implements MedicationSchedule {
  const _MedicationSchedule({required final  List<MedicationTime> times, final  Set<int>? days}): _times = times,_days = days;
  

 final  List<MedicationTime> _times;
@override List<MedicationTime> get times {
  if (_times is EqualUnmodifiableListView) return _times;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_times);
}

/// ISO weekday numbers (1=Mon..7=Sun). `null`/empty means every day.
 final  Set<int>? _days;
/// ISO weekday numbers (1=Mon..7=Sun). `null`/empty means every day.
@override Set<int>? get days {
  final value = _days;
  if (value == null) return null;
  if (_days is EqualUnmodifiableSetView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(value);
}


/// Create a copy of MedicationSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationScheduleCopyWith<_MedicationSchedule> get copyWith => __$MedicationScheduleCopyWithImpl<_MedicationSchedule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationSchedule&&const DeepCollectionEquality().equals(other._times, _times)&&const DeepCollectionEquality().equals(other._days, _days));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_times),const DeepCollectionEquality().hash(_days));

@override
String toString() {
  return 'MedicationSchedule(times: $times, days: $days)';
}


}

/// @nodoc
abstract mixin class _$MedicationScheduleCopyWith<$Res> implements $MedicationScheduleCopyWith<$Res> {
  factory _$MedicationScheduleCopyWith(_MedicationSchedule value, $Res Function(_MedicationSchedule) _then) = __$MedicationScheduleCopyWithImpl;
@override @useResult
$Res call({
 List<MedicationTime> times, Set<int>? days
});




}
/// @nodoc
class __$MedicationScheduleCopyWithImpl<$Res>
    implements _$MedicationScheduleCopyWith<$Res> {
  __$MedicationScheduleCopyWithImpl(this._self, this._then);

  final _MedicationSchedule _self;
  final $Res Function(_MedicationSchedule) _then;

/// Create a copy of MedicationSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? times = null,Object? days = freezed,}) {
  return _then(_MedicationSchedule(
times: null == times ? _self._times : times // ignore: cast_nullable_to_non_nullable
as List<MedicationTime>,days: freezed == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as Set<int>?,
  ));
}


}

// dart format on
