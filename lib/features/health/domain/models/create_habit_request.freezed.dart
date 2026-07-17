// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_habit_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateHabitRequest {

 String get id; String get title; String get targetFrequency;
/// Create a copy of CreateHabitRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateHabitRequestCopyWith<CreateHabitRequest> get copyWith => _$CreateHabitRequestCopyWithImpl<CreateHabitRequest>(this as CreateHabitRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateHabitRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.targetFrequency, targetFrequency) || other.targetFrequency == targetFrequency));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,targetFrequency);

@override
String toString() {
  return 'CreateHabitRequest(id: $id, title: $title, targetFrequency: $targetFrequency)';
}


}

/// @nodoc
abstract mixin class $CreateHabitRequestCopyWith<$Res>  {
  factory $CreateHabitRequestCopyWith(CreateHabitRequest value, $Res Function(CreateHabitRequest) _then) = _$CreateHabitRequestCopyWithImpl;
@useResult
$Res call({
 String id, String title, String targetFrequency
});




}
/// @nodoc
class _$CreateHabitRequestCopyWithImpl<$Res>
    implements $CreateHabitRequestCopyWith<$Res> {
  _$CreateHabitRequestCopyWithImpl(this._self, this._then);

  final CreateHabitRequest _self;
  final $Res Function(CreateHabitRequest) _then;

/// Create a copy of CreateHabitRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? targetFrequency = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,targetFrequency: null == targetFrequency ? _self.targetFrequency : targetFrequency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateHabitRequest].
extension CreateHabitRequestPatterns on CreateHabitRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateHabitRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateHabitRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateHabitRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateHabitRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateHabitRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateHabitRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String targetFrequency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateHabitRequest() when $default != null:
return $default(_that.id,_that.title,_that.targetFrequency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String targetFrequency)  $default,) {final _that = this;
switch (_that) {
case _CreateHabitRequest():
return $default(_that.id,_that.title,_that.targetFrequency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String targetFrequency)?  $default,) {final _that = this;
switch (_that) {
case _CreateHabitRequest() when $default != null:
return $default(_that.id,_that.title,_that.targetFrequency);case _:
  return null;

}
}

}

/// @nodoc


class _CreateHabitRequest implements CreateHabitRequest {
  const _CreateHabitRequest({required this.id, required this.title, required this.targetFrequency});
  

@override final  String id;
@override final  String title;
@override final  String targetFrequency;

/// Create a copy of CreateHabitRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateHabitRequestCopyWith<_CreateHabitRequest> get copyWith => __$CreateHabitRequestCopyWithImpl<_CreateHabitRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateHabitRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.targetFrequency, targetFrequency) || other.targetFrequency == targetFrequency));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,targetFrequency);

@override
String toString() {
  return 'CreateHabitRequest(id: $id, title: $title, targetFrequency: $targetFrequency)';
}


}

/// @nodoc
abstract mixin class _$CreateHabitRequestCopyWith<$Res> implements $CreateHabitRequestCopyWith<$Res> {
  factory _$CreateHabitRequestCopyWith(_CreateHabitRequest value, $Res Function(_CreateHabitRequest) _then) = __$CreateHabitRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String targetFrequency
});




}
/// @nodoc
class __$CreateHabitRequestCopyWithImpl<$Res>
    implements _$CreateHabitRequestCopyWith<$Res> {
  __$CreateHabitRequestCopyWithImpl(this._self, this._then);

  final _CreateHabitRequest _self;
  final $Res Function(_CreateHabitRequest) _then;

/// Create a copy of CreateHabitRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? targetFrequency = null,}) {
  return _then(_CreateHabitRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,targetFrequency: null == targetFrequency ? _self.targetFrequency : targetFrequency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
