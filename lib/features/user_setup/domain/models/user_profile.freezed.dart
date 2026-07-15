// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserProfile {

 String get name; String get avatarAssetPath; String get accentWorkspaceId; ThemeMode get themeMode; bool get dailyReminderEnabled; bool get biometricLockEnabled;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarAssetPath, avatarAssetPath) || other.avatarAssetPath == avatarAssetPath)&&(identical(other.accentWorkspaceId, accentWorkspaceId) || other.accentWorkspaceId == accentWorkspaceId)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.dailyReminderEnabled, dailyReminderEnabled) || other.dailyReminderEnabled == dailyReminderEnabled)&&(identical(other.biometricLockEnabled, biometricLockEnabled) || other.biometricLockEnabled == biometricLockEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,name,avatarAssetPath,accentWorkspaceId,themeMode,dailyReminderEnabled,biometricLockEnabled);

@override
String toString() {
  return 'UserProfile(name: $name, avatarAssetPath: $avatarAssetPath, accentWorkspaceId: $accentWorkspaceId, themeMode: $themeMode, dailyReminderEnabled: $dailyReminderEnabled, biometricLockEnabled: $biometricLockEnabled)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String name, String avatarAssetPath, String accentWorkspaceId, ThemeMode themeMode, bool dailyReminderEnabled, bool biometricLockEnabled
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? avatarAssetPath = null,Object? accentWorkspaceId = null,Object? themeMode = null,Object? dailyReminderEnabled = null,Object? biometricLockEnabled = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarAssetPath: null == avatarAssetPath ? _self.avatarAssetPath : avatarAssetPath // ignore: cast_nullable_to_non_nullable
as String,accentWorkspaceId: null == accentWorkspaceId ? _self.accentWorkspaceId : accentWorkspaceId // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,dailyReminderEnabled: null == dailyReminderEnabled ? _self.dailyReminderEnabled : dailyReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,biometricLockEnabled: null == biometricLockEnabled ? _self.biometricLockEnabled : biometricLockEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String avatarAssetPath,  String accentWorkspaceId,  ThemeMode themeMode,  bool dailyReminderEnabled,  bool biometricLockEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.name,_that.avatarAssetPath,_that.accentWorkspaceId,_that.themeMode,_that.dailyReminderEnabled,_that.biometricLockEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String avatarAssetPath,  String accentWorkspaceId,  ThemeMode themeMode,  bool dailyReminderEnabled,  bool biometricLockEnabled)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.name,_that.avatarAssetPath,_that.accentWorkspaceId,_that.themeMode,_that.dailyReminderEnabled,_that.biometricLockEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String avatarAssetPath,  String accentWorkspaceId,  ThemeMode themeMode,  bool dailyReminderEnabled,  bool biometricLockEnabled)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.name,_that.avatarAssetPath,_that.accentWorkspaceId,_that.themeMode,_that.dailyReminderEnabled,_that.biometricLockEnabled);case _:
  return null;

}
}

}

/// @nodoc


class _UserProfile implements UserProfile {
  const _UserProfile({required this.name, required this.avatarAssetPath, required this.accentWorkspaceId, required this.themeMode, required this.dailyReminderEnabled, required this.biometricLockEnabled});
  

@override final  String name;
@override final  String avatarAssetPath;
@override final  String accentWorkspaceId;
@override final  ThemeMode themeMode;
@override final  bool dailyReminderEnabled;
@override final  bool biometricLockEnabled;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarAssetPath, avatarAssetPath) || other.avatarAssetPath == avatarAssetPath)&&(identical(other.accentWorkspaceId, accentWorkspaceId) || other.accentWorkspaceId == accentWorkspaceId)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.dailyReminderEnabled, dailyReminderEnabled) || other.dailyReminderEnabled == dailyReminderEnabled)&&(identical(other.biometricLockEnabled, biometricLockEnabled) || other.biometricLockEnabled == biometricLockEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,name,avatarAssetPath,accentWorkspaceId,themeMode,dailyReminderEnabled,biometricLockEnabled);

@override
String toString() {
  return 'UserProfile(name: $name, avatarAssetPath: $avatarAssetPath, accentWorkspaceId: $accentWorkspaceId, themeMode: $themeMode, dailyReminderEnabled: $dailyReminderEnabled, biometricLockEnabled: $biometricLockEnabled)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String name, String avatarAssetPath, String accentWorkspaceId, ThemeMode themeMode, bool dailyReminderEnabled, bool biometricLockEnabled
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? avatarAssetPath = null,Object? accentWorkspaceId = null,Object? themeMode = null,Object? dailyReminderEnabled = null,Object? biometricLockEnabled = null,}) {
  return _then(_UserProfile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarAssetPath: null == avatarAssetPath ? _self.avatarAssetPath : avatarAssetPath // ignore: cast_nullable_to_non_nullable
as String,accentWorkspaceId: null == accentWorkspaceId ? _self.accentWorkspaceId : accentWorkspaceId // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,dailyReminderEnabled: null == dailyReminderEnabled ? _self.dailyReminderEnabled : dailyReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,biometricLockEnabled: null == biometricLockEnabled ? _self.biometricLockEnabled : biometricLockEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
