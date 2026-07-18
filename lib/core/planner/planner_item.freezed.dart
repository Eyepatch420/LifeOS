// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'planner_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlannerItem {

 String get id; PlannerSourceType get sourceType; String get sourceId; String get title; DateTime get scheduledAt; bool get isCompleted; bool get isUrgent; bool get isRecurring; String get routeName; Map<String, String> get pathParameters;
/// Create a copy of PlannerItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlannerItemCopyWith<PlannerItem> get copyWith => _$PlannerItemCopyWithImpl<PlannerItem>(this as PlannerItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlannerItem&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.isUrgent, isUrgent) || other.isUrgent == isUrgent)&&(identical(other.isRecurring, isRecurring) || other.isRecurring == isRecurring)&&(identical(other.routeName, routeName) || other.routeName == routeName)&&const DeepCollectionEquality().equals(other.pathParameters, pathParameters));
}


@override
int get hashCode => Object.hash(runtimeType,id,sourceType,sourceId,title,scheduledAt,isCompleted,isUrgent,isRecurring,routeName,const DeepCollectionEquality().hash(pathParameters));

@override
String toString() {
  return 'PlannerItem(id: $id, sourceType: $sourceType, sourceId: $sourceId, title: $title, scheduledAt: $scheduledAt, isCompleted: $isCompleted, isUrgent: $isUrgent, isRecurring: $isRecurring, routeName: $routeName, pathParameters: $pathParameters)';
}


}

/// @nodoc
abstract mixin class $PlannerItemCopyWith<$Res>  {
  factory $PlannerItemCopyWith(PlannerItem value, $Res Function(PlannerItem) _then) = _$PlannerItemCopyWithImpl;
@useResult
$Res call({
 String id, PlannerSourceType sourceType, String sourceId, String title, DateTime scheduledAt, bool isCompleted, bool isUrgent, bool isRecurring, String routeName, Map<String, String> pathParameters
});




}
/// @nodoc
class _$PlannerItemCopyWithImpl<$Res>
    implements $PlannerItemCopyWith<$Res> {
  _$PlannerItemCopyWithImpl(this._self, this._then);

  final PlannerItem _self;
  final $Res Function(PlannerItem) _then;

/// Create a copy of PlannerItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceType = null,Object? sourceId = null,Object? title = null,Object? scheduledAt = null,Object? isCompleted = null,Object? isUrgent = null,Object? isRecurring = null,Object? routeName = null,Object? pathParameters = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as PlannerSourceType,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,isUrgent: null == isUrgent ? _self.isUrgent : isUrgent // ignore: cast_nullable_to_non_nullable
as bool,isRecurring: null == isRecurring ? _self.isRecurring : isRecurring // ignore: cast_nullable_to_non_nullable
as bool,routeName: null == routeName ? _self.routeName : routeName // ignore: cast_nullable_to_non_nullable
as String,pathParameters: null == pathParameters ? _self.pathParameters : pathParameters // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlannerItem].
extension PlannerItemPatterns on PlannerItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlannerItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlannerItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlannerItem value)  $default,){
final _that = this;
switch (_that) {
case _PlannerItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlannerItem value)?  $default,){
final _that = this;
switch (_that) {
case _PlannerItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  PlannerSourceType sourceType,  String sourceId,  String title,  DateTime scheduledAt,  bool isCompleted,  bool isUrgent,  bool isRecurring,  String routeName,  Map<String, String> pathParameters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlannerItem() when $default != null:
return $default(_that.id,_that.sourceType,_that.sourceId,_that.title,_that.scheduledAt,_that.isCompleted,_that.isUrgent,_that.isRecurring,_that.routeName,_that.pathParameters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  PlannerSourceType sourceType,  String sourceId,  String title,  DateTime scheduledAt,  bool isCompleted,  bool isUrgent,  bool isRecurring,  String routeName,  Map<String, String> pathParameters)  $default,) {final _that = this;
switch (_that) {
case _PlannerItem():
return $default(_that.id,_that.sourceType,_that.sourceId,_that.title,_that.scheduledAt,_that.isCompleted,_that.isUrgent,_that.isRecurring,_that.routeName,_that.pathParameters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  PlannerSourceType sourceType,  String sourceId,  String title,  DateTime scheduledAt,  bool isCompleted,  bool isUrgent,  bool isRecurring,  String routeName,  Map<String, String> pathParameters)?  $default,) {final _that = this;
switch (_that) {
case _PlannerItem() when $default != null:
return $default(_that.id,_that.sourceType,_that.sourceId,_that.title,_that.scheduledAt,_that.isCompleted,_that.isUrgent,_that.isRecurring,_that.routeName,_that.pathParameters);case _:
  return null;

}
}

}

/// @nodoc


class _PlannerItem implements PlannerItem {
  const _PlannerItem({required this.id, required this.sourceType, required this.sourceId, required this.title, required this.scheduledAt, required this.isCompleted, required this.isUrgent, required this.isRecurring, required this.routeName, required final  Map<String, String> pathParameters}): _pathParameters = pathParameters;
  

@override final  String id;
@override final  PlannerSourceType sourceType;
@override final  String sourceId;
@override final  String title;
@override final  DateTime scheduledAt;
@override final  bool isCompleted;
@override final  bool isUrgent;
@override final  bool isRecurring;
@override final  String routeName;
 final  Map<String, String> _pathParameters;
@override Map<String, String> get pathParameters {
  if (_pathParameters is EqualUnmodifiableMapView) return _pathParameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_pathParameters);
}


/// Create a copy of PlannerItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlannerItemCopyWith<_PlannerItem> get copyWith => __$PlannerItemCopyWithImpl<_PlannerItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlannerItem&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.isUrgent, isUrgent) || other.isUrgent == isUrgent)&&(identical(other.isRecurring, isRecurring) || other.isRecurring == isRecurring)&&(identical(other.routeName, routeName) || other.routeName == routeName)&&const DeepCollectionEquality().equals(other._pathParameters, _pathParameters));
}


