// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_occurrence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MedicationOccurrence {

/// `null` for a synthesized (not-yet-acted-on) occurrence — only set
/// once a real row exists.
 String? get id; String get medicationId; DateTime get scheduledFor; MedicationOccurrenceStatus get status; DateTime? get takenAt;
/// Create a copy of MedicationOccurrence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationOccurrenceCopyWith<MedicationOccurrence> get copyWith => _$MedicationOccurrenceCopyWithImpl<MedicationOccurrence>(this as MedicationOccurrence, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationOccurrence&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.status, status) || other.status == status)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,medicationId,scheduledFor,status,takenAt);

@override
String toString() {
  return 'MedicationOccurrence(id: $id, medicationId: $medicationId, scheduledFor: $scheduledFor, status: $status, takenAt: $takenAt)';
}


}

/// @nodoc
abstract mixin class $MedicationOccurrenceCopyWith<$Res>  {
  factory $MedicationOccurrenceCopyWith(MedicationOccurrence value, $Res Function(MedicationOccurrence) _then) = _$MedicationOccurrenceCopyWithImpl;
@useResult
$Res call({
 String? id, String medicationId, DateTime scheduledFor, MedicationOccurrenceStatus status, DateTime? takenAt
});




}
/// @nodoc
class _$MedicationOccurrenceCopyWithImpl<$Res>
    implements $MedicationOccurrenceCopyWith<$Res> {
  _$MedicationOccurrenceCopyWithImpl(this._self, this._then);

  final MedicationOccurrence _self;
  final $Res Function(MedicationOccurrence) _then;

/// Create a copy of MedicationOccurrence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? medicationId = null,Object? scheduledFor = null,Object? status = null,Object? takenAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,scheduledFor: null == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MedicationOccurrenceStatus,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationOccurrence].
extension MedicationOccurrencePatterns on MedicationOccurrence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationOccurrence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationOccurrence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationOccurrence value)  $default,){
final _that = this;
switch (_that) {
case _MedicationOccurrence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationOccurrence value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationOccurrence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String medicationId,  DateTime scheduledFor,  MedicationOccurrenceStatus status,  DateTime? takenAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationOccurrence() when $default != null:
return $default(_that.id,_that.medicationId,_that.scheduledFor,_that.status,_that.takenAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String medicationId,  DateTime scheduledFor,  MedicationOccurrenceStatus status,  DateTime? takenAt)  $default,) {final _that = this;
switch (_that) {
case _MedicationOccurrence():
return $default(_that.id,_that.medicationId,_that.scheduledFor,_that.status,_that.takenAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String medicationId,  DateTime scheduledFor,  MedicationOccurrenceStatus status,  DateTime? takenAt)?  $default,) {final _that = this;
switch (_that) {
case _MedicationOccurrence() when $default != null:
return $default(_that.id,_that.medicationId,_that.scheduledFor,_that.status,_that.takenAt);case _:
  return null;

}
}

}

/// @nodoc


class _MedicationOccurrence implements MedicationOccurrence {
  const _MedicationOccurrence({this.id, required this.medicationId, required this.scheduledFor, required this.status, this.takenAt});
  

/// `null` for a synthesized (not-yet-acted-on) occurrence — only set
/// once a real row exists.
@override final  String? id;
@override final  String medicationId;
@override final  DateTime scheduledFor;
@override final  MedicationOccurrenceStatus status;
@override final  DateTime? takenAt;

/// Create a copy of MedicationOccurrence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationOccurrenceCopyWith<_MedicationOccurrence> get copyWith => __$MedicationOccurrenceCopyWithImpl<_MedicationOccurrence>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationOccurrence&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.status, status) || other.status == status)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,medicationId,scheduledFor,status,takenAt);

@override
String toString() {
  return 'MedicationOccurrence(id: $id, medicationId: $medicationId, scheduledFor: $scheduledFor, status: $status, takenAt: $takenAt)';
}


}

/// @nodoc
abstract mixin class _$MedicationOccurrenceCopyWith<$Res> implements $MedicationOccurrenceCopyWith<$Res> {
  factory _$MedicationOccurrenceCopyWith(_MedicationOccurrence value, $Res Function(_MedicationOccurrence) _then) = __$MedicationOccurrenceCopyWithImpl;
@override @useResult
$Res call({
 String? id, String medicationId, DateTime scheduledFor, MedicationOccurrenceStatus status, DateTime? takenAt
});




}
/// @nodoc
class __$MedicationOccurrenceCopyWithImpl<$Res>
    implements _$MedicationOccurrenceCopyWith<$Res> {
  __$MedicationOccurrenceCopyWithImpl(this._self, this._then);

  final _MedicationOccurrence _self;
  final $Res Function(_MedicationOccurrence) _then;

/// Create a copy of MedicationOccurrence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? medicationId = null,Object? scheduledFor = null,Object? status = null,Object? takenAt = freezed,}) {
  return _then(_MedicationOccurrence(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,scheduledFor: null == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MedicationOccurrenceStatus,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
