// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sleep_dashboard_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SleepDashboardSummary {

/// The most recent record's duration/quality, or `null` if nothing has
/// been logged yet — an honest empty state, never a fabricated default.
 Duration? get latestDuration; String? get latestQualityLabel; List<SleepEntrySummary> get recentEntries;
/// Create a copy of SleepDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SleepDashboardSummaryCopyWith<SleepDashboardSummary> get copyWith => _$SleepDashboardSummaryCopyWithImpl<SleepDashboardSummary>(this as SleepDashboardSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SleepDashboardSummary&&(identical(other.latestDuration, latestDuration) || other.latestDuration == latestDuration)&&(identical(other.latestQualityLabel, latestQualityLabel) || other.latestQualityLabel == latestQualityLabel)&&const DeepCollectionEquality().equals(other.recentEntries, recentEntries));
}


@override
int get hashCode => Object.hash(runtimeType,latestDuration,latestQualityLabel,const DeepCollectionEquality().hash(recentEntries));

@override
String toString() {
  return 'SleepDashboardSummary(latestDuration: $latestDuration, latestQualityLabel: $latestQualityLabel, recentEntries: $recentEntries)';
}


}

/// @nodoc
abstract mixin class $SleepDashboardSummaryCopyWith<$Res>  {
  factory $SleepDashboardSummaryCopyWith(SleepDashboardSummary value, $Res Function(SleepDashboardSummary) _then) = _$SleepDashboardSummaryCopyWithImpl;
@useResult
$Res call({
 Duration? latestDuration, String? latestQualityLabel, List<SleepEntrySummary> recentEntries
});




}
/// @nodoc
class _$SleepDashboardSummaryCopyWithImpl<$Res>
    implements $SleepDashboardSummaryCopyWith<$Res> {
  _$SleepDashboardSummaryCopyWithImpl(this._self, this._then);

  final SleepDashboardSummary _self;
  final $Res Function(SleepDashboardSummary) _then;

/// Create a copy of SleepDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latestDuration = freezed,Object? latestQualityLabel = freezed,Object? recentEntries = null,}) {
  return _then(_self.copyWith(
latestDuration: freezed == latestDuration ? _self.latestDuration : latestDuration // ignore: cast_nullable_to_non_nullable
as Duration?,latestQualityLabel: freezed == latestQualityLabel ? _self.latestQualityLabel : latestQualityLabel // ignore: cast_nullable_to_non_nullable
as String?,recentEntries: null == recentEntries ? _self.recentEntries : recentEntries // ignore: cast_nullable_to_non_nullable
as List<SleepEntrySummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [SleepDashboardSummary].
extension SleepDashboardSummaryPatterns on SleepDashboardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SleepDashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SleepDashboardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SleepDashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _SleepDashboardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SleepDashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SleepDashboardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Duration? latestDuration,  String? latestQualityLabel,  List<SleepEntrySummary> recentEntries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SleepDashboardSummary() when $default != null:
return $default(_that.latestDuration,_that.latestQualityLabel,_that.recentEntries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Duration? latestDuration,  String? latestQualityLabel,  List<SleepEntrySummary> recentEntries)  $default,) {final _that = this;
switch (_that) {
case _SleepDashboardSummary():
return $default(_that.latestDuration,_that.latestQualityLabel,_that.recentEntries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Duration? latestDuration,  String? latestQualityLabel,  List<SleepEntrySummary> recentEntries)?  $default,) {final _that = this;
switch (_that) {
case _SleepDashboardSummary() when $default != null:
return $default(_that.latestDuration,_that.latestQualityLabel,_that.recentEntries);case _:
  return null;

}
}

}

/// @nodoc


class _SleepDashboardSummary implements SleepDashboardSummary {
  const _SleepDashboardSummary({this.latestDuration, this.latestQualityLabel, required final  List<SleepEntrySummary> recentEntries}): _recentEntries = recentEntries;
  

/// The most recent record's duration/quality, or `null` if nothing has
/// been logged yet — an honest empty state, never a fabricated default.
@override final  Duration? latestDuration;
@override final  String? latestQualityLabel;
 final  List<SleepEntrySummary> _recentEntries;
@override List<SleepEntrySummary> get recentEntries {
  if (_recentEntries is EqualUnmodifiableListView) return _recentEntries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentEntries);
}


/// Create a copy of SleepDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SleepDashboardSummaryCopyWith<_SleepDashboardSummary> get copyWith => __$SleepDashboardSummaryCopyWithImpl<_SleepDashboardSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SleepDashboardSummary&&(identical(other.latestDuration, latestDuration) || other.latestDuration == latestDuration)&&(identical(other.latestQualityLabel, latestQualityLabel) || other.latestQualityLabel == latestQualityLabel)&&const DeepCollectionEquality().equals(other._recentEntries, _recentEntries));
}


@override
int get hashCode => Object.hash(runtimeType,latestDuration,latestQualityLabel,const DeepCollectionEquality().hash(_recentEntries));

@override
String toString() {
  return 'SleepDashboardSummary(latestDuration: $latestDuration, latestQualityLabel: $latestQualityLabel, recentEntries: $recentEntries)';
}


}

