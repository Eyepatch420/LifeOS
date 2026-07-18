// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_card_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OverviewStat {

 IconData get icon; String get label; String get value; String get subtitle; double get progress;
/// Create a copy of OverviewStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverviewStatCopyWith<OverviewStat> get copyWith => _$OverviewStatCopyWithImpl<OverviewStat>(this as OverviewStat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverviewStat&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,icon,label,value,subtitle,progress);

@override
String toString() {
  return 'OverviewStat(icon: $icon, label: $label, value: $value, subtitle: $subtitle, progress: $progress)';
}


}

/// @nodoc
abstract mixin class $OverviewStatCopyWith<$Res>  {
  factory $OverviewStatCopyWith(OverviewStat value, $Res Function(OverviewStat) _then) = _$OverviewStatCopyWithImpl;
@useResult
$Res call({
 IconData icon, String label, String value, String subtitle, double progress
});




}
/// @nodoc
class _$OverviewStatCopyWithImpl<$Res>
    implements $OverviewStatCopyWith<$Res> {
  _$OverviewStatCopyWithImpl(this._self, this._then);

  final OverviewStat _self;
  final $Res Function(OverviewStat) _then;

/// Create a copy of OverviewStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? icon = null,Object? label = null,Object? value = null,Object? subtitle = null,Object? progress = null,}) {
  return _then(_self.copyWith(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OverviewStat].
extension OverviewStatPatterns on OverviewStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OverviewStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OverviewStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OverviewStat value)  $default,){
final _that = this;
switch (_that) {
case _OverviewStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OverviewStat value)?  $default,){
final _that = this;
switch (_that) {
case _OverviewStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( IconData icon,  String label,  String value,  String subtitle,  double progress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OverviewStat() when $default != null:
return $default(_that.icon,_that.label,_that.value,_that.subtitle,_that.progress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( IconData icon,  String label,  String value,  String subtitle,  double progress)  $default,) {final _that = this;
switch (_that) {
case _OverviewStat():
return $default(_that.icon,_that.label,_that.value,_that.subtitle,_that.progress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( IconData icon,  String label,  String value,  String subtitle,  double progress)?  $default,) {final _that = this;
switch (_that) {
case _OverviewStat() when $default != null:
return $default(_that.icon,_that.label,_that.value,_that.subtitle,_that.progress);case _:
  return null;

}
}

}

/// @nodoc


class _OverviewStat implements OverviewStat {
  const _OverviewStat({required this.icon, required this.label, required this.value, required this.subtitle, required this.progress});
  

@override final  IconData icon;
@override final  String label;
@override final  String value;
@override final  String subtitle;
@override final  double progress;

/// Create a copy of OverviewStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverviewStatCopyWith<_OverviewStat> get copyWith => __$OverviewStatCopyWithImpl<_OverviewStat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverviewStat&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,icon,label,value,subtitle,progress);

@override
String toString() {
  return 'OverviewStat(icon: $icon, label: $label, value: $value, subtitle: $subtitle, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$OverviewStatCopyWith<$Res> implements $OverviewStatCopyWith<$Res> {
  factory _$OverviewStatCopyWith(_OverviewStat value, $Res Function(_OverviewStat) _then) = __$OverviewStatCopyWithImpl;
@override @useResult
$Res call({
 IconData icon, String label, String value, String subtitle, double progress
});




}
/// @nodoc
class __$OverviewStatCopyWithImpl<$Res>
    implements _$OverviewStatCopyWith<$Res> {
  __$OverviewStatCopyWithImpl(this._self, this._then);

  final _OverviewStat _self;
  final $Res Function(_OverviewStat) _then;

/// Create a copy of OverviewStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = null,Object? label = null,Object? value = null,Object? subtitle = null,Object? progress = null,}) {
  return _then(_OverviewStat(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$QuickAction {

 String get id; IconData get icon; String get label;
/// Create a copy of QuickAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickActionCopyWith<QuickAction> get copyWith => _$QuickActionCopyWithImpl<QuickAction>(this as QuickAction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAction&&(identical(other.id, id) || other.id == id)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,id,icon,label);

@override
String toString() {
  return 'QuickAction(id: $id, icon: $icon, label: $label)';
}


}

/// @nodoc
abstract mixin class $QuickActionCopyWith<$Res>  {
  factory $QuickActionCopyWith(QuickAction value, $Res Function(QuickAction) _then) = _$QuickActionCopyWithImpl;
@useResult
$Res call({
 String id, IconData icon, String label
});




}
/// @nodoc
class _$QuickActionCopyWithImpl<$Res>
    implements $QuickActionCopyWith<$Res> {
  _$QuickActionCopyWithImpl(this._self, this._then);

  final QuickAction _self;
  final $Res Function(QuickAction) _then;

/// Create a copy of QuickAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? icon = null,Object? label = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickAction].
extension QuickActionPatterns on QuickAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickAction value)  $default,){
final _that = this;
switch (_that) {
case _QuickAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickAction value)?  $default,){
final _that = this;
switch (_that) {
case _QuickAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  IconData icon,  String label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickAction() when $default != null:
return $default(_that.id,_that.icon,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  IconData icon,  String label)  $default,) {final _that = this;
switch (_that) {
case _QuickAction():
return $default(_that.id,_that.icon,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  IconData icon,  String label)?  $default,) {final _that = this;
switch (_that) {
case _QuickAction() when $default != null:
return $default(_that.id,_that.icon,_that.label);case _:
  return null;

}
}

}

/// @nodoc


class _QuickAction implements QuickAction {
  const _QuickAction({required this.id, required this.icon, required this.label});
  

@override final  String id;
@override final  IconData icon;
@override final  String label;

/// Create a copy of QuickAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickActionCopyWith<_QuickAction> get copyWith => __$QuickActionCopyWithImpl<_QuickAction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickAction&&(identical(other.id, id) || other.id == id)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,id,icon,label);

@override
String toString() {
  return 'QuickAction(id: $id, icon: $icon, label: $label)';
}


}

/// @nodoc
abstract mixin class _$QuickActionCopyWith<$Res> implements $QuickActionCopyWith<$Res> {
  factory _$QuickActionCopyWith(_QuickAction value, $Res Function(_QuickAction) _then) = __$QuickActionCopyWithImpl;
@override @useResult
$Res call({
 String id, IconData icon, String label
});




}
/// @nodoc
class __$QuickActionCopyWithImpl<$Res>
    implements _$QuickActionCopyWith<$Res> {
  __$QuickActionCopyWithImpl(this._self, this._then);

  final _QuickAction _self;
  final $Res Function(_QuickAction) _then;

/// Create a copy of QuickAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? icon = null,Object? label = null,}) {
  return _then(_QuickAction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$UpNextItem {

 String get id; IconData get icon; String get title; String get subtitle; bool get isUrgent;
/// Create a copy of UpNextItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpNextItemCopyWith<UpNextItem> get copyWith => _$UpNextItemCopyWithImpl<UpNextItem>(this as UpNextItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpNextItem&&(identical(other.id, id) || other.id == id)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.isUrgent, isUrgent) || other.isUrgent == isUrgent));
}


@override
int get hashCode => Object.hash(runtimeType,id,icon,title,subtitle,isUrgent);

@override
String toString() {
  return 'UpNextItem(id: $id, icon: $icon, title: $title, subtitle: $subtitle, isUrgent: $isUrgent)';
}


}

/// @nodoc
abstract mixin class $UpNextItemCopyWith<$Res>  {
  factory $UpNextItemCopyWith(UpNextItem value, $Res Function(UpNextItem) _then) = _$UpNextItemCopyWithImpl;
@useResult
$Res call({
 String id, IconData icon, String title, String subtitle, bool isUrgent
});




}
/// @nodoc
class _$UpNextItemCopyWithImpl<$Res>
    implements $UpNextItemCopyWith<$Res> {
  _$UpNextItemCopyWithImpl(this._self, this._then);

  final UpNextItem _self;
  final $Res Function(UpNextItem) _then;

/// Create a copy of UpNextItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? icon = null,Object? title = null,Object? subtitle = null,Object? isUrgent = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,isUrgent: null == isUrgent ? _self.isUrgent : isUrgent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UpNextItem].
extension UpNextItemPatterns on UpNextItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpNextItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpNextItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpNextItem value)  $default,){
final _that = this;
switch (_that) {
case _UpNextItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpNextItem value)?  $default,){
final _that = this;
switch (_that) {
case _UpNextItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  IconData icon,  String title,  String subtitle,  bool isUrgent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpNextItem() when $default != null:
return $default(_that.id,_that.icon,_that.title,_that.subtitle,_that.isUrgent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  IconData icon,  String title,  String subtitle,  bool isUrgent)  $default,) {final _that = this;
switch (_that) {
case _UpNextItem():
return $default(_that.id,_that.icon,_that.title,_that.subtitle,_that.isUrgent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  IconData icon,  String title,  String subtitle,  bool isUrgent)?  $default,) {final _that = this;
switch (_that) {
case _UpNextItem() when $default != null:
return $default(_that.id,_that.icon,_that.title,_that.subtitle,_that.isUrgent);case _:
  return null;

}
}

}

/// @nodoc


class _UpNextItem implements UpNextItem {
  const _UpNextItem({required this.id, required this.icon, required this.title, required this.subtitle, required this.isUrgent});
  

@override final  String id;
@override final  IconData icon;
@override final  String title;
@override final  String subtitle;
@override final  bool isUrgent;

/// Create a copy of UpNextItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpNextItemCopyWith<_UpNextItem> get copyWith => __$UpNextItemCopyWithImpl<_UpNextItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpNextItem&&(identical(other.id, id) || other.id == id)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.isUrgent, isUrgent) || other.isUrgent == isUrgent));
}


@override
int get hashCode => Object.hash(runtimeType,id,icon,title,subtitle,isUrgent);

@override
String toString() {
  return 'UpNextItem(id: $id, icon: $icon, title: $title, subtitle: $subtitle, isUrgent: $isUrgent)';
}


}

/// @nodoc
abstract mixin class _$UpNextItemCopyWith<$Res> implements $UpNextItemCopyWith<$Res> {
  factory _$UpNextItemCopyWith(_UpNextItem value, $Res Function(_UpNextItem) _then) = __$UpNextItemCopyWithImpl;
@override @useResult
$Res call({
 String id, IconData icon, String title, String subtitle, bool isUrgent
});




}
/// @nodoc
class __$UpNextItemCopyWithImpl<$Res>
    implements _$UpNextItemCopyWith<$Res> {
  __$UpNextItemCopyWithImpl(this._self, this._then);

  final _UpNextItem _self;
  final $Res Function(_UpNextItem) _then;

/// Create a copy of UpNextItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? icon = null,Object? title = null,Object? subtitle = null,Object? isUrgent = null,}) {
  return _then(_UpNextItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,isUrgent: null == isUrgent ? _self.isUrgent : isUrgent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$HabitStreak {

 IconData get icon; String get title; int get streakDays; List<bool> get last7Days; String? get id;
/// Create a copy of HabitStreak
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitStreakCopyWith<HabitStreak> get copyWith => _$HabitStreakCopyWithImpl<HabitStreak>(this as HabitStreak, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitStreak&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&const DeepCollectionEquality().equals(other.last7Days, last7Days)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,icon,title,streakDays,const DeepCollectionEquality().hash(last7Days),id);

@override
String toString() {
  return 'HabitStreak(icon: $icon, title: $title, streakDays: $streakDays, last7Days: $last7Days, id: $id)';
}


}

/// @nodoc
abstract mixin class $HabitStreakCopyWith<$Res>  {
  factory $HabitStreakCopyWith(HabitStreak value, $Res Function(HabitStreak) _then) = _$HabitStreakCopyWithImpl;
@useResult
$Res call({
 IconData icon, String title, int streakDays, List<bool> last7Days, String? id
});




}
/// @nodoc
class _$HabitStreakCopyWithImpl<$Res>
    implements $HabitStreakCopyWith<$Res> {
  _$HabitStreakCopyWithImpl(this._self, this._then);

  final HabitStreak _self;
  final $Res Function(HabitStreak) _then;

/// Create a copy of HabitStreak
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? icon = null,Object? title = null,Object? streakDays = null,Object? last7Days = null,Object? id = freezed,}) {
  return _then(_self.copyWith(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,last7Days: null == last7Days ? _self.last7Days : last7Days // ignore: cast_nullable_to_non_nullable
as List<bool>,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitStreak].
extension HabitStreakPatterns on HabitStreak {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitStreak value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitStreak() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitStreak value)  $default,){
final _that = this;
switch (_that) {
case _HabitStreak():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitStreak value)?  $default,){
final _that = this;
switch (_that) {
case _HabitStreak() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( IconData icon,  String title,  int streakDays,  List<bool> last7Days,  String? id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitStreak() when $default != null:
return $default(_that.icon,_that.title,_that.streakDays,_that.last7Days,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( IconData icon,  String title,  int streakDays,  List<bool> last7Days,  String? id)  $default,) {final _that = this;
switch (_that) {
case _HabitStreak():
return $default(_that.icon,_that.title,_that.streakDays,_that.last7Days,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( IconData icon,  String title,  int streakDays,  List<bool> last7Days,  String? id)?  $default,) {final _that = this;
switch (_that) {
case _HabitStreak() when $default != null:
return $default(_that.icon,_that.title,_that.streakDays,_that.last7Days,_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _HabitStreak implements HabitStreak {
  const _HabitStreak({required this.icon, required this.title, required this.streakDays, required final  List<bool> last7Days, this.id}): _last7Days = last7Days;
  

@override final  IconData icon;
@override final  String title;
@override final  int streakDays;
 final  List<bool> _last7Days;
@override List<bool> get last7Days {
  if (_last7Days is EqualUnmodifiableListView) return _last7Days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_last7Days);
}

@override final  String? id;

/// Create a copy of HabitStreak
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitStreakCopyWith<_HabitStreak> get copyWith => __$HabitStreakCopyWithImpl<_HabitStreak>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitStreak&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&const DeepCollectionEquality().equals(other._last7Days, _last7Days)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,icon,title,streakDays,const DeepCollectionEquality().hash(_last7Days),id);

@override
String toString() {
  return 'HabitStreak(icon: $icon, title: $title, streakDays: $streakDays, last7Days: $last7Days, id: $id)';
}


}

/// @nodoc
abstract mixin class _$HabitStreakCopyWith<$Res> implements $HabitStreakCopyWith<$Res> {
  factory _$HabitStreakCopyWith(_HabitStreak value, $Res Function(_HabitStreak) _then) = __$HabitStreakCopyWithImpl;
@override @useResult
$Res call({
 IconData icon, String title, int streakDays, List<bool> last7Days, String? id
});




}
/// @nodoc
class __$HabitStreakCopyWithImpl<$Res>
    implements _$HabitStreakCopyWith<$Res> {
  __$HabitStreakCopyWithImpl(this._self, this._then);

  final _HabitStreak _self;
  final $Res Function(_HabitStreak) _then;

/// Create a copy of HabitStreak
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = null,Object? title = null,Object? streakDays = null,Object? last7Days = null,Object? id = freezed,}) {
  return _then(_HabitStreak(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,last7Days: null == last7Days ? _self._last7Days : last7Days // ignore: cast_nullable_to_non_nullable
as List<bool>,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$TimelineStep {

 String get id; IconData get icon; String get label; String get time; Color get dotColor;
/// Create a copy of TimelineStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineStepCopyWith<TimelineStep> get copyWith => _$TimelineStepCopyWithImpl<TimelineStep>(this as TimelineStep, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineStep&&(identical(other.id, id) || other.id == id)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.label, label) || other.label == label)&&(identical(other.time, time) || other.time == time)&&(identical(other.dotColor, dotColor) || other.dotColor == dotColor));
}


@override
int get hashCode => Object.hash(runtimeType,id,icon,label,time,dotColor);

@override
String toString() {
  return 'TimelineStep(id: $id, icon: $icon, label: $label, time: $time, dotColor: $dotColor)';
}


}

/// @nodoc
abstract mixin class $TimelineStepCopyWith<$Res>  {
  factory $TimelineStepCopyWith(TimelineStep value, $Res Function(TimelineStep) _then) = _$TimelineStepCopyWithImpl;
@useResult
$Res call({
 String id, IconData icon, String label, String time, Color dotColor
});




}
/// @nodoc
class _$TimelineStepCopyWithImpl<$Res>
    implements $TimelineStepCopyWith<$Res> {
  _$TimelineStepCopyWithImpl(this._self, this._then);

  final TimelineStep _self;
  final $Res Function(TimelineStep) _then;

/// Create a copy of TimelineStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? icon = null,Object? label = null,Object? time = null,Object? dotColor = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,dotColor: null == dotColor ? _self.dotColor : dotColor // ignore: cast_nullable_to_non_nullable
as Color,
  ));
}

}


/// Adds pattern-matching-related methods to [TimelineStep].
extension TimelineStepPatterns on TimelineStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimelineStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimelineStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimelineStep value)  $default,){
final _that = this;
switch (_that) {
case _TimelineStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimelineStep value)?  $default,){
final _that = this;
switch (_that) {
case _TimelineStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  IconData icon,  String label,  String time,  Color dotColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimelineStep() when $default != null:
return $default(_that.id,_that.icon,_that.label,_that.time,_that.dotColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  IconData icon,  String label,  String time,  Color dotColor)  $default,) {final _that = this;
switch (_that) {
case _TimelineStep():
return $default(_that.id,_that.icon,_that.label,_that.time,_that.dotColor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  IconData icon,  String label,  String time,  Color dotColor)?  $default,) {final _that = this;
switch (_that) {
case _TimelineStep() when $default != null:
return $default(_that.id,_that.icon,_that.label,_that.time,_that.dotColor);case _:
  return null;

}
}

}

/// @nodoc


class _TimelineStep implements TimelineStep {
  const _TimelineStep({required this.id, required this.icon, required this.label, required this.time, required this.dotColor});
  

@override final  String id;
@override final  IconData icon;
@override final  String label;
@override final  String time;
@override final  Color dotColor;

/// Create a copy of TimelineStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimelineStepCopyWith<_TimelineStep> get copyWith => __$TimelineStepCopyWithImpl<_TimelineStep>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimelineStep&&(identical(other.id, id) || other.id == id)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.label, label) || other.label == label)&&(identical(other.time, time) || other.time == time)&&(identical(other.dotColor, dotColor) || other.dotColor == dotColor));
}


@override
int get hashCode => Object.hash(runtimeType,id,icon,label,time,dotColor);

@override
String toString() {
  return 'TimelineStep(id: $id, icon: $icon, label: $label, time: $time, dotColor: $dotColor)';
}


}

/// @nodoc
abstract mixin class _$TimelineStepCopyWith<$Res> implements $TimelineStepCopyWith<$Res> {
  factory _$TimelineStepCopyWith(_TimelineStep value, $Res Function(_TimelineStep) _then) = __$TimelineStepCopyWithImpl;
@override @useResult
$Res call({
 String id, IconData icon, String label, String time, Color dotColor
});




}
/// @nodoc
class __$TimelineStepCopyWithImpl<$Res>
    implements _$TimelineStepCopyWith<$Res> {
  __$TimelineStepCopyWithImpl(this._self, this._then);

  final _TimelineStep _self;
  final $Res Function(_TimelineStep) _then;

/// Create a copy of TimelineStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? icon = null,Object? label = null,Object? time = null,Object? dotColor = null,}) {
  return _then(_TimelineStep(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,dotColor: null == dotColor ? _self.dotColor : dotColor // ignore: cast_nullable_to_non_nullable
as Color,
  ));
}


}

/// @nodoc
mixin _$NoteSummary {

 IconData get icon; String get title; String get preview; String get timestamp; bool get isPinned; String? get id;
/// Create a copy of NoteSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteSummaryCopyWith<NoteSummary> get copyWith => _$NoteSummaryCopyWithImpl<NoteSummary>(this as NoteSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteSummary&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,icon,title,preview,timestamp,isPinned,id);

@override
String toString() {
  return 'NoteSummary(icon: $icon, title: $title, preview: $preview, timestamp: $timestamp, isPinned: $isPinned, id: $id)';
}


}

/// @nodoc
abstract mixin class $NoteSummaryCopyWith<$Res>  {
  factory $NoteSummaryCopyWith(NoteSummary value, $Res Function(NoteSummary) _then) = _$NoteSummaryCopyWithImpl;
@useResult
$Res call({
 IconData icon, String title, String preview, String timestamp, bool isPinned, String? id
});




}
/// @nodoc
class _$NoteSummaryCopyWithImpl<$Res>
    implements $NoteSummaryCopyWith<$Res> {
  _$NoteSummaryCopyWithImpl(this._self, this._then);

  final NoteSummary _self;
  final $Res Function(NoteSummary) _then;

/// Create a copy of NoteSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? icon = null,Object? title = null,Object? preview = null,Object? timestamp = null,Object? isPinned = null,Object? id = freezed,}) {
  return _then(_self.copyWith(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NoteSummary].
extension NoteSummaryPatterns on NoteSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteSummary value)  $default,){
final _that = this;
switch (_that) {
case _NoteSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteSummary value)?  $default,){
final _that = this;
switch (_that) {
case _NoteSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( IconData icon,  String title,  String preview,  String timestamp,  bool isPinned,  String? id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteSummary() when $default != null:
return $default(_that.icon,_that.title,_that.preview,_that.timestamp,_that.isPinned,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( IconData icon,  String title,  String preview,  String timestamp,  bool isPinned,  String? id)  $default,) {final _that = this;
switch (_that) {
case _NoteSummary():
return $default(_that.icon,_that.title,_that.preview,_that.timestamp,_that.isPinned,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( IconData icon,  String title,  String preview,  String timestamp,  bool isPinned,  String? id)?  $default,) {final _that = this;
switch (_that) {
case _NoteSummary() when $default != null:
return $default(_that.icon,_that.title,_that.preview,_that.timestamp,_that.isPinned,_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _NoteSummary implements NoteSummary {
  const _NoteSummary({required this.icon, required this.title, required this.preview, required this.timestamp, required this.isPinned, this.id});
  

@override final  IconData icon;
@override final  String title;
@override final  String preview;
@override final  String timestamp;
@override final  bool isPinned;
@override final  String? id;

/// Create a copy of NoteSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteSummaryCopyWith<_NoteSummary> get copyWith => __$NoteSummaryCopyWithImpl<_NoteSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteSummary&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,icon,title,preview,timestamp,isPinned,id);

@override
String toString() {
  return 'NoteSummary(icon: $icon, title: $title, preview: $preview, timestamp: $timestamp, isPinned: $isPinned, id: $id)';
}


}

/// @nodoc
abstract mixin class _$NoteSummaryCopyWith<$Res> implements $NoteSummaryCopyWith<$Res> {
  factory _$NoteSummaryCopyWith(_NoteSummary value, $Res Function(_NoteSummary) _then) = __$NoteSummaryCopyWithImpl;
@override @useResult
$Res call({
 IconData icon, String title, String preview, String timestamp, bool isPinned, String? id
});




}
/// @nodoc
class __$NoteSummaryCopyWithImpl<$Res>
    implements _$NoteSummaryCopyWith<$Res> {
  __$NoteSummaryCopyWithImpl(this._self, this._then);

  final _NoteSummary _self;
  final $Res Function(_NoteSummary) _then;

/// Create a copy of NoteSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = null,Object? title = null,Object? preview = null,Object? timestamp = null,Object? isPinned = null,Object? id = freezed,}) {
  return _then(_NoteSummary(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ListSummary {

 IconData get icon; String get title; String get subtitle; double get progress; String? get id;
/// Create a copy of ListSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListSummaryCopyWith<ListSummary> get copyWith => _$ListSummaryCopyWithImpl<ListSummary>(this as ListSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListSummary&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,icon,title,subtitle,progress,id);

@override
String toString() {
  return 'ListSummary(icon: $icon, title: $title, subtitle: $subtitle, progress: $progress, id: $id)';
}


}

/// @nodoc
abstract mixin class $ListSummaryCopyWith<$Res>  {
  factory $ListSummaryCopyWith(ListSummary value, $Res Function(ListSummary) _then) = _$ListSummaryCopyWithImpl;
@useResult
$Res call({
 IconData icon, String title, String subtitle, double progress, String? id
});




}
/// @nodoc
class _$ListSummaryCopyWithImpl<$Res>
    implements $ListSummaryCopyWith<$Res> {
  _$ListSummaryCopyWithImpl(this._self, this._then);

  final ListSummary _self;
  final $Res Function(ListSummary) _then;

/// Create a copy of ListSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? icon = null,Object? title = null,Object? subtitle = null,Object? progress = null,Object? id = freezed,}) {
  return _then(_self.copyWith(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ListSummary].
extension ListSummaryPatterns on ListSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListSummary value)  $default,){
final _that = this;
switch (_that) {
case _ListSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ListSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( IconData icon,  String title,  String subtitle,  double progress,  String? id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListSummary() when $default != null:
return $default(_that.icon,_that.title,_that.subtitle,_that.progress,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( IconData icon,  String title,  String subtitle,  double progress,  String? id)  $default,) {final _that = this;
switch (_that) {
case _ListSummary():
return $default(_that.icon,_that.title,_that.subtitle,_that.progress,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( IconData icon,  String title,  String subtitle,  double progress,  String? id)?  $default,) {final _that = this;
switch (_that) {
case _ListSummary() when $default != null:
return $default(_that.icon,_that.title,_that.subtitle,_that.progress,_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _ListSummary implements ListSummary {
  const _ListSummary({required this.icon, required this.title, required this.subtitle, required this.progress, this.id});
  

@override final  IconData icon;
@override final  String title;
@override final  String subtitle;
@override final  double progress;
@override final  String? id;

/// Create a copy of ListSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListSummaryCopyWith<_ListSummary> get copyWith => __$ListSummaryCopyWithImpl<_ListSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListSummary&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,icon,title,subtitle,progress,id);

@override
String toString() {
  return 'ListSummary(icon: $icon, title: $title, subtitle: $subtitle, progress: $progress, id: $id)';
}


}

/// @nodoc
abstract mixin class _$ListSummaryCopyWith<$Res> implements $ListSummaryCopyWith<$Res> {
  factory _$ListSummaryCopyWith(_ListSummary value, $Res Function(_ListSummary) _then) = __$ListSummaryCopyWithImpl;
@override @useResult
$Res call({
 IconData icon, String title, String subtitle, double progress, String? id
});




}
/// @nodoc
class __$ListSummaryCopyWithImpl<$Res>
    implements _$ListSummaryCopyWith<$Res> {
  __$ListSummaryCopyWithImpl(this._self, this._then);

  final _ListSummary _self;
  final $Res Function(_ListSummary) _then;

/// Create a copy of ListSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = null,Object? title = null,Object? subtitle = null,Object? progress = null,Object? id = freezed,}) {
  return _then(_ListSummary(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
