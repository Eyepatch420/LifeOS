// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_note_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateNoteRequest {

 String get id; String get title; String get body; DateTime get createdAt;
/// Create a copy of CreateNoteRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateNoteRequestCopyWith<CreateNoteRequest> get copyWith => _$CreateNoteRequestCopyWithImpl<CreateNoteRequest>(this as CreateNoteRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateNoteRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,body,createdAt);

@override
String toString() {
  return 'CreateNoteRequest(id: $id, title: $title, body: $body, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CreateNoteRequestCopyWith<$Res>  {
  factory $CreateNoteRequestCopyWith(CreateNoteRequest value, $Res Function(CreateNoteRequest) _then) = _$CreateNoteRequestCopyWithImpl;
@useResult
$Res call({
 String id, String title, String body, DateTime createdAt
});




}
/// @nodoc
class _$CreateNoteRequestCopyWithImpl<$Res>
    implements $CreateNoteRequestCopyWith<$Res> {
  _$CreateNoteRequestCopyWithImpl(this._self, this._then);

  final CreateNoteRequest _self;
  final $Res Function(CreateNoteRequest) _then;

/// Create a copy of CreateNoteRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? body = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateNoteRequest].
extension CreateNoteRequestPatterns on CreateNoteRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateNoteRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateNoteRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateNoteRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateNoteRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateNoteRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateNoteRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String body,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateNoteRequest() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String body,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CreateNoteRequest():
return $default(_that.id,_that.title,_that.body,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String body,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CreateNoteRequest() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _CreateNoteRequest implements CreateNoteRequest {
  const _CreateNoteRequest({required this.id, required this.title, required this.body, required this.createdAt});
  

@override final  String id;
@override final  String title;
@override final  String body;
@override final  DateTime createdAt;

/// Create a copy of CreateNoteRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateNoteRequestCopyWith<_CreateNoteRequest> get copyWith => __$CreateNoteRequestCopyWithImpl<_CreateNoteRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateNoteRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,body,createdAt);

@override
String toString() {
  return 'CreateNoteRequest(id: $id, title: $title, body: $body, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CreateNoteRequestCopyWith<$Res> implements $CreateNoteRequestCopyWith<$Res> {
  factory _$CreateNoteRequestCopyWith(_CreateNoteRequest value, $Res Function(_CreateNoteRequest) _then) = __$CreateNoteRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String body, DateTime createdAt
});




}
/// @nodoc
class __$CreateNoteRequestCopyWithImpl<$Res>
    implements _$CreateNoteRequestCopyWith<$Res> {
  __$CreateNoteRequestCopyWithImpl(this._self, this._then);

  final _CreateNoteRequest _self;
  final $Res Function(_CreateNoteRequest) _then;

/// Create a copy of CreateNoteRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? body = null,Object? createdAt = null,}) {
  return _then(_CreateNoteRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
