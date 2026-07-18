// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habits_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HabitStreakSummary {

 String get id; String get title; String get icon; int get streakDays; List<bool> get last7Days; bool get isCompletedToday;
/// Create a copy of HabitStreakSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitStreakSummaryCopyWith<HabitStreakSummary> get copyWith => _$HabitStreakSummaryCopyWithImpl<HabitStreakSummary>(this as HabitStreakSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitStreakSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&const DeepCollectionEquality().equals(other.last7Days, last7Days)&&(identical(other.isCompletedToday, isCompletedToday) || other.isCompletedToday == isCompletedToday));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,icon,streakDays,const DeepCollectionEquality().hash(last7Days),isCompletedToday);

@override
String toString() {
  return 'HabitStreakSummary(id: $id, title: $title, icon: $icon, streakDays: $streakDays, last7Days: $last7Days, isCompletedToday: $isCompletedToday)';
}


}

/// @nodoc
abstract mixin class $HabitStreakSummaryCopyWith<$Res>  {
  factory $HabitStreakSummaryCopyWith(HabitStreakSummary value, $Res Function(HabitStreakSummary) _then) = _$HabitStreakSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String title, String icon, int streakDays, List<bool> last7Days, bool isCompletedToday
});




}
/// @nodoc
class _$HabitStreakSummaryCopyWithImpl<$Res>
    implements $HabitStreakSummaryCopyWith<$Res> {
  _$HabitStreakSummaryCopyWithImpl(this._self, this._then);

  final HabitStreakSummary _self;
  final $Res Function(HabitStreakSummary) _then;

/// Create a copy of HabitStreakSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? icon = null,Object? streakDays = null,Object? last7Days = null,Object? isCompletedToday = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,last7Days: null == last7Days ? _self.last7Days : last7Days // ignore: cast_nullable_to_non_nullable
as List<bool>,isCompletedToday: null == isCompletedToday ? _self.isCompletedToday : isCompletedToday // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitStreakSummary].
extension HabitStreakSummaryPatterns on HabitStreakSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitStreakSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitStreakSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitStreakSummary value)  $default,){
final _that = this;
switch (_that) {
case _HabitStreakSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitStreakSummary value)?  $default,){
final _that = this;
switch (_that) {
case _HabitStreakSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String icon,  int streakDays,  List<bool> last7Days,  bool isCompletedToday)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitStreakSummary() when $default != null:
return $default(_that.id,_that.title,_that.icon,_that.streakDays,_that.last7Days,_that.isCompletedToday);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String icon,  int streakDays,  List<bool> last7Days,  bool isCompletedToday)  $default,) {final _that = this;
switch (_that) {
case _HabitStreakSummary():
return $default(_that.id,_that.title,_that.icon,_that.streakDays,_that.last7Days,_that.isCompletedToday);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String icon,  int streakDays,  List<bool> last7Days,  bool isCompletedToday)?  $default,) {final _that = this;
switch (_that) {
case _HabitStreakSummary() when $default != null:
return $default(_that.id,_that.title,_that.icon,_that.streakDays,_that.last7Days,_that.isCompletedToday);case _:
  return null;

}
}

}

/// @nodoc


class _HabitStreakSummary implements HabitStreakSummary {
  const _HabitStreakSummary({required this.id, required this.title, required this.icon, required this.streakDays, required final  List<bool> last7Days, required this.isCompletedToday}): _last7Days = last7Days;
  

@override final  String id;
@override final  String title;
@override final  String icon;
@override final  int streakDays;
 final  List<bool> _last7Days;
@override List<bool> get last7Days {
  if (_last7Days is EqualUnmodifiableListView) return _last7Days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_last7Days);
}

@override final  bool isCompletedToday;

/// Create a copy of HabitStreakSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitStreakSummaryCopyWith<_HabitStreakSummary> get copyWith => __$HabitStreakSummaryCopyWithImpl<_HabitStreakSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitStreakSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&const DeepCollectionEquality().equals(other._last7Days, _last7Days)&&(identical(other.isCompletedToday, isCompletedToday) || other.isCompletedToday == isCompletedToday));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,icon,streakDays,const DeepCollectionEquality().hash(_last7Days),isCompletedToday);

@override
String toString() {
  return 'HabitStreakSummary(id: $id, title: $title, icon: $icon, streakDays: $streakDays, last7Days: $last7Days, isCompletedToday: $isCompletedToday)';
}


}

