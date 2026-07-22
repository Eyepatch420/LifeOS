// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hydration_dashboard_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HydrationDashboardSummary {

 int get todayTotalMl; int get goalMl; List<HydrationEntrySummary> get recentEntries;
/// Create a copy of HydrationDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HydrationDashboardSummaryCopyWith<HydrationDashboardSummary> get copyWith => _$HydrationDashboardSummaryCopyWithImpl<HydrationDashboardSummary>(this as HydrationDashboardSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HydrationDashboardSummary&&(identical(other.todayTotalMl, todayTotalMl) || other.todayTotalMl == todayTotalMl)&&(identical(other.goalMl, goalMl) || other.goalMl == goalMl)&&const DeepCollectionEquality().equals(other.recentEntries, recentEntries));
}


@override
int get hashCode => Object.hash(runtimeType,todayTotalMl,goalMl,const DeepCollectionEquality().hash(recentEntries));

@override
String toString() {
  return 'HydrationDashboardSummary(todayTotalMl: $todayTotalMl, goalMl: $goalMl, recentEntries: $recentEntries)';
}


}

/// @nodoc
abstract mixin class $HydrationDashboardSummaryCopyWith<$Res>  {
  factory $HydrationDashboardSummaryCopyWith(HydrationDashboardSummary value, $Res Function(HydrationDashboardSummary) _then) = _$HydrationDashboardSummaryCopyWithImpl;
@useResult
$Res call({
 int todayTotalMl, int goalMl, List<HydrationEntrySummary> recentEntries
});




}
/// @nodoc
class _$HydrationDashboardSummaryCopyWithImpl<$Res>
    implements $HydrationDashboardSummaryCopyWith<$Res> {
  _$HydrationDashboardSummaryCopyWithImpl(this._self, this._then);

  final HydrationDashboardSummary _self;
  final $Res Function(HydrationDashboardSummary) _then;

/// Create a copy of HydrationDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? todayTotalMl = null,Object? goalMl = null,Object? recentEntries = null,}) {
  return _then(_self.copyWith(
todayTotalMl: null == todayTotalMl ? _self.todayTotalMl : todayTotalMl // ignore: cast_nullable_to_non_nullable
as int,goalMl: null == goalMl ? _self.goalMl : goalMl // ignore: cast_nullable_to_non_nullable
as int,recentEntries: null == recentEntries ? _self.recentEntries : recentEntries // ignore: cast_nullable_to_non_nullable
as List<HydrationEntrySummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [HydrationDashboardSummary].
extension HydrationDashboardSummaryPatterns on HydrationDashboardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HydrationDashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HydrationDashboardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HydrationDashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _HydrationDashboardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HydrationDashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _HydrationDashboardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int todayTotalMl,  int goalMl,  List<HydrationEntrySummary> recentEntries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HydrationDashboardSummary() when $default != null:
return $default(_that.todayTotalMl,_that.goalMl,_that.recentEntries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int todayTotalMl,  int goalMl,  List<HydrationEntrySummary> recentEntries)  $default,) {final _that = this;
switch (_that) {
case _HydrationDashboardSummary():
return $default(_that.todayTotalMl,_that.goalMl,_that.recentEntries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int todayTotalMl,  int goalMl,  List<HydrationEntrySummary> recentEntries)?  $default,) {final _that = this;
switch (_that) {
case _HydrationDashboardSummary() when $default != null:
return $default(_that.todayTotalMl,_that.goalMl,_that.recentEntries);case _:
  return null;

}
}

}

/// @nodoc


class _HydrationDashboardSummary implements HydrationDashboardSummary {
  const _HydrationDashboardSummary({required this.todayTotalMl, required this.goalMl, required final  List<HydrationEntrySummary> recentEntries}): _recentEntries = recentEntries;
  

@override final  int todayTotalMl;
@override final  int goalMl;
 final  List<HydrationEntrySummary> _recentEntries;
@override List<HydrationEntrySummary> get recentEntries {
  if (_recentEntries is EqualUnmodifiableListView) return _recentEntries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentEntries);
}


/// Create a copy of HydrationDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HydrationDashboardSummaryCopyWith<_HydrationDashboardSummary> get copyWith => __$HydrationDashboardSummaryCopyWithImpl<_HydrationDashboardSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HydrationDashboardSummary&&(identical(other.todayTotalMl, todayTotalMl) || other.todayTotalMl == todayTotalMl)&&(identical(other.goalMl, goalMl) || other.goalMl == goalMl)&&const DeepCollectionEquality().equals(other._recentEntries, _recentEntries));
}


@override
int get hashCode => Object.hash(runtimeType,todayTotalMl,goalMl,const DeepCollectionEquality().hash(_recentEntries));

@override
String toString() {
  return 'HydrationDashboardSummary(todayTotalMl: $todayTotalMl, goalMl: $goalMl, recentEntries: $recentEntries)';
}


}

