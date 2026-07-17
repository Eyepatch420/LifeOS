// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'searchable_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchableEntity {

 String get id; String get title; String get subtitle; IconData get icon; SearchableEntityCategory get category; String get routeName; Map<String, String>? get pathParameters;
/// Create a copy of SearchableEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchableEntityCopyWith<SearchableEntity> get copyWith => _$SearchableEntityCopyWithImpl<SearchableEntity>(this as SearchableEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchableEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.category, category) || other.category == category)&&(identical(other.routeName, routeName) || other.routeName == routeName)&&const DeepCollectionEquality().equals(other.pathParameters, pathParameters));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,icon,category,routeName,const DeepCollectionEquality().hash(pathParameters));

@override
String toString() {
  return 'SearchableEntity(id: $id, title: $title, subtitle: $subtitle, icon: $icon, category: $category, routeName: $routeName, pathParameters: $pathParameters)';
}


}

/// @nodoc
abstract mixin class $SearchableEntityCopyWith<$Res>  {
  factory $SearchableEntityCopyWith(SearchableEntity value, $Res Function(SearchableEntity) _then) = _$SearchableEntityCopyWithImpl;
@useResult
$Res call({
 String id, String title, String subtitle, IconData icon, SearchableEntityCategory category, String routeName, Map<String, String>? pathParameters
});




}
/// @nodoc
class _$SearchableEntityCopyWithImpl<$Res>
    implements $SearchableEntityCopyWith<$Res> {
  _$SearchableEntityCopyWithImpl(this._self, this._then);

  final SearchableEntity _self;
  final $Res Function(SearchableEntity) _then;

/// Create a copy of SearchableEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? icon = null,Object? category = null,Object? routeName = null,Object? pathParameters = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SearchableEntityCategory,routeName: null == routeName ? _self.routeName : routeName // ignore: cast_nullable_to_non_nullable
as String,pathParameters: freezed == pathParameters ? _self.pathParameters : pathParameters // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchableEntity].
extension SearchableEntityPatterns on SearchableEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchableEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchableEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchableEntity value)  $default,){
final _that = this;
switch (_that) {
case _SearchableEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchableEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SearchableEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  IconData icon,  SearchableEntityCategory category,  String routeName,  Map<String, String>? pathParameters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchableEntity() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.icon,_that.category,_that.routeName,_that.pathParameters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  IconData icon,  SearchableEntityCategory category,  String routeName,  Map<String, String>? pathParameters)  $default,) {final _that = this;
switch (_that) {
case _SearchableEntity():
return $default(_that.id,_that.title,_that.subtitle,_that.icon,_that.category,_that.routeName,_that.pathParameters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String subtitle,  IconData icon,  SearchableEntityCategory category,  String routeName,  Map<String, String>? pathParameters)?  $default,) {final _that = this;
switch (_that) {
case _SearchableEntity() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.icon,_that.category,_that.routeName,_that.pathParameters);case _:
  return null;

}
}

}

/// @nodoc


class _SearchableEntity implements SearchableEntity {
  const _SearchableEntity({required this.id, required this.title, required this.subtitle, required this.icon, required this.category, required this.routeName, final  Map<String, String>? pathParameters}): _pathParameters = pathParameters;
  

@override final  String id;
@override final  String title;
@override final  String subtitle;
@override final  IconData icon;
@override final  SearchableEntityCategory category;
@override final  String routeName;
 final  Map<String, String>? _pathParameters;
@override Map<String, String>? get pathParameters {
  final value = _pathParameters;
  if (value == null) return null;
  if (_pathParameters is EqualUnmodifiableMapView) return _pathParameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of SearchableEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchableEntityCopyWith<_SearchableEntity> get copyWith => __$SearchableEntityCopyWithImpl<_SearchableEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchableEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.category, category) || other.category == category)&&(identical(other.routeName, routeName) || other.routeName == routeName)&&const DeepCollectionEquality().equals(other._pathParameters, _pathParameters));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,icon,category,routeName,const DeepCollectionEquality().hash(_pathParameters));

@override
String toString() {
  return 'SearchableEntity(id: $id, title: $title, subtitle: $subtitle, icon: $icon, category: $category, routeName: $routeName, pathParameters: $pathParameters)';
}


}

/// @nodoc
abstract mixin class _$SearchableEntityCopyWith<$Res> implements $SearchableEntityCopyWith<$Res> {
  factory _$SearchableEntityCopyWith(_SearchableEntity value, $Res Function(_SearchableEntity) _then) = __$SearchableEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String subtitle, IconData icon, SearchableEntityCategory category, String routeName, Map<String, String>? pathParameters
});




}
/// @nodoc
class __$SearchableEntityCopyWithImpl<$Res>
    implements _$SearchableEntityCopyWith<$Res> {
  __$SearchableEntityCopyWithImpl(this._self, this._then);

  final _SearchableEntity _self;
  final $Res Function(_SearchableEntity) _then;

/// Create a copy of SearchableEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? icon = null,Object? category = null,Object? routeName = null,Object? pathParameters = freezed,}) {
  return _then(_SearchableEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SearchableEntityCategory,routeName: null == routeName ? _self.routeName : routeName // ignore: cast_nullable_to_non_nullable
as String,pathParameters: freezed == pathParameters ? _self._pathParameters : pathParameters // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}


}

// dart format on
