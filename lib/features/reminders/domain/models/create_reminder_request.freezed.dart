// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_reminder_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateReminderRequest {

 String get id; String get title; DateTime get dueAt; bool get isUrgent; RecurrenceRule get recurrence;
/// Create a copy of CreateReminderRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateReminderRequestCopyWith<CreateReminderRequest> get copyWith => _$CreateReminderRequestCopyWithImpl<CreateReminderRequest>(this as CreateReminderRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateReminderRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.isUrgent, isUrgent) || other.isUrgent == isUrgent)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,dueAt,isUrgent,recurrence);

@override
String toString() {
  return 'CreateReminderRequest(id: $id, title: $title, dueAt: $dueAt, isUrgent: $isUrgent, recurrence: $recurrence)';
}


}

/// @nodoc
abstract mixin class $CreateReminderRequestCopyWith<$Res>  {
  factory $CreateReminderRequestCopyWith(CreateReminderRequest value, $Res Function(CreateReminderRequest) _then) = _$CreateReminderRequestCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime dueAt, bool isUrgent, RecurrenceRule recurrence
});




}
/// @nodoc
class _$CreateReminderRequestCopyWithImpl<$Res>
    implements $CreateReminderRequestCopyWith<$Res> {
  _$CreateReminderRequestCopyWithImpl(this._self, this._then);

  final CreateReminderRequest _self;
  final $Res Function(CreateReminderRequest) _then;

/// Create a copy of CreateReminderRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? dueAt = null,Object? isUrgent = null,Object? recurrence = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,isUrgent: null == isUrgent ? _self.isUrgent : isUrgent // ignore: cast_nullable_to_non_nullable
as bool,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as RecurrenceRule,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateReminderRequest].
extension CreateReminderRequestPatterns on CreateReminderRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateReminderRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateReminderRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateReminderRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateReminderRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateReminderRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateReminderRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime dueAt,  bool isUrgent,  RecurrenceRule recurrence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateReminderRequest() when $default != null:
return $default(_that.id,_that.title,_that.dueAt,_that.isUrgent,_that.recurrence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime dueAt,  bool isUrgent,  RecurrenceRule recurrence)  $default,) {final _that = this;
switch (_that) {
case _CreateReminderRequest():
return $default(_that.id,_that.title,_that.dueAt,_that.isUrgent,_that.recurrence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime dueAt,  bool isUrgent,  RecurrenceRule recurrence)?  $default,) {final _that = this;
switch (_that) {
case _CreateReminderRequest() when $default != null:
return $default(_that.id,_that.title,_that.dueAt,_that.isUrgent,_that.recurrence);case _:
  return null;

}
}

}

/// @nodoc


class _CreateReminderRequest implements CreateReminderRequest {
  const _CreateReminderRequest({required this.id, required this.title, required this.dueAt, required this.isUrgent, this.recurrence = RecurrenceRule.none});
  

@override final  String id;
@override final  String title;
@override final  DateTime dueAt;
@override final  bool isUrgent;
@override@JsonKey() final  RecurrenceRule recurrence;

/// Create a copy of CreateReminderRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateReminderRequestCopyWith<_CreateReminderRequest> get copyWith => __$CreateReminderRequestCopyWithImpl<_CreateReminderRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateReminderRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.isUrgent, isUrgent) || other.isUrgent == isUrgent)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,dueAt,isUrgent,recurrence);

@override
String toString() {
  return 'CreateReminderRequest(id: $id, title: $title, dueAt: $dueAt, isUrgent: $isUrgent, recurrence: $recurrence)';
}


}

/// @nodoc
abstract mixin class _$CreateReminderRequestCopyWith<$Res> implements $CreateReminderRequestCopyWith<$Res> {
  factory _$CreateReminderRequestCopyWith(_CreateReminderRequest value, $Res Function(_CreateReminderRequest) _then) = __$CreateReminderRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime dueAt, bool isUrgent, RecurrenceRule recurrence
});




}
/// @nodoc
class __$CreateReminderRequestCopyWithImpl<$Res>
    implements _$CreateReminderRequestCopyWith<$Res> {
  __$CreateReminderRequestCopyWithImpl(this._self, this._then);

  final _CreateReminderRequest _self;
  final $Res Function(_CreateReminderRequest) _then;

/// Create a copy of CreateReminderRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? dueAt = null,Object? isUrgent = null,Object? recurrence = null,}) {
  return _then(_CreateReminderRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,isUrgent: null == isUrgent ? _self.isUrgent : isUrgent // ignore: cast_nullable_to_non_nullable
as bool,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as RecurrenceRule,
  ));
}


}

// dart format on