/// @nodoc
abstract mixin class _$HydrationDashboardSummaryCopyWith<$Res> implements $HydrationDashboardSummaryCopyWith<$Res> {
  factory _$HydrationDashboardSummaryCopyWith(_HydrationDashboardSummary value, $Res Function(_HydrationDashboardSummary) _then) = __$HydrationDashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 int todayTotalMl, int goalMl, List<HydrationEntrySummary> recentEntries
});




}
/// @nodoc
class __$HydrationDashboardSummaryCopyWithImpl<$Res>
    implements _$HydrationDashboardSummaryCopyWith<$Res> {
  __$HydrationDashboardSummaryCopyWithImpl(this._self, this._then);

  final _HydrationDashboardSummary _self;
  final $Res Function(_HydrationDashboardSummary) _then;

/// Create a copy of HydrationDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? todayTotalMl = null,Object? goalMl = null,Object? recentEntries = null,}) {
  return _then(_HydrationDashboardSummary(
todayTotalMl: null == todayTotalMl ? _self.todayTotalMl : todayTotalMl // ignore: cast_nullable_to_non_nullable
as int,goalMl: null == goalMl ? _self.goalMl : goalMl // ignore: cast_nullable_to_non_nullable
as int,recentEntries: null == recentEntries ? _self._recentEntries : recentEntries // ignore: cast_nullable_to_non_nullable
as List<HydrationEntrySummary>,
  ));
}


}

/// @nodoc
mixin _$HydrationEntrySummary {

 String get id; int get amountMl; DateTime get recordedAt;
/// Create a copy of HydrationEntrySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HydrationEntrySummaryCopyWith<HydrationEntrySummary> get copyWith => _$HydrationEntrySummaryCopyWithImpl<HydrationEntrySummary>(this as HydrationEntrySummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HydrationEntrySummary&&(identical(other.id, id) || other.id == id)&&(identical(other.amountMl, amountMl) || other.amountMl == amountMl)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,amountMl,recordedAt);

@override
String toString() {
  return 'HydrationEntrySummary(id: $id, amountMl: $amountMl, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class $HydrationEntrySummaryCopyWith<$Res>  {
  factory $HydrationEntrySummaryCopyWith(HydrationEntrySummary value, $Res Function(HydrationEntrySummary) _then) = _$HydrationEntrySummaryCopyWithImpl;
@useResult
$Res call({
 String id, int amountMl, DateTime recordedAt
});




}
/// @nodoc
class _$HydrationEntrySummaryCopyWithImpl<$Res>
    implements $HydrationEntrySummaryCopyWith<$Res> {
  _$HydrationEntrySummaryCopyWithImpl(this._self, this._then);

  final HydrationEntrySummary _self;
  final $Res Function(HydrationEntrySummary) _then;

/// Create a copy of HydrationEntrySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amountMl = null,Object? recordedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amountMl: null == amountMl ? _self.amountMl : amountMl // ignore: cast_nullable_to_non_nullable
as int,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HydrationEntrySummary].
extension HydrationEntrySummaryPatterns on HydrationEntrySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HydrationEntrySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HydrationEntrySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HydrationEntrySummary value)  $default,){
final _that = this;
switch (_that) {
case _HydrationEntrySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HydrationEntrySummary value)?  $default,){
final _that = this;
switch (_that) {
case _HydrationEntrySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int amountMl,  DateTime recordedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HydrationEntrySummary() when $default != null:
return $default(_that.id,_that.amountMl,_that.recordedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int amountMl,  DateTime recordedAt)  $default,) {final _that = this;
switch (_that) {
case _HydrationEntrySummary():
return $default(_that.id,_that.amountMl,_that.recordedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int amountMl,  DateTime recordedAt)?  $default,) {final _that = this;
switch (_that) {
case _HydrationEntrySummary() when $default != null:
return $default(_that.id,_that.amountMl,_that.recordedAt);case _:
  return null;

}
}

}

/// @nodoc


class _HydrationEntrySummary implements HydrationEntrySummary {
  const _HydrationEntrySummary({required this.id, required this.amountMl, required this.recordedAt});
  

@override final  String id;
@override final  int amountMl;
@override final  DateTime recordedAt;

/// Create a copy of HydrationEntrySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HydrationEntrySummaryCopyWith<_HydrationEntrySummary> get copyWith => __$HydrationEntrySummaryCopyWithImpl<_HydrationEntrySummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HydrationEntrySummary&&(identical(other.id, id) || other.id == id)&&(identical(other.amountMl, amountMl) || other.amountMl == amountMl)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,amountMl,recordedAt);

@override
String toString() {
  return 'HydrationEntrySummary(id: $id, amountMl: $amountMl, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class _$HydrationEntrySummaryCopyWith<$Res> implements $HydrationEntrySummaryCopyWith<$Res> {
  factory _$HydrationEntrySummaryCopyWith(_HydrationEntrySummary value, $Res Function(_HydrationEntrySummary) _then) = __$HydrationEntrySummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, int amountMl, DateTime recordedAt
});




}
/// @nodoc
class __$HydrationEntrySummaryCopyWithImpl<$Res>
    implements _$HydrationEntrySummaryCopyWith<$Res> {
  __$HydrationEntrySummaryCopyWithImpl(this._self, this._then);

  final _HydrationEntrySummary _self;
  final $Res Function(_HydrationEntrySummary) _then;

/// Create a copy of HydrationEntrySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amountMl = null,Object? recordedAt = null,}) {
  return _then(_HydrationEntrySummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amountMl: null == amountMl ? _self.amountMl : amountMl // ignore: cast_nullable_to_non_nullable
as int,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
