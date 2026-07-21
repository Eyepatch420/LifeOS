// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medications_dashboard_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MedicationsDashboardSummary {

 List<MedicationOccurrenceSummary> get todayOccurrences; int get activeMedicationCount;
/// Create a copy of MedicationsDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationsDashboardSummaryCopyWith<MedicationsDashboardSummary> get copyWith => _$MedicationsDashboardSummaryCopyWithImpl<MedicationsDashboardSummary>(this as MedicationsDashboardSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationsDashboardSummary&&const DeepCollectionEquality().equals(other.todayOccurrences, todayOccurrences)&&(identical(other.activeMedicationCount, activeMedicationCount) || other.activeMedicationCount == activeMedicationCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(todayOccurrences),activeMedicationCount);

@override
String toString() {
  return 'MedicationsDashboardSummary(todayOccurrences: $todayOccurrences, activeMedicationCount: $activeMedicationCount)';
}


}

/// @nodoc
abstract mixin class $MedicationsDashboardSummaryCopyWith<$Res>  {
  factory $MedicationsDashboardSummaryCopyWith(MedicationsDashboardSummary value, $Res Function(MedicationsDashboardSummary) _then) = _$MedicationsDashboardSummaryCopyWithImpl;
@useResult
$Res call({
 List<MedicationOccurrenceSummary> todayOccurrences, int activeMedicationCount
});




}
/// @nodoc
class _$MedicationsDashboardSummaryCopyWithImpl<$Res>
    implements $MedicationsDashboardSummaryCopyWith<$Res> {
  _$MedicationsDashboardSummaryCopyWithImpl(this._self, this._then);

  final MedicationsDashboardSummary _self;
  final $Res Function(MedicationsDashboardSummary) _then;

/// Create a copy of MedicationsDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? todayOccurrences = null,Object? activeMedicationCount = null,}) {
  return _then(_self.copyWith(
todayOccurrences: null == todayOccurrences ? _self.todayOccurrences : todayOccurrences // ignore: cast_nullable_to_non_nullable
as List<MedicationOccurrenceSummary>,activeMedicationCount: null == activeMedicationCount ? _self.activeMedicationCount : activeMedicationCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationsDashboardSummary].
extension MedicationsDashboardSummaryPatterns on MedicationsDashboardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationsDashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationsDashboardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationsDashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _MedicationsDashboardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationsDashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationsDashboardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MedicationOccurrenceSummary> todayOccurrences,  int activeMedicationCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationsDashboardSummary() when $default != null:
return $default(_that.todayOccurrences,_that.activeMedicationCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MedicationOccurrenceSummary> todayOccurrences,  int activeMedicationCount)  $default,) {final _that = this;
switch (_that) {
case _MedicationsDashboardSummary():
return $default(_that.todayOccurrences,_that.activeMedicationCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MedicationOccurrenceSummary> todayOccurrences,  int activeMedicationCount)?  $default,) {final _that = this;
switch (_that) {
case _MedicationsDashboardSummary() when $default != null:
return $default(_that.todayOccurrences,_that.activeMedicationCount);case _:
  return null;

}
}

}

/// @nodoc


class _MedicationsDashboardSummary implements MedicationsDashboardSummary {
  const _MedicationsDashboardSummary({required final  List<MedicationOccurrenceSummary> todayOccurrences, required this.activeMedicationCount}): _todayOccurrences = todayOccurrences;
  

 final  List<MedicationOccurrenceSummary> _todayOccurrences;
@override List<MedicationOccurrenceSummary> get todayOccurrences {
  if (_todayOccurrences is EqualUnmodifiableListView) return _todayOccurrences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_todayOccurrences);
}

@override final  int activeMedicationCount;

/// Create a copy of MedicationsDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationsDashboardSummaryCopyWith<_MedicationsDashboardSummary> get copyWith => __$MedicationsDashboardSummaryCopyWithImpl<_MedicationsDashboardSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationsDashboardSummary&&const DeepCollectionEquality().equals(other._todayOccurrences, _todayOccurrences)&&(identical(other.activeMedicationCount, activeMedicationCount) || other.activeMedicationCount == activeMedicationCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_todayOccurrences),activeMedicationCount);

@override
String toString() {
  return 'MedicationsDashboardSummary(todayOccurrences: $todayOccurrences, activeMedicationCount: $activeMedicationCount)';
}


}

