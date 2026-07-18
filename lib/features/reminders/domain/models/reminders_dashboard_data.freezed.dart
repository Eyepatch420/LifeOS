// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminders_dashboard_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RemindersDashboardData {

 List<Reminder> get today; List<Reminder> get upcoming; List<Reminder> get overdue; Reminder? get upNext; int get pendingCount; int get completedCount; int get overdueCount; int get todayCount;
/// Create a copy of RemindersDashboardData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemindersDashboardDataCopyWith<RemindersDashboardData> get copyWith => _$RemindersDashboardDataCopyWithImpl<RemindersDashboardData>(this as RemindersDashboardData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemindersDashboardData&&const DeepCollectionEquality().equals(other.today, today)&&const DeepCollectionEquality().equals(other.upcoming, upcoming)&&const DeepCollectionEquality().equals(other.overdue, overdue)&&(identical(other.upNext, upNext) || other.upNext == upNext)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.overdueCount, overdueCount) || other.overdueCount == overdueCount)&&(identical(other.todayCount, todayCount) || other.todayCount == todayCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(today),const DeepCollectionEquality().hash(upcoming),const DeepCollectionEquality().hash(overdue),upNext,pendingCount,completedCount,overdueCount,todayCount);

@override
String toString() {
  return 'RemindersDashboardData(today: $today, upcoming: $upcoming, overdue: $overdue, upNext: $upNext, pendingCount: $pendingCount, completedCount: $completedCount, overdueCount: $overdueCount, todayCount: $todayCount)';
}


}

/// @nodoc
abstract mixin class $RemindersDashboardDataCopyWith<$Res>  {
  factory $RemindersDashboardDataCopyWith(RemindersDashboardData value, $Res Function(RemindersDashboardData) _then) = _$RemindersDashboardDataCopyWithImpl;
@useResult
$Res call({
 List<Reminder> today, List<Reminder> upcoming, List<Reminder> overdue, Reminder? upNext, int pendingCount, int completedCount, int overdueCount, int todayCount
});


$ReminderCopyWith<$Res>? get upNext;

}
/// @nodoc
class _$RemindersDashboardDataCopyWithImpl<$Res>
    implements $RemindersDashboardDataCopyWith<$Res> {
  _$RemindersDashboardDataCopyWithImpl(this._self, this._then);

  final RemindersDashboardData _self;
  final $Res Function(RemindersDashboardData) _then;

/// Create a copy of RemindersDashboardData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? today = null,Object? upcoming = null,Object? overdue = null,Object? upNext = freezed,Object? pendingCount = null,Object? completedCount = null,Object? overdueCount = null,Object? todayCount = null,}) {
  return _then(_self.copyWith(
today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as List<Reminder>,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<Reminder>,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as List<Reminder>,upNext: freezed == upNext ? _self.upNext : upNext // ignore: cast_nullable_to_non_nullable
as Reminder?,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,todayCount: null == todayCount ? _self.todayCount : todayCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of RemindersDashboardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReminderCopyWith<$Res>? get upNext {
    if (_self.upNext == null) {
    return null;
  }

  return $ReminderCopyWith<$Res>(_self.upNext!, (value) {
    return _then(_self.copyWith(upNext: value));
  });
}
}


/// Adds pattern-matching-related methods to [RemindersDashboardData].
extension RemindersDashboardDataPatterns on RemindersDashboardData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RemindersDashboardData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemindersDashboardData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RemindersDashboardData value)  $default,){
final _that = this;
switch (_that) {
case _RemindersDashboardData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RemindersDashboardData value)?  $default,){
final _that = this;
switch (_that) {
case _RemindersDashboardData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Reminder> today,  List<Reminder> upcoming,  List<Reminder> overdue,  Reminder? upNext,  int pendingCount,  int completedCount,  int overdueCount,  int todayCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemindersDashboardData() when $default != null:
return $default(_that.today,_that.upcoming,_that.overdue,_that.upNext,_that.pendingCount,_that.completedCount,_that.overdueCount,_that.todayCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Reminder> today,  List<Reminder> upcoming,  List<Reminder> overdue,  Reminder? upNext,  int pendingCount,  int completedCount,  int overdueCount,  int todayCount)  $default,) {final _that = this;
switch (_that) {
case _RemindersDashboardData():
return $default(_that.today,_that.upcoming,_that.overdue,_that.upNext,_that.pendingCount,_that.completedCount,_that.overdueCount,_that.todayCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Reminder> today,  List<Reminder> upcoming,  List<Reminder> overdue,  Reminder? upNext,  int pendingCount,  int completedCount,  int overdueCount,  int todayCount)?  $default,) {final _that = this;
switch (_that) {
case _RemindersDashboardData() when $default != null:
return $default(_that.today,_that.upcoming,_that.overdue,_that.upNext,_that.pendingCount,_that.completedCount,_that.overdueCount,_that.todayCount);case _:
  return null;

}
}

}

/// @nodoc


class _RemindersDashboardData extends RemindersDashboardData {
  const _RemindersDashboardData({required final  List<Reminder> today, required final  List<Reminder> upcoming, required final  List<Reminder> overdue, required this.upNext, required this.pendingCount, required this.completedCount, required this.overdueCount, required this.todayCount}): _today = today,_upcoming = upcoming,_overdue = overdue,super._();
  

 final  List<Reminder> _today;
@override List<Reminder> get today {
  if (_today is EqualUnmodifiableListView) return _today;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_today);
}

 final  List<Reminder> _upcoming;
@override List<Reminder> get upcoming {
  if (_upcoming is EqualUnmodifiableListView) return _upcoming;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upcoming);
}

 final  List<Reminder> _overdue;
