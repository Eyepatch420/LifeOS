// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workspace_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkspaceTheme {

 String get id; Color get primary; Color get secondary; List<Color> get heroGradient; Color get fabColor; Color get chipSelectedColor; List<Color> get chartPalette;
/// Create a copy of WorkspaceTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkspaceThemeCopyWith<WorkspaceTheme> get copyWith => _$WorkspaceThemeCopyWithImpl<WorkspaceTheme>(this as WorkspaceTheme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkspaceTheme&&(identical(other.id, id) || other.id == id)&&(identical(other.primary, primary) || other.primary == primary)&&(identical(other.secondary, secondary) || other.secondary == secondary)&&const DeepCollectionEquality().equals(other.heroGradient, heroGradient)&&(identical(other.fabColor, fabColor) || other.fabColor == fabColor)&&(identical(other.chipSelectedColor, chipSelectedColor) || other.chipSelectedColor == chipSelectedColor)&&const DeepCollectionEquality().equals(other.chartPalette, chartPalette));
}


@override
int get hashCode => Object.hash(runtimeType,id,primary,secondary,const DeepCollectionEquality().hash(heroGradient),fabColor,chipSelectedColor,const DeepCollectionEquality().hash(chartPalette));

@override
String toString() {
  return 'WorkspaceTheme(id: $id, primary: $primary, secondary: $secondary, heroGradient: $heroGradient, fabColor: $fabColor, chipSelectedColor: $chipSelectedColor, chartPalette: $chartPalette)';
}


}

/// @nodoc
abstract mixin class $WorkspaceThemeCopyWith<$Res>  {
  factory $WorkspaceThemeCopyWith(WorkspaceTheme value, $Res Function(WorkspaceTheme) _then) = _$WorkspaceThemeCopyWithImpl;
@useResult
$Res call({
 String id, Color primary, Color secondary, List<Color> heroGradient, Color fabColor, Color chipSelectedColor, List<Color> chartPalette
});




}
/// @nodoc
class _$WorkspaceThemeCopyWithImpl<$Res>
    implements $WorkspaceThemeCopyWith<$Res> {
  _$WorkspaceThemeCopyWithImpl(this._self, this._then);

  final WorkspaceTheme _self;
  final $Res Function(WorkspaceTheme) _then;

/// Create a copy of WorkspaceTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? primary = null,Object? secondary = null,Object? heroGradient = null,Object? fabColor = null,Object? chipSelectedColor = null,Object? chartPalette = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,primary: null == primary ? _self.primary : primary // ignore: cast_nullable_to_non_nullable
as Color,secondary: null == secondary ? _self.secondary : secondary // ignore: cast_nullable_to_non_nullable
as Color,heroGradient: null == heroGradient ? _self.heroGradient : heroGradient // ignore: cast_nullable_to_non_nullable
as List<Color>,fabColor: null == fabColor ? _self.fabColor : fabColor // ignore: cast_nullable_to_non_nullable
as Color,chipSelectedColor: null == chipSelectedColor ? _self.chipSelectedColor : chipSelectedColor // ignore: cast_nullable_to_non_nullable
as Color,chartPalette: null == chartPalette ? _self.chartPalette : chartPalette // ignore: cast_nullable_to_non_nullable
as List<Color>,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkspaceTheme].
extension WorkspaceThemePatterns on WorkspaceTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkspaceTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkspaceTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkspaceTheme value)  $default,){
final _that = this;
switch (_that) {
case _WorkspaceTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkspaceTheme value)?  $default,){
final _that = this;
switch (_that) {
case _WorkspaceTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Color primary,  Color secondary,  List<Color> heroGradient,  Color fabColor,  Color chipSelectedColor,  List<Color> chartPalette)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkspaceTheme() when $default != null:
return $default(_that.id,_that.primary,_that.secondary,_that.heroGradient,_that.fabColor,_that.chipSelectedColor,_that.chartPalette);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Color primary,  Color secondary,  List<Color> heroGradient,  Color fabColor,  Color chipSelectedColor,  List<Color> chartPalette)  $default,) {final _that = this;
switch (_that) {
case _WorkspaceTheme():
return $default(_that.id,_that.primary,_that.secondary,_that.heroGradient,_that.fabColor,_that.chipSelectedColor,_that.chartPalette);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Color primary,  Color secondary,  List<Color> heroGradient,  Color fabColor,  Color chipSelectedColor,  List<Color> chartPalette)?  $default,) {final _that = this;
switch (_that) {
case _WorkspaceTheme() when $default != null:
return $default(_that.id,_that.primary,_that.secondary,_that.heroGradient,_that.fabColor,_that.chipSelectedColor,_that.chartPalette);case _:
  return null;

}
}

}

