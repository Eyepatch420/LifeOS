// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'focus_dashboard_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FocusDashboardSummary {

 Duration get todayFocusedDuration; List<FocusSessionSummary> get recentSessions; FocusSessionSummary? get activeSession;
/// Create a copy of FocusDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FocusDashboardSummaryCopyWith<FocusDashboardSummary> get copyWith => _$FocusDashboardSummaryCopyWithImpl<FocusDashboardSummary>(this as FocusDashboardSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FocusDashboardSummary&&(identical(other.todayFocusedDuration, todayFocusedDuration) || other.todayFocusedDuration == todayFocusedDuration)&&const DeepCollectionEquality().equals(other.recentSessions, recentSessions)&&(identical(other.activeSession, activeSession) || other.activeSession == activeSession));
}


@override
int get hashCode => Object.hash(runtimeType,todayFocusedDuration,const DeepCollectionEquality().hash(recentSessions),activeSession);

@override
String toString() {
  return 'FocusDashboardSummary(todayFocusedDuration: $todayFocusedDuration, recentSessions: $recentSessions, activeSession: $activeSession)';
}


}

/// @nodoc
abstract mixin class $FocusDashboardSummaryCopyWith<$Res>  {
  factory $FocusDashboardSummaryCopyWith(FocusDashboardSummary value, $Res Function(FocusDashboardSummary) _then) = _$FocusDashboardSummaryCopyWithImpl;
@useResult
$Res call({
 Duration todayFocusedDuration, List<FocusSessionSummary> recentSessions, FocusSessionSummary? activeSession
});


$FocusSessionSummaryCopyWith<$Res>? get activeSession;

}
/// @nodoc
class _$FocusDashboardSummaryCopyWithImpl<$Res>
    implements $FocusDashboardSummaryCopyWith<$Res> {
  _$FocusDashboardSummaryCopyWithImpl(this._self, this._then);

  final FocusDashboardSummary _self;
  final $Res Function(FocusDashboardSummary) _then;

/// Create a copy of FocusDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? todayFocusedDuration = null,Object? recentSessions = null,Object? activeSession = freezed,}) {
  return _then(_self.copyWith(
todayFocusedDuration: null == todayFocusedDuration ? _self.todayFocusedDuration : todayFocusedDuration // ignore: cast_nullable_to_non_nullable
as Duration,recentSessions: null == recentSessions ? _self.recentSessions : recentSessions // ignore: cast_nullable_to_non_nullable
as List<FocusSessionSummary>,activeSession: freezed == activeSession ? _self.activeSession : activeSession // ignore: cast_nullable_to_non_nullable
as FocusSessionSummary?,
  ));
}
/// Create a copy of FocusDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FocusSessionSummaryCopyWith<$Res>? get activeSession {
    if (_self.activeSession == null) {
    return null;
  }

  return $FocusSessionSummaryCopyWith<$Res>(_self.activeSession!, (value) {
    return _then(_self.copyWith(activeSession: value));
  });
}
}


/// Adds pattern-matching-related methods to [FocusDashboardSummary].
extension FocusDashboardSummaryPatterns on FocusDashboardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FocusDashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FocusDashboardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FocusDashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _FocusDashboardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FocusDashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _FocusDashboardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Duration todayFocusedDuration,  List<FocusSessionSummary> recentSessions,  FocusSessionSummary? activeSession)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FocusDashboardSummary() when $default != null:
return $default(_that.todayFocusedDuration,_that.recentSessions,_that.activeSession);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Duration todayFocusedDuration,  List<FocusSessionSummary> recentSessions,  FocusSessionSummary? activeSession)  $default,) {final _that = this;
switch (_that) {
case _FocusDashboardSummary():
return $default(_that.todayFocusedDuration,_that.recentSessions,_that.activeSession);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Duration todayFocusedDuration,  List<FocusSessionSummary> recentSessions,  FocusSessionSummary? activeSession)?  $default,) {final _that = this;
switch (_that) {
case _FocusDashboardSummary() when $default != null:
return $default(_that.todayFocusedDuration,_that.recentSessions,_that.activeSession);case _:
  return null;

}
}

}

/// @nodoc


class _FocusDashboardSummary implements FocusDashboardSummary {
  const _FocusDashboardSummary({required this.todayFocusedDuration, required final  List<FocusSessionSummary> recentSessions, this.activeSession}): _recentSessions = recentSessions;
  

@override final  Duration todayFocusedDuration;
 final  List<FocusSessionSummary> _recentSessions;
@override List<FocusSessionSummary> get recentSessions {
  if (_recentSessions is EqualUnmodifiableListView) return _recentSessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentSessions);
}

@override final  FocusSessionSummary? activeSession;