@override List<Reminder> get overdue {
  if (_overdue is EqualUnmodifiableListView) return _overdue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_overdue);
}

@override final  Reminder? upNext;
@override final  int pendingCount;
@override final  int completedCount;
@override final  int overdueCount;
@override final  int todayCount;

/// Create a copy of RemindersDashboardData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemindersDashboardDataCopyWith<_RemindersDashboardData> get copyWith => __$RemindersDashboardDataCopyWithImpl<_RemindersDashboardData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemindersDashboardData&&const DeepCollectionEquality().equals(other._today, _today)&&const DeepCollectionEquality().equals(other._upcoming, _upcoming)&&const DeepCollectionEquality().equals(other._overdue, _overdue)&&(identical(other.upNext, upNext) || other.upNext == upNext)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.overdueCount, overdueCount) || other.overdueCount == overdueCount)&&(identical(other.todayCount, todayCount) || other.todayCount == todayCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_today),const DeepCollectionEquality().hash(_upcoming),const DeepCollectionEquality().hash(_overdue),upNext,pendingCount,completedCount,overdueCount,todayCount);

@override
String toString() {
  return 'RemindersDashboardData(today: $today, upcoming: $upcoming, overdue: $overdue, upNext: $upNext, pendingCount: $pendingCount, completedCount: $completedCount, overdueCount: $overdueCount, todayCount: $todayCount)';
}


}

/// @nodoc
abstract mixin class _$RemindersDashboardDataCopyWith<$Res> implements $RemindersDashboardDataCopyWith<$Res> {
  factory _$RemindersDashboardDataCopyWith(_RemindersDashboardData value, $Res Function(_RemindersDashboardData) _then) = __$RemindersDashboardDataCopyWithImpl;
@override @useResult
$Res call({
 List<Reminder> today, List<Reminder> upcoming, List<Reminder> overdue, Reminder? upNext, int pendingCount, int completedCount, int overdueCount, int todayCount
});


@override $ReminderCopyWith<$Res>? get upNext;

}
/// @nodoc
class __$RemindersDashboardDataCopyWithImpl<$Res>
    implements _$RemindersDashboardDataCopyWith<$Res> {
  __$RemindersDashboardDataCopyWithImpl(this._self, this._then);

  final _RemindersDashboardData _self;
  final $Res Function(_RemindersDashboardData) _then;

/// Create a copy of RemindersDashboardData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? today = null,Object? upcoming = null,Object? overdue = null,Object? upNext = freezed,Object? pendingCount = null,Object? completedCount = null,Object? overdueCount = null,Object? todayCount = null,}) {
  return _then(_RemindersDashboardData(
today: null == today ? _self._today : today // ignore: cast_nullable_to_non_nullable
as List<Reminder>,upcoming: null == upcoming ? _self._upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<Reminder>,overdue: null == overdue ? _self._overdue : overdue // ignore: cast_nullable_to_non_nullable
as List<Reminder>,upNext: freezed == upNext ? _self.upNext : upNext // ignore: cast_nullable_to_non_nullable
as Reminder?,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,todayCount: null == todayCount ? _self.todayCount : todayCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of RemindersDashboardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReminderCopyWith<$Res>? get upNext {
    if (_self.upNext == null) {
    return null;
  }

  return $ReminderCopyWith<$Res>(_self.upNext!, (value) {
    return _then(_self.copyWith(upNext: value));
  });
}
}

// dart format on