/// @nodoc
abstract mixin class _$HabitStreakSummaryCopyWith<$Res> implements $HabitStreakSummaryCopyWith<$Res> {
  factory _$HabitStreakSummaryCopyWith(_HabitStreakSummary value, $Res Function(_HabitStreakSummary) _then) = __$HabitStreakSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String icon, int streakDays, List<bool> last7Days, bool isCompletedToday
});




}
/// @nodoc
class __$HabitStreakSummaryCopyWithImpl<$Res>
    implements _$HabitStreakSummaryCopyWith<$Res> {
  __$HabitStreakSummaryCopyWithImpl(this._self, this._then);

  final _HabitStreakSummary _self;
  final $Res Function(_HabitStreakSummary) _then;

/// Create a copy of HabitStreakSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? icon = null,Object? streakDays = null,Object? last7Days = null,Object? isCompletedToday = null,}) {
  return _then(_HabitStreakSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,last7Days: null == last7Days ? _self._last7Days : last7Days // ignore: cast_nullable_to_non_nullable
as List<bool>,isCompletedToday: null == isCompletedToday ? _self.isCompletedToday : isCompletedToday // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$HabitsSummary {

 List<HabitStreakSummary> get streaks; int get scheduledTodayCount; int get completedTodayCount;
/// Create a copy of HabitsSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitsSummaryCopyWith<HabitsSummary> get copyWith => _$HabitsSummaryCopyWithImpl<HabitsSummary>(this as HabitsSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitsSummary&&const DeepCollectionEquality().equals(other.streaks, streaks)&&(identical(other.scheduledTodayCount, scheduledTodayCount) || other.scheduledTodayCount == scheduledTodayCount)&&(identical(other.completedTodayCount, completedTodayCount) || other.completedTodayCount == completedTodayCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(streaks),scheduledTodayCount,completedTodayCount);

@override
String toString() {
  return 'HabitsSummary(streaks: $streaks, scheduledTodayCount: $scheduledTodayCount, completedTodayCount: $completedTodayCount)';
}


}

/// @nodoc
abstract mixin class $HabitsSummaryCopyWith<$Res>  {
  factory $HabitsSummaryCopyWith(HabitsSummary value, $Res Function(HabitsSummary) _then) = _$HabitsSummaryCopyWithImpl;
@useResult
$Res call({
 List<HabitStreakSummary> streaks, int scheduledTodayCount, int completedTodayCount
});




}
/// @nodoc
class _$HabitsSummaryCopyWithImpl<$Res>
    implements $HabitsSummaryCopyWith<$Res> {
  _$HabitsSummaryCopyWithImpl(this._self, this._then);

  final HabitsSummary _self;
  final $Res Function(HabitsSummary) _then;

/// Create a copy of HabitsSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? streaks = null,Object? scheduledTodayCount = null,Object? completedTodayCount = null,}) {
  return _then(_self.copyWith(
streaks: null == streaks ? _self.streaks : streaks // ignore: cast_nullable_to_non_nullable
as List<HabitStreakSummary>,scheduledTodayCount: null == scheduledTodayCount ? _self.scheduledTodayCount : scheduledTodayCount // ignore: cast_nullable_to_non_nullable
as int,completedTodayCount: null == completedTodayCount ? _self.completedTodayCount : completedTodayCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitsSummary].
extension HabitsSummaryPatterns on HabitsSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitsSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitsSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitsSummary value)  $default,){
final _that = this;
switch (_that) {
case _HabitsSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitsSummary value)?  $default,){
final _that = this;
switch (_that) {
case _HabitsSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<HabitStreakSummary> streaks,  int scheduledTodayCount,  int completedTodayCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitsSummary() when $default != null:
return $default(_that.streaks,_that.scheduledTodayCount,_that.completedTodayCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<HabitStreakSummary> streaks,  int scheduledTodayCount,  int completedTodayCount)  $default,) {final _that = this;
switch (_that) {
case _HabitsSummary():
return $default(_that.streaks,_that.scheduledTodayCount,_that.completedTodayCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<HabitStreakSummary> streaks,  int scheduledTodayCount,  int completedTodayCount)?  $default,) {final _that = this;
switch (_that) {
case _HabitsSummary() when $default != null:
return $default(_that.streaks,_that.scheduledTodayCount,_that.completedTodayCount);case _:
  return null;

}
}

}

/// @nodoc


class _HabitsSummary implements HabitsSummary {
  const _HabitsSummary({required final  List<HabitStreakSummary> streaks, required this.scheduledTodayCount, required this.completedTodayCount}): _streaks = streaks;
  

 final  List<HabitStreakSummary> _streaks;
@override List<HabitStreakSummary> get streaks {
  if (_streaks is EqualUnmodifiableListView) return _streaks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_streaks);
}

@override final  int scheduledTodayCount;
@override final  int completedTodayCount;

/// Create a copy of HabitsSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitsSummaryCopyWith<_HabitsSummary> get copyWith => __$HabitsSummaryCopyWithImpl<_HabitsSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitsSummary&&const DeepCollectionEquality().equals(other._streaks, _streaks)&&(identical(other.scheduledTodayCount, scheduledTodayCount) || other.scheduledTodayCount == scheduledTodayCount)&&(identical(other.completedTodayCount, completedTodayCount) || other.completedTodayCount == completedTodayCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_streaks),scheduledTodayCount,completedTodayCount);

@override
String toString() {
  return 'HabitsSummary(streaks: $streaks, scheduledTodayCount: $scheduledTodayCount, completedTodayCount: $completedTodayCount)';
}


}

/// @nodoc
abstract mixin class _$HabitsSummaryCopyWith<$Res> implements $HabitsSummaryCopyWith<$Res> {
  factory _$HabitsSummaryCopyWith(_HabitsSummary value, $Res Function(_HabitsSummary) _then) = __$HabitsSummaryCopyWithImpl;
@override @useResult
$Res call({
 List<HabitStreakSummary> streaks, int scheduledTodayCount, int completedTodayCount
});




}
/// @nodoc
class __$HabitsSummaryCopyWithImpl<$Res>
    implements _$HabitsSummaryCopyWith<$Res> {
  __$HabitsSummaryCopyWithImpl(this._self, this._then);

  final _HabitsSummary _self;
  final $Res Function(_HabitsSummary) _then;

/// Create a copy of HabitsSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? streaks = null,Object? scheduledTodayCount = null,Object? completedTodayCount = null,}) {
  return _then(_HabitsSummary(
streaks: null == streaks ? _self._streaks : streaks // ignore: cast_nullable_to_non_nullable
as List<HabitStreakSummary>,scheduledTodayCount: null == scheduledTodayCount ? _self.scheduledTodayCount : scheduledTodayCount // ignore: cast_nullable_to_non_nullable
as int,completedTodayCount: null == completedTodayCount ? _self.completedTodayCount : completedTodayCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
