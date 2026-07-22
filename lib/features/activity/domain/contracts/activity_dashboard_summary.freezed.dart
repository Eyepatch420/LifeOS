// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_dashboard_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivityDashboardSummary {

 int get todaySteps; int get goalSteps; List<DailyActivitySummary> get recentDays;
/// Create a copy of ActivityDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityDashboardSummaryCopyWith<ActivityDashboardSummary> get copyWith => _$ActivityDashboardSummaryCopyWithImpl<ActivityDashboardSummary>(this as ActivityDashboardSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityDashboardSummary&&(identical(other.todaySteps, todaySteps) || other.todaySteps == todaySteps)&&(identical(other.goalSteps, goalSteps) || other.goalSteps == goalSteps)&&const DeepCollectionEquality().equals(other.recentDays, recentDays));
}


@override
int get hashCode => Object.hash(runtimeType,todaySteps,goalSteps,const DeepCollectionEquality().hash(recentDays));

@override
String toString() {
  return 'ActivityDashboardSummary(todaySteps: $todaySteps, goalSteps: $goalSteps, recentDays: $recentDays)';
}


}

/// @nodoc
abstract mixin class $ActivityDashboardSummaryCopyWith<$Res>  {
  factory $ActivityDashboardSummaryCopyWith(ActivityDashboardSummary value, $Res Function(ActivityDashboardSummary) _then) = _$ActivityDashboardSummaryCopyWithImpl;
@useResult
$Res call({
 int todaySteps, int goalSteps, List<DailyActivitySummary> recentDays
});




}
/// @nodoc
class _$ActivityDashboardSummaryCopyWithImpl<$Res>
    implements $ActivityDashboardSummaryCopyWith<$Res> {
  _$ActivityDashboardSummaryCopyWithImpl(this._self, this._then);

  final ActivityDashboardSummary _self;
  final $Res Function(ActivityDashboardSummary) _then;

/// Create a copy of ActivityDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? todaySteps = null,Object? goalSteps = null,Object? recentDays = null,}) {
  return _then(_self.copyWith(
todaySteps: null == todaySteps ? _self.todaySteps : todaySteps // ignore: cast_nullable_to_non_nullable
as int,goalSteps: null == goalSteps ? _self.goalSteps : goalSteps // ignore: cast_nullable_to_non_nullable
as int,recentDays: null == recentDays ? _self.recentDays : recentDays // ignore: cast_nullable_to_non_nullable
as List<DailyActivitySummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityDashboardSummary].
extension ActivityDashboardSummaryPatterns on ActivityDashboardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityDashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityDashboardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityDashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _ActivityDashboardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityDashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityDashboardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int todaySteps,  int goalSteps,  List<DailyActivitySummary> recentDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityDashboardSummary() when $default != null:
return $default(_that.todaySteps,_that.goalSteps,_that.recentDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int todaySteps,  int goalSteps,  List<DailyActivitySummary> recentDays)  $default,) {final _that = this;
switch (_that) {
case _ActivityDashboardSummary():
return $default(_that.todaySteps,_that.goalSteps,_that.recentDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int todaySteps,  int goalSteps,  List<DailyActivitySummary> recentDays)?  $default,) {final _that = this;
switch (_that) {
case _ActivityDashboardSummary() when $default != null:
return $default(_that.todaySteps,_that.goalSteps,_that.recentDays);case _:
  return null;

}
}

}

/// @nodoc


class _ActivityDashboardSummary implements ActivityDashboardSummary {
  const _ActivityDashboardSummary({required this.todaySteps, required this.goalSteps, required final  List<DailyActivitySummary> recentDays}): _recentDays = recentDays;
  

@override final  int todaySteps;
@override final  int goalSteps;
 final  List<DailyActivitySummary> _recentDays;
@override List<DailyActivitySummary> get recentDays {
  if (_recentDays is EqualUnmodifiableListView) return _recentDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentDays);
}


/// Create a copy of ActivityDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityDashboardSummaryCopyWith<_ActivityDashboardSummary> get copyWith => __$ActivityDashboardSummaryCopyWithImpl<_ActivityDashboardSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityDashboardSummary&&(identical(other.todaySteps, todaySteps) || other.todaySteps == todaySteps)&&(identical(other.goalSteps, goalSteps) || other.goalSteps == goalSteps)&&const DeepCollectionEquality().equals(other._recentDays, _recentDays));
}


@override
int get hashCode => Object.hash(runtimeType,todaySteps,goalSteps,const DeepCollectionEquality().hash(_recentDays));

@override
String toString() {
  return 'ActivityDashboardSummary(todaySteps: $todaySteps, goalSteps: $goalSteps, recentDays: $recentDays)';
}


}

