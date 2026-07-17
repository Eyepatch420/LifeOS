// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_expense_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateExpenseRequest {

 String get id; String get title; double get amount; String get category;
/// Create a copy of CreateExpenseRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateExpenseRequestCopyWith<CreateExpenseRequest> get copyWith => _$CreateExpenseRequestCopyWithImpl<CreateExpenseRequest>(this as CreateExpenseRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateExpenseRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,amount,category);

@override
String toString() {
  return 'CreateExpenseRequest(id: $id, title: $title, amount: $amount, category: $category)';
}


}

/// @nodoc
abstract mixin class $CreateExpenseRequestCopyWith<$Res>  {
  factory $CreateExpenseRequestCopyWith(CreateExpenseRequest value, $Res Function(CreateExpenseRequest) _then) = _$CreateExpenseRequestCopyWithImpl;
@useResult
$Res call({
 String id, String title, double amount, String category
});




}
/// @nodoc
class _$CreateExpenseRequestCopyWithImpl<$Res>
    implements $CreateExpenseRequestCopyWith<$Res> {
  _$CreateExpenseRequestCopyWithImpl(this._self, this._then);

  final CreateExpenseRequest _self;
  final $Res Function(CreateExpenseRequest) _then;

/// Create a copy of CreateExpenseRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? amount = null,Object? category = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateExpenseRequest].
extension CreateExpenseRequestPatterns on CreateExpenseRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateExpenseRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateExpenseRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateExpenseRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateExpenseRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateExpenseRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateExpenseRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  double amount,  String category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateExpenseRequest() when $default != null:
return $default(_that.id,_that.title,_that.amount,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  double amount,  String category)  $default,) {final _that = this;
switch (_that) {
case _CreateExpenseRequest():
return $default(_that.id,_that.title,_that.amount,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  double amount,  String category)?  $default,) {final _that = this;
switch (_that) {
case _CreateExpenseRequest() when $default != null:
return $default(_that.id,_that.title,_that.amount,_that.category);case _:
  return null;

}
}

}

/// @nodoc


class _CreateExpenseRequest implements CreateExpenseRequest {
  const _CreateExpenseRequest({required this.id, required this.title, required this.amount, required this.category});
  

@override final  String id;
@override final  String title;
@override final  double amount;
@override final  String category;

/// Create a copy of CreateExpenseRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateExpenseRequestCopyWith<_CreateExpenseRequest> get copyWith => __$CreateExpenseRequestCopyWithImpl<_CreateExpenseRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateExpenseRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,amount,category);

@override
String toString() {
  return 'CreateExpenseRequest(id: $id, title: $title, amount: $amount, category: $category)';
}


}

/// @nodoc
abstract mixin class _$CreateExpenseRequestCopyWith<$Res> implements $CreateExpenseRequestCopyWith<$Res> {
  factory _$CreateExpenseRequestCopyWith(_CreateExpenseRequest value, $Res Function(_CreateExpenseRequest) _then) = __$CreateExpenseRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, double amount, String category
});




}
/// @nodoc
class __$CreateExpenseRequestCopyWithImpl<$Res>
    implements _$CreateExpenseRequestCopyWith<$Res> {
  __$CreateExpenseRequestCopyWithImpl(this._self, this._then);

  final _CreateExpenseRequest _self;
  final $Res Function(_CreateExpenseRequest) _then;

/// Create a copy of CreateExpenseRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? amount = null,Object? category = null,}) {
  return _then(_CreateExpenseRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
