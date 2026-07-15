// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingPage {

 String get lottieAssetPath; String get title; String get subtitle; OnboardingAccent get accent;
/// Create a copy of OnboardingPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingPageCopyWith<OnboardingPage> get copyWith => _$OnboardingPageCopyWithImpl<OnboardingPage>(this as OnboardingPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingPage&&(identical(other.lottieAssetPath, lottieAssetPath) || other.lottieAssetPath == lottieAssetPath)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.accent, accent) || other.accent == accent));
}


@override
int get hashCode => Object.hash(runtimeType,lottieAssetPath,title,subtitle,accent);

@override
String toString() {
  return 'OnboardingPage(lottieAssetPath: $lottieAssetPath, title: $title, subtitle: $subtitle, accent: $accent)';
}


}

/// @nodoc
abstract mixin class $OnboardingPageCopyWith<$Res>  {
  factory $OnboardingPageCopyWith(OnboardingPage value, $Res Function(OnboardingPage) _then) = _$OnboardingPageCopyWithImpl;
@useResult
$Res call({
 String lottieAssetPath, String title, String subtitle, OnboardingAccent accent
});




}
/// @nodoc
class _$OnboardingPageCopyWithImpl<$Res>
    implements $OnboardingPageCopyWith<$Res> {
  _$OnboardingPageCopyWithImpl(this._self, this._then);

  final OnboardingPage _self;
  final $Res Function(OnboardingPage) _then;

/// Create a copy of OnboardingPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lottieAssetPath = null,Object? title = null,Object? subtitle = null,Object? accent = null,}) {
  return _then(_self.copyWith(
lottieAssetPath: null == lottieAssetPath ? _self.lottieAssetPath : lottieAssetPath // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,accent: null == accent ? _self.accent : accent // ignore: cast_nullable_to_non_nullable
as OnboardingAccent,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingPage].
extension OnboardingPagePatterns on OnboardingPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingPage value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingPage value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String lottieAssetPath,  String title,  String subtitle,  OnboardingAccent accent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingPage() when $default != null:
return $default(_that.lottieAssetPath,_that.title,_that.subtitle,_that.accent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String lottieAssetPath,  String title,  String subtitle,  OnboardingAccent accent)  $default,) {final _that = this;
switch (_that) {
case _OnboardingPage():
return $default(_that.lottieAssetPath,_that.title,_that.subtitle,_that.accent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String lottieAssetPath,  String title,  String subtitle,  OnboardingAccent accent)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingPage() when $default != null:
return $default(_that.lottieAssetPath,_that.title,_that.subtitle,_that.accent);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingPage implements OnboardingPage {
  const _OnboardingPage({required this.lottieAssetPath, required this.title, required this.subtitle, required this.accent});
  

@override final  String lottieAssetPath;
@override final  String title;
@override final  String subtitle;
@override final  OnboardingAccent accent;

/// Create a copy of OnboardingPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingPageCopyWith<_OnboardingPage> get copyWith => __$OnboardingPageCopyWithImpl<_OnboardingPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingPage&&(identical(other.lottieAssetPath, lottieAssetPath) || other.lottieAssetPath == lottieAssetPath)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.accent, accent) || other.accent == accent));
}


@override
int get hashCode => Object.hash(runtimeType,lottieAssetPath,title,subtitle,accent);

@override
String toString() {
  return 'OnboardingPage(lottieAssetPath: $lottieAssetPath, title: $title, subtitle: $subtitle, accent: $accent)';
}


}

/// @nodoc
abstract mixin class _$OnboardingPageCopyWith<$Res> implements $OnboardingPageCopyWith<$Res> {
  factory _$OnboardingPageCopyWith(_OnboardingPage value, $Res Function(_OnboardingPage) _then) = __$OnboardingPageCopyWithImpl;
@override @useResult
$Res call({
 String lottieAssetPath, String title, String subtitle, OnboardingAccent accent
});




}
/// @nodoc
class __$OnboardingPageCopyWithImpl<$Res>
    implements _$OnboardingPageCopyWith<$Res> {
  __$OnboardingPageCopyWithImpl(this._self, this._then);

  final _OnboardingPage _self;
  final $Res Function(_OnboardingPage) _then;

/// Create a copy of OnboardingPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lottieAssetPath = null,Object? title = null,Object? subtitle = null,Object? accent = null,}) {
  return _then(_OnboardingPage(
lottieAssetPath: null == lottieAssetPath ? _self.lottieAssetPath : lottieAssetPath // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,accent: null == accent ? _self.accent : accent // ignore: cast_nullable_to_non_nullable
as OnboardingAccent,
  ));
}


}

// dart format on
