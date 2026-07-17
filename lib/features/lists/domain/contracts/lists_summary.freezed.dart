// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lists_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListEntrySummary {

 String get id; String get title; String get subtitle; double get progress;
/// Create a copy of ListEntrySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListEntrySummaryCopyWith<ListEntrySummary> get copyWith => _$ListEntrySummaryCopyWithImpl<ListEntrySummary>(this as ListEntrySummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListEntrySummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,progress);

@override
String toString() {
  return 'ListEntrySummary(id: $id, title: $title, subtitle: $subtitle, progress: $progress)';
}


}

/// @nodoc
abstract mixin class $ListEntrySummaryCopyWith<$Res>  {
  factory $ListEntrySummaryCopyWith(ListEntrySummary value, $Res Function(ListEntrySummary) _then) = _$ListEntrySummaryCopyWithImpl;
@useResult
$Res call({
 String id, String title, String subtitle, double progress
});




}
/// @nodoc
class _$ListEntrySummaryCopyWithImpl<$Res>
    implements $ListEntrySummaryCopyWith<$Res> {
  _$ListEntrySummaryCopyWithImpl(this._self, this._then);

  final ListEntrySummary _self;
  final $Res Function(ListEntrySummary) _then;

/// Create a copy of ListEntrySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? progress = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ListEntrySummary].
extension ListEntrySummaryPatterns on ListEntrySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListEntrySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListEntrySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListEntrySummary value)  $default,){
final _that = this;
switch (_that) {
case _ListEntrySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListEntrySummary value)?  $default,){
final _that = this;
switch (_that) {
case _ListEntrySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  double progress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListEntrySummary() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.progress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  double progress)  $default,) {final _that = this;
switch (_that) {
case _ListEntrySummary():
return $default(_that.id,_that.title,_that.subtitle,_that.progress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String subtitle,  double progress)?  $default,) {final _that = this;
switch (_that) {
case _ListEntrySummary() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.progress);case _:
  return null;

}
}

}

/// @nodoc


class _ListEntrySummary implements ListEntrySummary {
  const _ListEntrySummary({required this.id, required this.title, required this.subtitle, required this.progress});
  

@override final  String id;
@override final  String title;
@override final  String subtitle;
@override final  double progress;

/// Create a copy of ListEntrySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListEntrySummaryCopyWith<_ListEntrySummary> get copyWith => __$ListEntrySummaryCopyWithImpl<_ListEntrySummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListEntrySummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,progress);

@override
String toString() {
  return 'ListEntrySummary(id: $id, title: $title, subtitle: $subtitle, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$ListEntrySummaryCopyWith<$Res> implements $ListEntrySummaryCopyWith<$Res> {
  factory _$ListEntrySummaryCopyWith(_ListEntrySummary value, $Res Function(_ListEntrySummary) _then) = __$ListEntrySummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String subtitle, double progress
});




}
/// @nodoc
class __$ListEntrySummaryCopyWithImpl<$Res>
    implements _$ListEntrySummaryCopyWith<$Res> {
  __$ListEntrySummaryCopyWithImpl(this._self, this._then);

  final _ListEntrySummary _self;
  final $Res Function(_ListEntrySummary) _then;

/// Create a copy of ListEntrySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? progress = null,}) {
  return _then(_ListEntrySummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$ListsSummary {

 List<ListEntrySummary> get lists;
/// Create a copy of ListsSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListsSummaryCopyWith<ListsSummary> get copyWith => _$ListsSummaryCopyWithImpl<ListsSummary>(this as ListsSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListsSummary&&const DeepCollectionEquality().equals(other.lists, lists));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(lists));

@override
String toString() {
  return 'ListsSummary(lists: $lists)';
}


}

/// @nodoc
abstract mixin class $ListsSummaryCopyWith<$Res>  {
  factory $ListsSummaryCopyWith(ListsSummary value, $Res Function(ListsSummary) _then) = _$ListsSummaryCopyWithImpl;
@useResult
$Res call({
 List<ListEntrySummary> lists
});




}
/// @nodoc
class _$ListsSummaryCopyWithImpl<$Res>
    implements $ListsSummaryCopyWith<$Res> {
  _$ListsSummaryCopyWithImpl(this._self, this._then);

  final ListsSummary _self;
  final $Res Function(ListsSummary) _then;

/// Create a copy of ListsSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lists = null,}) {
  return _then(_self.copyWith(
lists: null == lists ? _self.lists : lists // ignore: cast_nullable_to_non_nullable
as List<ListEntrySummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [ListsSummary].
extension ListsSummaryPatterns on ListsSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListsSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListsSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListsSummary value)  $default,){
final _that = this;
switch (_that) {
case _ListsSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListsSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ListsSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ListEntrySummary> lists)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListsSummary() when $default != null:
return $default(_that.lists);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ListEntrySummary> lists)  $default,) {final _that = this;
switch (_that) {
case _ListsSummary():
return $default(_that.lists);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ListEntrySummary> lists)?  $default,) {final _that = this;
switch (_that) {
case _ListsSummary() when $default != null:
return $default(_that.lists);case _:
  return null;

}
}

}

/// @nodoc


class _ListsSummary implements ListsSummary {
  const _ListsSummary({required final  List<ListEntrySummary> lists}): _lists = lists;
  

 final  List<ListEntrySummary> _lists;
@override List<ListEntrySummary> get lists {
  if (_lists is EqualUnmodifiableListView) return _lists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lists);
}


/// Create a copy of ListsSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListsSummaryCopyWith<_ListsSummary> get copyWith => __$ListsSummaryCopyWithImpl<_ListsSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListsSummary&&const DeepCollectionEquality().equals(other._lists, _lists));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_lists));

@override
String toString() {
  return 'ListsSummary(lists: $lists)';
}


}

/// @nodoc
abstract mixin class _$ListsSummaryCopyWith<$Res> implements $ListsSummaryCopyWith<$Res> {
  factory _$ListsSummaryCopyWith(_ListsSummary value, $Res Function(_ListsSummary) _then) = __$ListsSummaryCopyWithImpl;
@override @useResult
$Res call({
 List<ListEntrySummary> lists
});




}
/// @nodoc
class __$ListsSummaryCopyWithImpl<$Res>
    implements _$ListsSummaryCopyWith<$Res> {
  __$ListsSummaryCopyWithImpl(this._self, this._then);

  final _ListsSummary _self;
  final $Res Function(_ListsSummary) _then;

/// Create a copy of ListsSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lists = null,}) {
  return _then(_ListsSummary(
lists: null == lists ? _self._lists : lists // ignore: cast_nullable_to_non_nullable
as List<ListEntrySummary>,
  ));
}


}

// dart format on