@override
int get hashCode => Object.hash(runtimeType,id,sourceType,sourceId,title,scheduledAt,isCompleted,isUrgent,isRecurring,routeName,const DeepCollectionEquality().hash(_pathParameters));

@override
String toString() {
  return 'PlannerItem(id: $id, sourceType: $sourceType, sourceId: $sourceId, title: $title, scheduledAt: $scheduledAt, isCompleted: $isCompleted, isUrgent: $isUrgent, isRecurring: $isRecurring, routeName: $routeName, pathParameters: $pathParameters)';
}


}

/// @nodoc
abstract mixin class _$PlannerItemCopyWith<$Res> implements $PlannerItemCopyWith<$Res> {
  factory _$PlannerItemCopyWith(_PlannerItem value, $Res Function(_PlannerItem) _then) = __$PlannerItemCopyWithImpl;
@override @useResult
$Res call({
 String id, PlannerSourceType sourceType, String sourceId, String title, DateTime scheduledAt, bool isCompleted, bool isUrgent, bool isRecurring, String routeName, Map<String, String> pathParameters
});




}
/// @nodoc
class __$PlannerItemCopyWithImpl<$Res>
    implements _$PlannerItemCopyWith<$Res> {
  __$PlannerItemCopyWithImpl(this._self, this._then);

  final _PlannerItem _self;
  final $Res Function(_PlannerItem) _then;

/// Create a copy of PlannerItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceType = null,Object? sourceId = null,Object? title = null,Object? scheduledAt = null,Object? isCompleted = null,Object? isUrgent = null,Object? isRecurring = null,Object? routeName = null,Object? pathParameters = null,}) {
  return _then(_PlannerItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as PlannerSourceType,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,isUrgent: null == isUrgent ? _self.isUrgent : isUrgent // ignore: cast_nullable_to_non_nullable
as bool,isRecurring: null == isRecurring ? _self.isRecurring : isRecurring // ignore: cast_nullable_to_non_nullable
as bool,routeName: null == routeName ? _self.routeName : routeName // ignore: cast_nullable_to_non_nullable
as String,pathParameters: null == pathParameters ? _self._pathParameters : pathParameters // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