/// @nodoc
abstract mixin class _$MedicationsDashboardSummaryCopyWith<$Res> implements $MedicationsDashboardSummaryCopyWith<$Res> {
  factory _$MedicationsDashboardSummaryCopyWith(_MedicationsDashboardSummary value, $Res Function(_MedicationsDashboardSummary) _then) = __$MedicationsDashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 List<MedicationOccurrenceSummary> todayOccurrences, int activeMedicationCount
});




}
/// @nodoc
class __$MedicationsDashboardSummaryCopyWithImpl<$Res>
    implements _$MedicationsDashboardSummaryCopyWith<$Res> {
  __$MedicationsDashboardSummaryCopyWithImpl(this._self, this._then);

  final _MedicationsDashboardSummary _self;
  final $Res Function(_MedicationsDashboardSummary) _then;

/// Create a copy of MedicationsDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? todayOccurrences = null,Object? activeMedicationCount = null,}) {
  return _then(_MedicationsDashboardSummary(
todayOccurrences: null == todayOccurrences ? _self._todayOccurrences : todayOccurrences // ignore: cast_nullable_to_non_nullable
as List<MedicationOccurrenceSummary>,activeMedicationCount: null == activeMedicationCount ? _self.activeMedicationCount : activeMedicationCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$MedicationOccurrenceSummary {

 String get medicationId; String get medicationName; DateTime get scheduledFor; MedicationOccurrenceStatus get status;
/// Create a copy of MedicationOccurrenceSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationOccurrenceSummaryCopyWith<MedicationOccurrenceSummary> get copyWith => _$MedicationOccurrenceSummaryCopyWithImpl<MedicationOccurrenceSummary>(this as MedicationOccurrenceSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationOccurrenceSummary&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.medicationName, medicationName) || other.medicationName == medicationName)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,medicationId,medicationName,scheduledFor,status);

@override
String toString() {
  return 'MedicationOccurrenceSummary(medicationId: $medicationId, medicationName: $medicationName, scheduledFor: $scheduledFor, status: $status)';
}


}

/// @nodoc
abstract mixin class $MedicationOccurrenceSummaryCopyWith<$Res>  {
  factory $MedicationOccurrenceSummaryCopyWith(MedicationOccurrenceSummary value, $Res Function(MedicationOccurrenceSummary) _then) = _$MedicationOccurrenceSummaryCopyWithImpl;
@useResult
$Res call({
 String medicationId, String medicationName, DateTime scheduledFor, MedicationOccurrenceStatus status
});




}
/// @nodoc
class _$MedicationOccurrenceSummaryCopyWithImpl<$Res>
    implements $MedicationOccurrenceSummaryCopyWith<$Res> {
  _$MedicationOccurrenceSummaryCopyWithImpl(this._self, this._then);

  final MedicationOccurrenceSummary _self;
  final $Res Function(MedicationOccurrenceSummary) _then;

/// Create a copy of MedicationOccurrenceSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicationId = null,Object? medicationName = null,Object? scheduledFor = null,Object? status = null,}) {
  return _then(_self.copyWith(
medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,medicationName: null == medicationName ? _self.medicationName : medicationName // ignore: cast_nullable_to_non_nullable
as String,scheduledFor: null == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MedicationOccurrenceStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationOccurrenceSummary].
extension MedicationOccurrenceSummaryPatterns on MedicationOccurrenceSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationOccurrenceSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationOccurrenceSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationOccurrenceSummary value)  $default,){
final _that = this;
switch (_that) {
case _MedicationOccurrenceSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationOccurrenceSummary value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationOccurrenceSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicationId,  String medicationName,  DateTime scheduledFor,  MedicationOccurrenceStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationOccurrenceSummary() when $default != null:
return $default(_that.medicationId,_that.medicationName,_that.scheduledFor,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicationId,  String medicationName,  DateTime scheduledFor,  MedicationOccurrenceStatus status)  $default,) {final _that = this;
switch (_that) {
case _MedicationOccurrenceSummary():
return $default(_that.medicationId,_that.medicationName,_that.scheduledFor,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicationId,  String medicationName,  DateTime scheduledFor,  MedicationOccurrenceStatus status)?  $default,) {final _that = this;
switch (_that) {
case _MedicationOccurrenceSummary() when $default != null:
return $default(_that.medicationId,_that.medicationName,_that.scheduledFor,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _MedicationOccurrenceSummary implements MedicationOccurrenceSummary {
  const _MedicationOccurrenceSummary({required this.medicationId, required this.medicationName, required this.scheduledFor, required this.status});
  

@override final  String medicationId;
@override final  String medicationName;
@override final  DateTime scheduledFor;
@override final  MedicationOccurrenceStatus status;

/// Create a copy of MedicationOccurrenceSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationOccurrenceSummaryCopyWith<_MedicationOccurrenceSummary> get copyWith => __$MedicationOccurrenceSummaryCopyWithImpl<_MedicationOccurrenceSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationOccurrenceSummary&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.medicationName, medicationName) || other.medicationName == medicationName)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,medicationId,medicationName,scheduledFor,status);

@override
String toString() {
  return 'MedicationOccurrenceSummary(medicationId: $medicationId, medicationName: $medicationName, scheduledFor: $scheduledFor, status: $status)';
}


}

/// @nodoc
abstract mixin class _$MedicationOccurrenceSummaryCopyWith<$Res> implements $MedicationOccurrenceSummaryCopyWith<$Res> {
  factory _$MedicationOccurrenceSummaryCopyWith(_MedicationOccurrenceSummary value, $Res Function(_MedicationOccurrenceSummary) _then) = __$MedicationOccurrenceSummaryCopyWithImpl;
@override @useResult
$Res call({
 String medicationId, String medicationName, DateTime scheduledFor, MedicationOccurrenceStatus status
});




}
/// @nodoc
class __$MedicationOccurrenceSummaryCopyWithImpl<$Res>
    implements _$MedicationOccurrenceSummaryCopyWith<$Res> {
  __$MedicationOccurrenceSummaryCopyWithImpl(this._self, this._then);

  final _MedicationOccurrenceSummary _self;
  final $Res Function(_MedicationOccurrenceSummary) _then;

/// Create a copy of MedicationOccurrenceSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicationId = null,Object? medicationName = null,Object? scheduledFor = null,Object? status = null,}) {
  return _then(_MedicationOccurrenceSummary(
medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,medicationName: null == medicationName ? _self.medicationName : medicationName // ignore: cast_nullable_to_non_nullable
as String,scheduledFor: null == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MedicationOccurrenceStatus,
  ));
}


}

// dart format on