/// Create a copy of FocusDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FocusDashboardSummaryCopyWith<_FocusDashboardSummary> get copyWith => __$FocusDashboardSummaryCopyWithImpl<_FocusDashboardSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FocusDashboardSummary&&(identical(other.todayFocusedDuration, todayFocusedDuration) || other.todayFocusedDuration == todayFocusedDuration)&&const DeepCollectionEquality().equals(other._recentSessions, _recentSessions)&&(identical(other.activeSession, activeSession) || other.activeSession == activeSession));
}


@override
int get hashCode => Object.hash(runtimeType,todayFocusedDuration,const DeepCollectionEquality().hash(_recentSessions),activeSession);

@override
String toString() {
  return 'FocusDashboardSummary(todayFocusedDuration: $todayFocusedDuration, recentSessions: $recentSessions, activeSession: $activeSession)';
}


}

/// @nodoc
abstract mixin class _$FocusDashboardSummaryCopyWith<$Res> implements $FocusDashboardSummaryCopyWith<$Res> {
  factory _$FocusDashboardSummaryCopyWith(_FocusDashboardSummary value, $Res Function(_FocusDashboardSummary) _then) = __$FocusDashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 Duration todayFocusedDuration, List<FocusSessionSummary> recentSessions, FocusSessionSummary? activeSession
});


@override $FocusSessionSummaryCopyWith<$Res>? get activeSession;

}
/// @nodoc
class __$FocusDashboardSummaryCopyWithImpl<$Res>
    implements _$FocusDashboardSummaryCopyWith<$Res> {
  __$FocusDashboardSummaryCopyWithImpl(this._self, this._then);

  final _FocusDashboardSummary _self;
  final $Res Function(_FocusDashboardSummary) _then;

/// Create a copy of FocusDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? todayFocusedDuration = null,Object? recentSessions = null,Object? activeSession = freezed,}) {
  return _then(_FocusDashboardSummary(
todayFocusedDuration: null == todayFocusedDuration ? _self.todayFocusedDuration : todayFocusedDuration // ignore: cast_nullable_to_non_nullable
as Duration,recentSessions: null == recentSessions ? _self._recentSessions : recentSessions // ignore: cast_nullable_to_non_nullable
as List<FocusSessionSummary>,activeSession: freezed == activeSession ? _self.activeSession : activeSession // ignore: cast_nullable_to_non_nullable
as FocusSessionSummary?,
  ));
}

/// Create a copy of FocusDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FocusSessionSummaryCopyWith<$Res>? get activeSession {
    if (_self.activeSession == null) {
    return null;
  }

  return $FocusSessionSummaryCopyWith<$Res>(_self.activeSession!, (value) {
    return _then(_self.copyWith(activeSession: value));
  });
}
}

/// @nodoc
mixin _$FocusSessionSummary {

 String get id; int get plannedMinutes; int get elapsedMinutes; bool get isPaused; DateTime get startedAt; FocusSessionStatus get status; DateTime? get endedAt;
/// Create a copy of FocusSessionSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FocusSessionSummaryCopyWith<FocusSessionSummary> get copyWith => _$FocusSessionSummaryCopyWithImpl<FocusSessionSummary>(this as FocusSessionSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FocusSessionSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.plannedMinutes, plannedMinutes) || other.plannedMinutes == plannedMinutes)&&(identical(other.elapsedMinutes, elapsedMinutes) || other.elapsedMinutes == elapsedMinutes)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,plannedMinutes,elapsedMinutes,isPaused,startedAt,status,endedAt);

@override
String toString() {
  return 'FocusSessionSummary(id: $id, plannedMinutes: $plannedMinutes, elapsedMinutes: $elapsedMinutes, isPaused: $isPaused, startedAt: $startedAt, status: $status, endedAt: $endedAt)';
}


}