/// @nodoc
abstract mixin class _$SleepDashboardSummaryCopyWith<$Res> implements $SleepDashboardSummaryCopyWith<$Res> {
  factory _$SleepDashboardSummaryCopyWith(_SleepDashboardSummary value, $Res Function(_SleepDashboardSummary) _then) = __$SleepDashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 Duration? latestDuration, String? latestQualityLabel, List<SleepEntrySummary> recentEntries
});




}
/// @nodoc
class __$SleepDashboardSummaryCopyWithImpl<$Res>
    implements _$SleepDashboardSummaryCopyWith<$Res> {
  __$SleepDashboardSummaryCopyWithImpl(this._self, this._then);

  final _SleepDashboardSummary _self;
  final $Res Function(_SleepDashboardSummary) _then;

/// Create a copy of SleepDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latestDuration = freezed,Object? latestQualityLabel = freezed,Object? recentEntries = null,}) {
  return _then(_SleepDashboardSummary(
latestDuration: freezed == latestDuration ? _self.latestDuration : latestDuration // ignore: cast_nullable_to_non_nullable
as Duration?,latestQualityLabel: freezed == latestQualityLabel ? _self.latestQualityLabel : latestQualityLabel // ignore: cast_nullable_to_non_nullable
as String?,recentEntries: null == recentEntries ? _self._recentEntries : recentEntries // ignore: cast_nullable_to_non_nullable
as List<SleepEntrySummary>,
  ));
}


}

/// @nodoc
mixin _$SleepEntrySummary {

 String get id; DateTime get bedtime; DateTime get wakeTime; Duration get duration; String? get qualityLabel;
/// Create a copy of SleepEntrySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SleepEntrySummaryCopyWith<SleepEntrySummary> get copyWith => _$SleepEntrySummaryCopyWithImpl<SleepEntrySummary>(this as SleepEntrySummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SleepEntrySummary&&(identical(other.id, id) || other.id == id)&&(identical(other.bedtime, bedtime) || other.bedtime == bedtime)&&(identical(other.wakeTime, wakeTime) || other.wakeTime == wakeTime)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.qualityLabel, qualityLabel) || other.qualityLabel == qualityLabel));
}


@override
int get hashCode => Object.hash(runtimeType,id,bedtime,wakeTime,duration,qualityLabel);

@override
String toString() {
  return 'SleepEntrySummary(id: $id, bedtime: $bedtime, wakeTime: $wakeTime, duration: $duration, qualityLabel: $qualityLabel)';
}


}

