// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_setup_form_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserSetupFormState {

 String get name; String get avatarId; String get accentWorkspaceId; ThemeMode get themeMode; bool get dailyReminderEnabled; bool get biometricLockRequested;
/// Create a copy of UserSetupFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSetupFormStateCopyWith<UserSetupFormState> get copyWith => _$UserSetupFormStateCopyWithImpl<UserSetupFormState>(this as UserSetupFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSetupFormState&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarId, avatarId) || other.avatarId == avatarId)&&(identical(other.accentWorkspaceId, accentWorkspaceId) || other.accentWorkspaceId == accentWorkspaceId)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.dailyReminderEnabled, dailyReminderEnabled) || other.dailyReminderEnabled == dailyReminderEnabled)&&(identical(other.biometricLockRequested, biometricLockRequested) || other.biometricLockRequested == biometricLockRequested));
}


@override
int get hashCode => Object.hash(runtimeType,name,avatarId,accentWorkspaceId,themeMode,dailyReminderEnabled,biometricLockRequested);

@override
String toString() {
  return 'UserSetupFormState(name: $name, avatarId: $avatarId, accentWorkspaceId: $accentWorkspaceId, themeMode: $themeMode, dailyReminderEnabled: $dailyReminderEnabled, biometricLockRequested: $biometricLockRequested)';
}


}

/// @nodoc
abstract mixin class $UserSetupFormStateCopyWith<$Res>  {
  factory $UserSetupFormStateCopyWith(UserSetupFormState value, $Res Function(UserSetupFormState) _then) = _$UserSetupFormStateCopyWithImpl;
@useResult
$Res call({
 String name, String avatarId, String accentWorkspaceId, ThemeMode themeMode, bool dailyReminderEnabled, bool biometricLockRequested
});




}
/// @nodoc
class _$UserSetupFormStateCopyWithImpl<$Res>
    implements $UserSetupFormStateCopyWith<$Res> {
  _$UserSetupFormStateCopyWithImpl(this._self, this._then);

  final UserSetupFormState _self;
  final $Res Function(UserSetupFormState) _then;

/// Create a copy of UserSetupFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? avatarId = null,Object? accentWorkspaceId = null,Object? themeMode = null,Object? dailyReminderEnabled = null,Object? biometricLockRequested = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarId: null == avatarId ? _self.avatarId : avatarId // ignore: cast_nullable_to_non_nullable
as String,accentWorkspaceId: null == accentWorkspaceId ? _self.accentWorkspaceId : accentWorkspaceId // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,dailyReminderEnabled: null == dailyReminderEnabled ? _self.dailyReminderEnabled : dailyReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,biometricLockRequested: null == biometricLockRequested ? _self.biometricLockRequested : biometricLockRequested // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserSetupFormState].
extension UserSetupFormStatePatterns on UserSetupFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSetupFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSetupFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSetupFormState value)  $default,){
final _that = this;
switch (_that) {
case _UserSetupFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSetupFormState value)?  $default,){
final _that = this;
switch (_that) {
case _UserSetupFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String avatarId,  String accentWorkspaceId,  ThemeMode themeMode,  bool dailyReminderEnabled,  bool biometricLockRequested)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSetupFormState() when $default != null:
return $default(_that.name,_that.avatarId,_that.accentWorkspaceId,_that.themeMode,_that.dailyReminderEnabled,_that.biometricLockRequested);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String avatarId,  String accentWorkspaceId,  ThemeMode themeMode,  bool dailyReminderEnabled,  bool biometricLockRequested)  $default,) {final _that = this;
switch (_that) {
case _UserSetupFormState():
return $default(_that.name,_that.avatarId,_that.accentWorkspaceId,_that.themeMode,_that.dailyReminderEnabled,_that.biometricLockRequested);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String avatarId,  String accentWorkspaceId,  ThemeMode themeMode,  bool dailyReminderEnabled,  bool biometricLockRequested)?  $default,) {final _that = this;
switch (_that) {
case _UserSetupFormState() when $default != null:
return $default(_that.name,_that.avatarId,_that.accentWorkspaceId,_that.themeMode,_that.dailyReminderEnabled,_that.biometricLockRequested);case _:
  return null;

}
}

}

/// @nodoc


class _UserSetupFormState implements UserSetupFormState {
  const _UserSetupFormState({this.name = '', this.avatarId = 'fox', this.accentWorkspaceId = WorkspaceIds.home, this.themeMode = ThemeMode.system, this.dailyReminderEnabled = true, this.biometricLockRequested = false});
  

@override@JsonKey() final  String name;
@override@JsonKey() final  String avatarId;
@override@JsonKey() final  String accentWorkspaceId;
@override@JsonKey() final  ThemeMode themeMode;
@override@JsonKey() final  bool dailyReminderEnabled;
@override@JsonKey() final  bool biometricLockRequested;

/// Create a copy of UserSetupFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSetupFormStateCopyWith<_UserSetupFormState> get copyWith => __$UserSetupFormStateCopyWithImpl<_UserSetupFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSetupFormState&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarId, avatarId) || other.avatarId == avatarId)&&(identical(other.accentWorkspaceId, accentWorkspaceId) || other.accentWorkspaceId == accentWorkspaceId)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.dailyReminderEnabled, dailyReminderEnabled) || other.dailyReminderEnabled == dailyReminderEnabled)&&(identical(other.biometricLockRequested, biometricLockRequested) || other.biometricLockRequested == biometricLockRequested));
}


@override
int get hashCode => Object.hash(runtimeType,name,avatarId,accentWorkspaceId,themeMode,dailyReminderEnabled,biometricLockRequested);

@override
String toString() {
  return 'UserSetupFormState(name: $name, avatarId: $avatarId, accentWorkspaceId: $accentWorkspaceId, themeMode: $themeMode, dailyReminderEnabled: $dailyReminderEnabled, biometricLockRequested: $biometricLockRequested)';
}


}

/// @nodoc
abstract mixin class _$UserSetupFormStateCopyWith<$Res> implements $UserSetupFormStateCopyWith<$Res> {
  factory _$UserSetupFormStateCopyWith(_UserSetupFormState value, $Res Function(_UserSetupFormState) _then) = __$UserSetupFormStateCopyWithImpl;
@override @useResult
$Res call({
 String name, String avatarId, String accentWorkspaceId, ThemeMode themeMode, bool dailyReminderEnabled, bool biometricLockRequested
});




}
/// @nodoc
class __$UserSetupFormStateCopyWithImpl<$Res>
    implements _$UserSetupFormStateCopyWith<$Res> {
  __$UserSetupFormStateCopyWithImpl(this._self, this._then);

  final _UserSetupFormState _self;
  final $Res Function(_UserSetupFormState) _then;

/// Create a copy of UserSetupFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? avatarId = null,Object? accentWorkspaceId = null,Object? themeMode = null,Object? dailyReminderEnabled = null,Object? biometricLockRequested = null,}) {
  return _then(_UserSetupFormState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarId: null == avatarId ? _self.avatarId : avatarId // ignore: cast_nullable_to_non_nullable
as String,accentWorkspaceId: null == accentWorkspaceId ? _self.accentWorkspaceId : accentWorkspaceId // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,dailyReminderEnabled: null == dailyReminderEnabled ? _self.dailyReminderEnabled : dailyReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,biometricLockRequested: null == biometricLockRequested ? _self.biometricLockRequested : biometricLockRequested // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
