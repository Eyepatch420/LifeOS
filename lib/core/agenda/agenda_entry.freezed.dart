// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agenda_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AgendaEntry {

 String get id; String get sourceModule; String get sourceId; IconData get icon; String get title; DateTime get time; Color get dotColor; bool get isUrgent;
/// Create a copy of AgendaEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgendaEntryCopyWith<AgendaEntry> get copyWith => _$AgendaEntryCopyWithImpl<AgendaEntry>(this as AgendaEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgendaEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceModule, sourceModule) || other.sourceModule == sourceModule)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.time, time) || other.time == time)&&(identical(other.dotColor, dotColor) || other.dotColor == dotColor)&&(identical(other.isUrgent, isUrgent) || other.isUrgent == isUrgent));
}


@override
int get hashCode => Object.hash(runtimeType,id,sourceModule,sourceId,icon,title,time,dotColor,isUrgent);

@override
String toString() {
  return 'AgendaEntry(id: $id, sourceModule: $sourceModule, sourceId: $sourceId, icon: $icon, title: $title, time: $time, dotColor: $dotColor, isUrgent: $isUrgent)';
}


}

/// @nodoc
abstract mixin class $AgendaEntryCopyWith<$Res>  {
  factory $AgendaEntryCopyWith(AgendaEntry value, $Res Function(AgendaEntry) _then) = _$AgendaEntryCopyWithImpl;
@useResult
$Res call({
 String id, String sourceModule, String sourceId, IconData icon, String title, DateTime time, Color dotColor, bool isUrgent
});




}
/// @nodoc
class _$AgendaEntryCopyWithImpl<$Res>
    implements $AgendaEntryCopyWith<$Res> {
  _$AgendaEntryCopyWithImpl(this._self, this._then);

  final AgendaEntry _self;
  final $Res Function(AgendaEntry) _then;

/// Create a copy of AgendaEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceModule = null,Object? sourceId = null,Object? icon = null,Object? title = null,Object? time = null,Object? dotColor = null,Object? isUrgent = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceModule: null == sourceModule ? _self.sourceModule : sourceModule // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,dotColor: null == dotColor ? _self.dotColor : dotColor // ignore: cast_nullable_to_non_nullable
as Color,isUrgent: null == isUrgent ? _self.isUrgent : isUrgent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AgendaEntry].
extension AgendaEntryPatterns on AgendaEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgendaEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgendaEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgendaEntry value)  $default,){
final _that = this;
switch (_that) {
case _AgendaEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgendaEntry value)?  $default,){
final _that = this;
switch (_that) {
case _AgendaEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourceModule,  String sourceId,  IconData icon,  String title,  DateTime time,  Color dotColor,  bool isUrgent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgendaEntry() when $default != null:
return $default(_that.id,_that.sourceModule,_that.sourceId,_that.icon,_that.title,_that.time,_that.dotColor,_that.isUrgent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourceModule,  String sourceId,  IconData icon,  String title,  DateTime time,  Color dotColor,  bool isUrgent)  $default,) {final _that = this;
switch (_that) {
case _AgendaEntry():
return $default(_that.id,_that.sourceModule,_that.sourceId,_that.icon,_that.title,_that.time,_that.dotColor,_that.isUrgent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourceModule,  String sourceId,  IconData icon,  String title,  DateTime time,  Color dotColor,  bool isUrgent)?  $default,) {final _that = this;
switch (_that) {
case _AgendaEntry() when $default != null:
return $default(_that.id,_that.sourceModule,_that.sourceId,_that.icon,_that.title,_that.time,_that.dotColor,_that.isUrgent);case _:
  return null;

}
}

}

/// @nodoc


class _AgendaEntry implements AgendaEntry {
  const _AgendaEntry({required this.id, required this.sourceModule, required this.sourceId, required this.icon, required this.title, required this.time, required this.dotColor, required this.isUrgent});
  

@override final  String id;
@override final  String sourceModule;
@override final  String sourceId;
@override final  IconData icon;
@override final  String title;
@override final  DateTime time;
@override final  Color dotColor;
@override final  bool isUrgent;

/// Create a copy of AgendaEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgendaEntryCopyWith<_AgendaEntry> get copyWith => __$AgendaEntryCopyWithImpl<_AgendaEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgendaEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceModule, sourceModule) || other.sourceModule == sourceModule)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.time, time) || other.time == time)&&(identical(other.dotColor, dotColor) || other.dotColor == dotColor)&&(identical(other.isUrgent, isUrgent) || other.isUrgent == isUrgent));
}


@override
int get hashCode => Object.hash(runtimeType,id,sourceModule,sourceId,icon,title,time,dotColor,isUrgent);

@override
String toString() {
  return 'AgendaEntry(id: $id, sourceModule: $sourceModule, sourceId: $sourceId, icon: $icon, title: $title, time: $time, dotColor: $dotColor, isUrgent: $isUrgent)';
}


}

/// @nodoc
abstract mixin class _$AgendaEntryCopyWith<$Res> implements $AgendaEntryCopyWith<$Res> {
  factory _$AgendaEntryCopyWith(_AgendaEntry value, $Res Function(_AgendaEntry) _then) = __$AgendaEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceModule, String sourceId, IconData icon, String title, DateTime time, Color dotColor, bool isUrgent
});




}
/// @nodoc
class __$AgendaEntryCopyWithImpl<$Res>
    implements _$AgendaEntryCopyWith<$Res> {
  __$AgendaEntryCopyWithImpl(this._self, this._then);

  final _AgendaEntry _self;
  final $Res Function(_AgendaEntry) _then;

/// Create a copy of AgendaEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceModule = null,Object? sourceId = null,Object? icon = null,Object? title = null,Object? time = null,Object? dotColor = null,Object? isUrgent = null,}) {
  return _then(_AgendaEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceModule: null == sourceModule ? _self.sourceModule : sourceModule // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,dotColor: null == dotColor ? _self.dotColor : dotColor // ignore: cast_nullable_to_non_nullable
as Color,isUrgent: null == isUrgent ? _self.isUrgent : isUrgent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