/// @nodoc
abstract mixin class _$ActivityDashboardSummaryCopyWith<$Res> implements $ActivityDashboardSummaryCopyWith<$Res> {
  factory _$ActivityDashboardSummaryCopyWith(_ActivityDashboardSummary value, $Res Function(_ActivityDashboardSummary) _then) = __$ActivityDashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 int todaySteps, int goalSteps, List<DailyActivitySummary> recentDays
});




}
/// @nodoc
class __$ActivityDashboardSummaryCopyWithImpl<$Res>
    implements _$ActivityDashboardSummaryCopyWith<$Res> {
  __$ActivityDashboardSummaryCopyWithImpl(this._self, this._then);

  final _ActivityDashboardSummary _self;
  final $Res Function(_ActivityDashboardSummary) _then;

/// Create a copy of ActivityDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? todaySteps = null,Object? goalSteps = null,Object? recentDays = null,}) {
  return _then(_ActivityDashboardSummary(
todaySteps: null == todaySteps ? _self.todaySteps : todaySteps // ignore: cast_nullable_to_non_nullable
as int,goalSteps: null == goalSteps ? _self.goalSteps : goalSteps // ignore: cast_nullable_to_non_nullable
as int,recentDays: null == recentDays ? _self._recentDays : recentDays // ignore: cast_nullable_to_non_nullable
as List<DailyActivitySummary>,
  ));
}


}

/// @nodoc
mixin _$DailyActivitySummary {

 String get dayKey; int get steps; int get goalSteps;
/// Create a copy of DailyActivitySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyActivitySummaryCopyWith<DailyActivitySummary> get copyWith => _$DailyActivitySummaryCopyWithImpl<DailyActivitySummary>(this as DailyActivitySummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyActivitySummary&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.goalSteps, goalSteps) || other.goalSteps == goalSteps));
}


@override
int get hashCode => Object.hash(runtimeType,dayKey,steps,goalSteps);

@override
String toString() {
  return 'DailyActivitySummary(dayKey: $dayKey, steps: $steps, goalSteps: $goalSteps)';
}


}

/// @nodoc
abstract mixin class $DailyActivitySummaryCopyWith<$Res>  {
  factory $DailyActivitySummaryCopyWith(DailyActivitySummary value, $Res Function(DailyActivitySummary) _then) = _$DailyActivitySummaryCopyWithImpl;
@useResult
$Res call({
 String dayKey, int steps, int goalSteps
});




}
/// @nodoc
class _$DailyActivitySummaryCopyWithImpl<$Res>
    implements $DailyActivitySummaryCopyWith<$Res> {
  _$DailyActivitySummaryCopyWithImpl(this._self, this._then);

  final DailyActivitySummary _self;
  final $Res Function(DailyActivitySummary) _then;

/// Create a copy of DailyActivitySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dayKey = null,Object? steps = null,Object? goalSteps = null,}) {
  return _then(_self.copyWith(
dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int,goalSteps: null == goalSteps ? _self.goalSteps : goalSteps // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyActivitySummary].
extension DailyActivitySummaryPatterns on DailyActivitySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyActivitySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyActivitySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyActivitySummary value)  $default,){
final _that = this;
switch (_that) {
case _DailyActivitySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyActivitySummary value)?  $default,){
final _that = this;
switch (_that) {
case _DailyActivitySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String dayKey,  int steps,  int goalSteps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyActivitySummary() when $default != null:
return $default(_that.dayKey,_that.steps,_that.goalSteps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String dayKey,  int steps,  int goalSteps)  $default,) {final _that = this;
switch (_that) {
case _DailyActivitySummary():
return $default(_that.dayKey,_that.steps,_that.goalSteps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String dayKey,  int steps,  int goalSteps)?  $default,) {final _that = this;
switch (_that) {
case _DailyActivitySummary() when $default != null:
return $default(_that.dayKey,_that.steps,_that.goalSteps);case _:
  return null;

}
}

}

/// @nodoc


class _DailyActivitySummary implements DailyActivitySummary {
  const _DailyActivitySummary({required this.dayKey, required this.steps, required this.goalSteps});
  

@override final  String dayKey;
@override final  int steps;
@override final  int goalSteps;

/// Create a copy of DailyActivitySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyActivitySummaryCopyWith<_DailyActivitySummary> get copyWith => __$DailyActivitySummaryCopyWithImpl<_DailyActivitySummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyActivitySummary&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.goalSteps, goalSteps) || other.goalSteps == goalSteps));
}


@override
int get hashCode => Object.hash(runtimeType,dayKey,steps,goalSteps);

@override
String toString() {
  return 'DailyActivitySummary(dayKey: $dayKey, steps: $steps, goalSteps: $goalSteps)';
}


}

/// @nodoc
abstract mixin class _$DailyActivitySummaryCopyWith<$Res> implements $DailyActivitySummaryCopyWith<$Res> {
  factory _$DailyActivitySummaryCopyWith(_DailyActivitySummary value, $Res Function(_DailyActivitySummary) _then) = __$DailyActivitySummaryCopyWithImpl;
@override @useResult
$Res call({
 String dayKey, int steps, int goalSteps
});




}
/// @nodoc
class __$DailyActivitySummaryCopyWithImpl<$Res>
    implements _$DailyActivitySummaryCopyWith<$Res> {
  __$DailyActivitySummaryCopyWithImpl(this._self, this._then);

  final _DailyActivitySummary _self;
  final $Res Function(_DailyActivitySummary) _then;

/// Create a copy of DailyActivitySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dayKey = null,Object? steps = null,Object? goalSteps = null,}) {
  return _then(_DailyActivitySummary(
dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int,goalSteps: null == goalSteps ? _self.goalSteps : goalSteps // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
