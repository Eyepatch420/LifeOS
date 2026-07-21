// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Medication {

 String get id; String get name; String? get dosageText; String? get instructions; MedicationSchedule get schedule; DateTime get createdAt; DateTime? get archivedAt;
/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationCopyWith<Medication> get copyWith => _$MedicationCopyWithImpl<Medication>(this as Medication, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Medication&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dosageText, dosageText) || other.dosageText == dosageText)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,dosageText,instructions,schedule,createdAt,archivedAt);

@override
String toString() {
  return 'Medication(id: $id, name: $name, dosageText: $dosageText, instructions: $instructions, schedule: $schedule, createdAt: $createdAt, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class $MedicationCopyWith<$Res>  {
  factory $MedicationCopyWith(Medication value, $Res Function(Medication) _then) = _$MedicationCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? dosageText, String? instructions, MedicationSchedule schedule, DateTime createdAt, DateTime? archivedAt
});


$MedicationScheduleCopyWith<$Res> get schedule;

}
/// @nodoc
class _$MedicationCopyWithImpl<$Res>
    implements $MedicationCopyWith<$Res> {
  _$MedicationCopyWithImpl(this._self, this._then);

  final Medication _self;
  final $Res Function(Medication) _then;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? dosageText = freezed,Object? instructions = freezed,Object? schedule = null,Object? createdAt = null,Object? archivedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dosageText: freezed == dosageText ? _self.dosageText : dosageText // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as MedicationSchedule,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationScheduleCopyWith<$Res> get schedule {
  
  return $MedicationScheduleCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}


/// Adds pattern-matching-related methods to [Medication].
extension MedicationPatterns on Medication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Medication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Medication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Medication value)  $default,){
final _that = this;
switch (_that) {
case _Medication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Medication value)?  $default,){
final _that = this;
switch (_that) {
case _Medication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? dosageText,  String? instructions,  MedicationSchedule schedule,  DateTime createdAt,  DateTime? archivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Medication() when $default != null:
return $default(_that.id,_that.name,_that.dosageText,_that.instructions,_that.schedule,_that.createdAt,_that.archivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? dosageText,  String? instructions,  MedicationSchedule schedule,  DateTime createdAt,  DateTime? archivedAt)  $default,) {final _that = this;
switch (_that) {
case _Medication():
return $default(_that.id,_that.name,_that.dosageText,_that.instructions,_that.schedule,_that.createdAt,_that.archivedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? dosageText,  String? instructions,  MedicationSchedule schedule,  DateTime createdAt,  DateTime? archivedAt)?  $default,) {final _that = this;
switch (_that) {
case _Medication() when $default != null:
return $default(_that.id,_that.name,_that.dosageText,_that.instructions,_that.schedule,_that.createdAt,_that.archivedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Medication implements Medication {
  const _Medication({required this.id, required this.name, this.dosageText, this.instructions, required this.schedule, required this.createdAt, this.archivedAt});
  

@override final  String id;
@override final  String name;
@override final  String? dosageText;
@override final  String? instructions;
@override final  MedicationSchedule schedule;
@override final  DateTime createdAt;
@override final  DateTime? archivedAt;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationCopyWith<_Medication> get copyWith => __$MedicationCopyWithImpl<_Medication>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Medication&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dosageText, dosageText) || other.dosageText == dosageText)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,dosageText,instructions,schedule,createdAt,archivedAt);

@override
String toString() {
  return 'Medication(id: $id, name: $name, dosageText: $dosageText, instructions: $instructions, schedule: $schedule, createdAt: $createdAt, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class _$MedicationCopyWith<$Res> implements $MedicationCopyWith<$Res> {
  factory _$MedicationCopyWith(_Medication value, $Res Function(_Medication) _then) = __$MedicationCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? dosageText, String? instructions, MedicationSchedule schedule, DateTime createdAt, DateTime? archivedAt
});


@override $MedicationScheduleCopyWith<$Res> get schedule;

}
/// @nodoc
class __$MedicationCopyWithImpl<$Res>
    implements _$MedicationCopyWith<$Res> {
  __$MedicationCopyWithImpl(this._self, this._then);

  final _Medication _self;
  final $Res Function(_Medication) _then;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? dosageText = freezed,Object? instructions = freezed,Object? schedule = null,Object? createdAt = null,Object? archivedAt = freezed,}) {
  return _then(_Medication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dosageText: freezed == dosageText ? _self.dosageText : dosageText // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as MedicationSchedule,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationScheduleCopyWith<$Res> get schedule {
  
  return $MedicationScheduleCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}
}

// dart format on