/// @nodoc
abstract mixin class $SleepEntrySummaryCopyWith<$Res>  {
  factory $SleepEntrySummaryCopyWith(SleepEntrySummary value, $Res Function(SleepEntrySummary) _then) = _$SleepEntrySummaryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime bedtime, DateTime wakeTime, Duration duration, String? qualityLabel
});




}
/// @nodoc
class _$SleepEntrySummaryCopyWithImpl<$Res>
    implements $SleepEntrySummaryCopyWith<$Res> {
  _$SleepEntrySummaryCopyWithImpl(this._self, this._then);

  final SleepEntrySummary _self;
  final $Res Function(SleepEntrySummary) _then;

/// Create a copy of SleepEntrySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bedtime = null,Object? wakeTime = null,Object? duration = null,Object? qualityLabel = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bedtime: null == bedtime ? _self.bedtime : bedtime // ignore: cast_nullable_to_non_nullable
as DateTime,wakeTime: null == wakeTime ? _self.wakeTime : wakeTime // ignore: cast_nullable_to_non_nullable
as DateTime,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,qualityLabel: freezed == qualityLabel ? _self.qualityLabel : qualityLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SleepEntrySummary].
extension SleepEntrySummaryPatterns on SleepEntrySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SleepEntrySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SleepEntrySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SleepEntrySummary value)  $default,){
final _that = this;
switch (_that) {
case _SleepEntrySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SleepEntrySummary value)?  $default,){
final _that = this;
switch (_that) {
case _SleepEntrySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime bedtime,  DateTime wakeTime,  Duration duration,  String? qualityLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SleepEntrySummary() when $default != null:
return $default(_that.id,_that.bedtime,_that.wakeTime,_that.duration,_that.qualityLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime bedtime,  DateTime wakeTime,  Duration duration,  String? qualityLabel)  $default,) {final _that = this;
switch (_that) {
case _SleepEntrySummary():
return $default(_that.id,_that.bedtime,_that.wakeTime,_that.duration,_that.qualityLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime bedtime,  DateTime wakeTime,  Duration duration,  String? qualityLabel)?  $default,) {final _that = this;
switch (_that) {
case _SleepEntrySummary() when $default != null:
return $default(_that.id,_that.bedtime,_that.wakeTime,_that.duration,_that.qualityLabel);case _:
  return null;

}
}

}

/// @nodoc


class _SleepEntrySummary implements SleepEntrySummary {
  const _SleepEntrySummary({required this.id, required this.bedtime, required this.wakeTime, required this.duration, this.qualityLabel});
  

@override final  String id;
@override final  DateTime bedtime;
@override final  DateTime wakeTime;
@override final  Duration duration;
@override final  String? qualityLabel;

/// Create a copy of SleepEntrySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SleepEntrySummaryCopyWith<_SleepEntrySummary> get copyWith => __$SleepEntrySummaryCopyWithImpl<_SleepEntrySummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SleepEntrySummary&&(identical(other.id, id) || other.id == id)&&(identical(other.bedtime, bedtime) || other.bedtime == bedtime)&&(identical(other.wakeTime, wakeTime) || other.wakeTime == wakeTime)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.qualityLabel, qualityLabel) || other.qualityLabel == qualityLabel));
}


@override
int get hashCode => Object.hash(runtimeType,id,bedtime,wakeTime,duration,qualityLabel);

@override
String toString() {
  return 'SleepEntrySummary(id: $id, bedtime: $bedtime, wakeTime: $wakeTime, duration: $duration, qualityLabel: $qualityLabel)';
}


}

/// @nodoc
abstract mixin class _$SleepEntrySummaryCopyWith<$Res> implements $SleepEntrySummaryCopyWith<$Res> {
  factory _$SleepEntrySummaryCopyWith(_SleepEntrySummary value, $Res Function(_SleepEntrySummary) _then) = __$SleepEntrySummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime bedtime, DateTime wakeTime, Duration duration, String? qualityLabel
});




}
/// @nodoc
class __$SleepEntrySummaryCopyWithImpl<$Res>
    implements _$SleepEntrySummaryCopyWith<$Res> {
  __$SleepEntrySummaryCopyWithImpl(this._self, this._then);

  final _SleepEntrySummary _self;
  final $Res Function(_SleepEntrySummary) _then;

/// Create a copy of SleepEntrySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bedtime = null,Object? wakeTime = null,Object? duration = null,Object? qualityLabel = freezed,}) {
  return _then(_SleepEntrySummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bedtime: null == bedtime ? _self.bedtime : bedtime // ignore: cast_nullable_to_non_nullable
as DateTime,wakeTime: null == wakeTime ? _self.wakeTime : wakeTime // ignore: cast_nullable_to_non_nullable
as DateTime,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,qualityLabel: freezed == qualityLabel ? _self.qualityLabel : qualityLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
