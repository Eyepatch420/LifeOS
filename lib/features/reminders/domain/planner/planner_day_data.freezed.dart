// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'planner_day_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlannerDayData {

 DateTime get date; List<PlannerItem> get overdueCarryover; List<PlannerItem> get scheduled; int get completedCount; int get pendingCount;
/// Create a copy of PlannerDayData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlannerDayDataCopyWith<PlannerDayData> get copyWith => _$PlannerDayDataCopyWithImpl<PlannerDayData>(this as PlannerDayData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlannerDayData&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.overdueCarryover, overdueCarryover)&&const DeepCollectionEquality().equals(other.scheduled, scheduled)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount));
}


@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(overdueCarryover),const DeepCollectionEquality().hash(scheduled),completedCount,pendingCount);

@override
String toString() {
  return 'PlannerDayData(date: $date, overdueCarryover: $overdueCarryover, scheduled: $scheduled, completedCount: $completedCount, pendingCount: $pendingCount)';
}


}

/// @nodoc
abstract mixin class $PlannerDayDataCopyWith<$Res>  {
  factory $PlannerDayDataCopyWith(PlannerDayData value, $Res Function(PlannerDayData) _then) = _$PlannerDayDataCopyWithImpl;
@useResult
$Res call({
 DateTime date, List<PlannerItem> overdueCarryover, List<PlannerItem> scheduled, int completedCount, int pendingCount
});




}
/// @nodoc
class _$PlannerDayDataCopyWithImpl<$Res>
    implements $PlannerDayDataCopyWith<$Res> {
  _$PlannerDayDataCopyWithImpl(this._self, this._then);

  final PlannerDayData _self;
  final $Res Function(PlannerDayData) _then;

/// Create a copy of PlannerDayData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? overdueCarryover = null,Object? scheduled = null,Object? completedCount = null,Object? pendingCount = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,overdueCarryover: null == overdueCarryover ? _self.overdueCarryover : overdueCarryover // ignore: cast_nullable_to_non_nullable
as List<PlannerItem>,scheduled: null == scheduled ? _self.scheduled : scheduled // ignore: cast_nullable_to_non_nullable
as List<PlannerItem>,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlannerDayData].
extension PlannerDayDataPatterns on PlannerDayData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlannerDayData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlannerDayData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlannerDayData value)  $default,){
final _that = this;
switch (_that) {
case _PlannerDayData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlannerDayData value)?  $default,){
final _that = this;
switch (_that) {
case _PlannerDayData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  List<PlannerItem> overdueCarryover,  List<PlannerItem> scheduled,  int completedCount,  int pendingCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlannerDayData() when $default != null:
return $default(_that.date,_that.overdueCarryover,_that.scheduled,_that.completedCount,_that.pendingCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  List<PlannerItem> overdueCarryover,  List<PlannerItem> scheduled,  int completedCount,  int pendingCount)  $default,) {final _that = this;
switch (_that) {
case _PlannerDayData():
return $default(_that.date,_that.overdueCarryover,_that.scheduled,_that.completedCount,_that.pendingCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  List<PlannerItem> overdueCarryover,  List<PlannerItem> scheduled,  int completedCount,  int pendingCount)?  $default,) {final _that = this;
switch (_that) {
case _PlannerDayData() when $default != null:
return $default(_that.date,_that.overdueCarryover,_that.scheduled,_that.completedCount,_that.pendingCount);case _:
  return null;

}
}

}

/// @nodoc


class _PlannerDayData extends PlannerDayData {
  const _PlannerDayData({required this.date, required final  List<PlannerItem> overdueCarryover, required final  List<PlannerItem> scheduled, required this.completedCount, required this.pendingCount}): _overdueCarryover = overdueCarryover,_scheduled = scheduled,super._();
  

@override final  DateTime date;
 final  List<PlannerItem> _overdueCarryover;
@override List<PlannerItem> get overdueCarryover {
  if (_overdueCarryover is EqualUnmodifiableListView) return _overdueCarryover;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_overdueCarryover);
}

 final  List<PlannerItem> _scheduled;
@override List<PlannerItem> get scheduled {
  if (_scheduled is EqualUnmodifiableListView) return _scheduled;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scheduled);
}

@override final  int completedCount;
@override final  int pendingCount;

/// Create a copy of PlannerDayData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlannerDayDataCopyWith<_PlannerDayData> get copyWith => __$PlannerDayDataCopyWithImpl<_PlannerDayData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlannerDayData&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._overdueCarryover, _overdueCarryover)&&const DeepCollectionEquality().equals(other._scheduled, _scheduled)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount));
}


@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(_overdueCarryover),const DeepCollectionEquality().hash(_scheduled),completedCount,pendingCount);

@override
String toString() {
  return 'PlannerDayData(date: $date, overdueCarryover: $overdueCarryover, scheduled: $scheduled, completedCount: $completedCount, pendingCount: $pendingCount)';
}


}

/// @nodoc
abstract mixin class _$PlannerDayDataCopyWith<$Res> implements $PlannerDayDataCopyWith<$Res> {
  factory _$PlannerDayDataCopyWith(_PlannerDayData value, $Res Function(_PlannerDayData) _then) = __$PlannerDayDataCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, List<PlannerItem> overdueCarryover, List<PlannerItem> scheduled, int completedCount, int pendingCount
});




}
/// @nodoc
class __$PlannerDayDataCopyWithImpl<$Res>
    implements _$PlannerDayDataCopyWith<$Res> {
  __$PlannerDayDataCopyWithImpl(this._self, this._then);

  final _PlannerDayData _self;
  final $Res Function(_PlannerDayData) _then;

/// Create a copy of PlannerDayData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? overdueCarryover = null,Object? scheduled = null,Object? completedCount = null,Object? pendingCount = null,}) {
  return _then(_PlannerDayData(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,overdueCarryover: null == overdueCarryover ? _self._overdueCarryover : overdueCarryover // ignore: cast_nullable_to_non_nullable
as List<PlannerItem>,scheduled: null == scheduled ? _self._scheduled : scheduled // ignore: cast_nullable_to_non_nullable
as List<PlannerItem>,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