/// @nodoc


class _WorkspaceTheme implements WorkspaceTheme {
  const _WorkspaceTheme({required this.id, required this.primary, required this.secondary, required final  List<Color> heroGradient, required this.fabColor, required this.chipSelectedColor, required final  List<Color> chartPalette}): _heroGradient = heroGradient,_chartPalette = chartPalette;
  

@override final  String id;
@override final  Color primary;
@override final  Color secondary;
 final  List<Color> _heroGradient;
@override List<Color> get heroGradient {
  if (_heroGradient is EqualUnmodifiableListView) return _heroGradient;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_heroGradient);
}

@override final  Color fabColor;
@override final  Color chipSelectedColor;
 final  List<Color> _chartPalette;
@override List<Color> get chartPalette {
  if (_chartPalette is EqualUnmodifiableListView) return _chartPalette;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chartPalette);
}


/// Create a copy of WorkspaceTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkspaceThemeCopyWith<_WorkspaceTheme> get copyWith => __$WorkspaceThemeCopyWithImpl<_WorkspaceTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkspaceTheme&&(identical(other.id, id) || other.id == id)&&(identical(other.primary, primary) || other.primary == primary)&&(identical(other.secondary, secondary) || other.secondary == secondary)&&const DeepCollectionEquality().equals(other._heroGradient, _heroGradient)&&(identical(other.fabColor, fabColor) || other.fabColor == fabColor)&&(identical(other.chipSelectedColor, chipSelectedColor) || other.chipSelectedColor == chipSelectedColor)&&const DeepCollectionEquality().equals(other._chartPalette, _chartPalette));
}


@override
int get hashCode => Object.hash(runtimeType,id,primary,secondary,const DeepCollectionEquality().hash(_heroGradient),fabColor,chipSelectedColor,const DeepCollectionEquality().hash(_chartPalette));

@override
String toString() {
  return 'WorkspaceTheme(id: $id, primary: $primary, secondary: $secondary, heroGradient: $heroGradient, fabColor: $fabColor, chipSelectedColor: $chipSelectedColor, chartPalette: $chartPalette)';
}


}

/// @nodoc
abstract mixin class _$WorkspaceThemeCopyWith<$Res> implements $WorkspaceThemeCopyWith<$Res> {
  factory _$WorkspaceThemeCopyWith(_WorkspaceTheme value, $Res Function(_WorkspaceTheme) _then) = __$WorkspaceThemeCopyWithImpl;
@override @useResult
$Res call({
 String id, Color primary, Color secondary, List<Color> heroGradient, Color fabColor, Color chipSelectedColor, List<Color> chartPalette
});




}
/// @nodoc
class __$WorkspaceThemeCopyWithImpl<$Res>
    implements _$WorkspaceThemeCopyWith<$Res> {
  __$WorkspaceThemeCopyWithImpl(this._self, this._then);

  final _WorkspaceTheme _self;
  final $Res Function(_WorkspaceTheme) _then;

/// Create a copy of WorkspaceTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? primary = null,Object? secondary = null,Object? heroGradient = null,Object? fabColor = null,Object? chipSelectedColor = null,Object? chartPalette = null,}) {
  return _then(_WorkspaceTheme(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,primary: null == primary ? _self.primary : primary // ignore: cast_nullable_to_non_nullable
as Color,secondary: null == secondary ? _self.secondary : secondary // ignore: cast_nullable_to_non_nullable
as Color,heroGradient: null == heroGradient ? _self._heroGradient : heroGradient // ignore: cast_nullable_to_non_nullable
as List<Color>,fabColor: null == fabColor ? _self.fabColor : fabColor // ignore: cast_nullable_to_non_nullable
as Color,chipSelectedColor: null == chipSelectedColor ? _self.chipSelectedColor : chipSelectedColor // ignore: cast_nullable_to_non_nullable
as Color,chartPalette: null == chartPalette ? _self._chartPalette : chartPalette // ignore: cast_nullable_to_non_nullable
as List<Color>,
  ));
}


}

// dart format on
