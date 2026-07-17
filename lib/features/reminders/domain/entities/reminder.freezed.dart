// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Reminder {

 String get id; String get title; DateTime get dueAt; bool get isUrgent; bool get isCompleted; RecurrenceRule get recurrence; DateTime? get completedAt; String? get customRule;
/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderCopyWith<Reminder> get copyWith => _$ReminderCopyWithImpl<Reminder>(this as Reminder, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reminder&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.isUrgent, isUrgent) || other.isUrgent == isUrgent)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.customRule, customRule) || other.customRule == customRule));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,dueAt,isUrgent,isCompleted,recurrence,completedAt,customRule);

@override
String toString() {
  return 'Reminder(id: $id, title: $title, dueAt: $dueAt, isUrgent: $isUrgent, isCompleted: $isCompleted, recurrence: $recurrence, completedAt: $completedAt, customRule: $customRule)';
}


}

/// @nodoc
abstract mixin class $ReminderCopyWith<$Res>  {
  factory $ReminderCopyWith(Reminder value, $Res Function(Reminder) _then) = _$ReminderCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime dueAt, bool isUrgent, bool isCompleted, RecurrenceRule recurrence, DateTime? completedAt, String? customRule
});




}
/// @nodoc
class _$ReminderCopyWithImpl<$Res>
    implements $ReminderCopyWith<$Res> {
  _$ReminderCopyWithImpl(this._self, this._then);

  final Reminder _self;
  final $Res Function(Reminder) _then;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? dueAt = null,Object? isUrgent = null,Object? isCompleted = null,Object? recurrence = null,Object? completedAt = freezed,Object? customRule = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,isUrgent: null == isUrgent ? _self.isUrgent : isUrgent // ignore: cast_nullable_to_non_nullable
as bool,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as RecurrenceRule,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,customRule: freezed == customRule ? _self.customRule : customRule // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Reminder].
extension ReminderPatterns on Reminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reminder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reminder value)  $default,){
final _that = this;
switch (_that) {
case _Reminder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reminder value)?  $default,){
final _that = this;
switch (_that) {
case _Reminder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime dueAt,  bool isUrgent,  bool isCompleted,  RecurrenceRule recurrence,  DateTime? completedAt,  String? customRule)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reminder() when $default != null:
return $default(_that.id,_that.title,_that.dueAt,_that.isUrgent,_that.isCompleted,_that.recurrence,_that.completedAt,_that.customRule);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime dueAt,  bool isUrgent,  bool isCompleted,  RecurrenceRule recurrence,  DateTime? completedAt,  String? customRule)  $default,) {final _that = this;
switch (_that) {
case _Reminder():
return $default(_that.id,_that.title,_that.dueAt,_that.isUrgent,_that.isCompleted,_that.recurrence,_that.completedAt,_that.customRule);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime dueAt,  bool isUrgent,  bool isCompleted,  RecurrenceRule recurrence,  DateTime? completedAt,  String? customRule)?  $default,) {final _that = this;
switch (_that) {
case _Reminder() when $default != null:
return $default(_that.id,_that.title,_that.dueAt,_that.isUrgent,_that.isCompleted,_that.recurrence,_that.completedAt,_that.customRule);case _:
  return null;

}
}

}

/// @nodoc


class _Reminder implements Reminder {
  const _Reminder({required this.id, required this.title, required this.dueAt, required this.isUrgent, required this.isCompleted, required this.recurrence, this.completedAt, this.customRule});
  

@override final  String id;
@override final  String title;
@override final  DateTime dueAt;
@override final  bool isUrgent;
@override final  bool isCompleted;
@override final  RecurrenceRule recurrence;
@override final  DateTime? completedAt;
@override final  String? customRule;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderCopyWith<_Reminder> get copyWith => __$ReminderCopyWithImpl<_Reminder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reminder&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.isUrgent, isUrgent) || other.isUrgent == isUrgent)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.customRule, customRule) || other.customRule == customRule));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,dueAt,isUrgent,isCompleted,recurrence,completedAt,customRule);

@override
String toString() {
  return 'Reminder(id: $id, title: $title, dueAt: $dueAt, isUrgent: $isUrgent, isCompleted: $isCompleted, recurrence: $recurrence, completedAt: $completedAt, customRule: $customRule)';
}


}

/// @nodoc
abstract mixin class _$ReminderCopyWith<$Res> implements $ReminderCopyWith<$Res> {
  factory _$ReminderCopyWith(_Reminder value, $Res Function(_Reminder) _then) = __$ReminderCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime dueAt, bool isUrgent, bool isCompleted, RecurrenceRule recurrence, DateTime? completedAt, String? customRule
});




}
/// @nodoc
class __$ReminderCopyWithImpl<$Res>
    implements _$ReminderCopyWith<$Res> {
  __$ReminderCopyWithImpl(this._self, this._then);

  final _Reminder _self;
  final $Res Function(_Reminder) _then;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? dueAt = null,Object? isUrgent = null,Object? isCompleted = null,Object? recurrence = null,Object? completedAt = freezed,Object? customRule = freezed,}) {
  return _then(_Reminder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,isUrgent: null == isUrgent ? _self.isUrgent : isUrgent // ignore: cast_nullable_to_non_nullable
as bool,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as RecurrenceRule,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,customRule: freezed == customRule ? _self.customRule : customRule // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