/// @nodoc
abstract mixin class $FocusSessionSummaryCopyWith<$Res>  {
  factory $FocusSessionSummaryCopyWith(FocusSessionSummary value, $Res Function(FocusSessionSummary) _then) = _$FocusSessionSummaryCopyWithImpl;
@useResult
$Res call({
 String id, int plannedMinutes, int elapsedMinutes, bool isPaused, DateTime startedAt, FocusSessionStatus status, DateTime? endedAt
});




}
/// @nodoc
class _$FocusSessionSummaryCopyWithImpl<$Res>
    implements $FocusSessionSummaryCopyWith<$Res> {
  _$FocusSessionSummaryCopyWithImpl(this._self, this._then);

  final FocusSessionSummary _self;
  final $Res Function(FocusSessionSummary) _then;

/// Create a copy of FocusSessionSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? plannedMinutes = null,Object? elapsedMinutes = null,Object? isPaused = null,Object? startedAt = null,Object? status = null,Object? endedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,plannedMinutes: null == plannedMinutes ? _self.plannedMinutes : plannedMinutes // ignore: cast_nullable_to_non_nullable
as int,elapsedMinutes: null == elapsedMinutes ? _self.elapsedMinutes : elapsedMinutes // ignore: cast_nullable_to_non_nullable
as int,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FocusSessionStatus,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FocusSessionSummary].
extension FocusSessionSummaryPatterns on FocusSessionSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FocusSessionSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FocusSessionSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FocusSessionSummary value)  $default,){
final _that = this;
switch (_that) {
case _FocusSessionSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FocusSessionSummary value)?  $default,){
final _that = this;
switch (_that) {
case _FocusSessionSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int plannedMinutes,  int elapsedMinutes,  bool isPaused,  DateTime startedAt,  FocusSessionStatus status,  DateTime? endedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FocusSessionSummary() when $default != null:
return $default(_that.id,_that.plannedMinutes,_that.elapsedMinutes,_that.isPaused,_that.startedAt,_that.status,_that.endedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int plannedMinutes,  int elapsedMinutes,  bool isPaused,  DateTime startedAt,  FocusSessionStatus status,  DateTime? endedAt)  $default,) {final _that = this;
switch (_that) {
case _FocusSessionSummary():
return $default(_that.id,_that.plannedMinutes,_that.elapsedMinutes,_that.isPaused,_that.startedAt,_that.status,_that.endedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int plannedMinutes,  int elapsedMinutes,  bool isPaused,  DateTime startedAt,  FocusSessionStatus status,  DateTime? endedAt)?  $default,) {final _that = this;
switch (_that) {
case _FocusSessionSummary() when $default != null:
return $default(_that.id,_that.plannedMinutes,_that.elapsedMinutes,_that.isPaused,_that.startedAt,_that.status,_that.endedAt);case _:
  return null;

}
}

}

/// @nodoc


class _FocusSessionSummary implements FocusSessionSummary {
  const _FocusSessionSummary({required this.id, required this.plannedMinutes, required this.elapsedMinutes, required this.isPaused, required this.startedAt, required this.status, this.endedAt});
  

@override final  String id;
@override final  int plannedMinutes;
@override final  int elapsedMinutes;
@override final  bool isPaused;
@override final  DateTime startedAt;
@override final  FocusSessionStatus status;
@override final  DateTime? endedAt;

/// Create a copy of FocusSessionSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FocusSessionSummaryCopyWith<_FocusSessionSummary> get copyWith => __$FocusSessionSummaryCopyWithImpl<_FocusSessionSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FocusSessionSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.plannedMinutes, plannedMinutes) || other.plannedMinutes == plannedMinutes)&&(identical(other.elapsedMinutes, elapsedMinutes) || other.elapsedMinutes == elapsedMinutes)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,plannedMinutes,elapsedMinutes,isPaused,startedAt,status,endedAt);

@override
String toString() {
  return 'FocusSessionSummary(id: $id, plannedMinutes: $plannedMinutes, elapsedMinutes: $elapsedMinutes, isPaused: $isPaused, startedAt: $startedAt, status: $status, endedAt: $endedAt)';
}


}

/// @nodoc
abstract mixin class _$FocusSessionSummaryCopyWith<$Res> implements $FocusSessionSummaryCopyWith<$Res> {
  factory _$FocusSessionSummaryCopyWith(_FocusSessionSummary value, $Res Function(_FocusSessionSummary) _then) = __$FocusSessionSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, int plannedMinutes, int elapsedMinutes, bool isPaused, DateTime startedAt, FocusSessionStatus status, DateTime? endedAt
});




}
/// @nodoc
class __$FocusSessionSummaryCopyWithImpl<$Res>
    implements _$FocusSessionSummaryCopyWith<$Res> {
  __$FocusSessionSummaryCopyWithImpl(this._self, this._then);

  final _FocusSessionSummary _self;
  final $Res Function(_FocusSessionSummary) _then;

/// Create a copy of FocusSessionSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? plannedMinutes = null,Object? elapsedMinutes = null,Object? isPaused = null,Object? startedAt = null,Object? status = null,Object? endedAt = freezed,}) {
  return _then(_FocusSessionSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,plannedMinutes: null == plannedMinutes ? _self.plannedMinutes : plannedMinutes // ignore: cast_nullable_to_non_nullable
as int,elapsedMinutes: null == elapsedMinutes ? _self.elapsedMinutes : elapsedMinutes // ignore: cast_nullable_to_non_nullable
as int,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FocusSessionStatus,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
