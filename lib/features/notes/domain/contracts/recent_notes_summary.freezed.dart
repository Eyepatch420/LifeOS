// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_notes_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecentNoteSummary {

 String get id; String get title; String get preview; String get timestamp; bool get isPinned;
/// Create a copy of RecentNoteSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentNoteSummaryCopyWith<RecentNoteSummary> get copyWith => _$RecentNoteSummaryCopyWithImpl<RecentNoteSummary>(this as RecentNoteSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentNoteSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,preview,timestamp,isPinned);

@override
String toString() {
  return 'RecentNoteSummary(id: $id, title: $title, preview: $preview, timestamp: $timestamp, isPinned: $isPinned)';
}


}

/// @nodoc
abstract mixin class $RecentNoteSummaryCopyWith<$Res>  {
  factory $RecentNoteSummaryCopyWith(RecentNoteSummary value, $Res Function(RecentNoteSummary) _then) = _$RecentNoteSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String title, String preview, String timestamp, bool isPinned
});




}
/// @nodoc
class _$RecentNoteSummaryCopyWithImpl<$Res>
    implements $RecentNoteSummaryCopyWith<$Res> {
  _$RecentNoteSummaryCopyWithImpl(this._self, this._then);

  final RecentNoteSummary _self;
  final $Res Function(RecentNoteSummary) _then;

/// Create a copy of RecentNoteSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? preview = null,Object? timestamp = null,Object? isPinned = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentNoteSummary].
extension RecentNoteSummaryPatterns on RecentNoteSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentNoteSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentNoteSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentNoteSummary value)  $default,){
final _that = this;
switch (_that) {
case _RecentNoteSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentNoteSummary value)?  $default,){
final _that = this;
switch (_that) {
case _RecentNoteSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String preview,  String timestamp,  bool isPinned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentNoteSummary() when $default != null:
return $default(_that.id,_that.title,_that.preview,_that.timestamp,_that.isPinned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String preview,  String timestamp,  bool isPinned)  $default,) {final _that = this;
switch (_that) {
case _RecentNoteSummary():
return $default(_that.id,_that.title,_that.preview,_that.timestamp,_that.isPinned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String preview,  String timestamp,  bool isPinned)?  $default,) {final _that = this;
switch (_that) {
case _RecentNoteSummary() when $default != null:
return $default(_that.id,_that.title,_that.preview,_that.timestamp,_that.isPinned);case _:
  return null;

}
}

}

/// @nodoc


class _RecentNoteSummary implements RecentNoteSummary {
  const _RecentNoteSummary({required this.id, required this.title, required this.preview, required this.timestamp, required this.isPinned});
  

@override final  String id;
@override final  String title;
@override final  String preview;
@override final  String timestamp;
@override final  bool isPinned;

/// Create a copy of RecentNoteSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentNoteSummaryCopyWith<_RecentNoteSummary> get copyWith => __$RecentNoteSummaryCopyWithImpl<_RecentNoteSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentNoteSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,preview,timestamp,isPinned);

@override
String toString() {
  return 'RecentNoteSummary(id: $id, title: $title, preview: $preview, timestamp: $timestamp, isPinned: $isPinned)';
}


}

/// @nodoc
abstract mixin class _$RecentNoteSummaryCopyWith<$Res> implements $RecentNoteSummaryCopyWith<$Res> {
  factory _$RecentNoteSummaryCopyWith(_RecentNoteSummary value, $Res Function(_RecentNoteSummary) _then) = __$RecentNoteSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String preview, String timestamp, bool isPinned
});




}
/// @nodoc
class __$RecentNoteSummaryCopyWithImpl<$Res>
    implements _$RecentNoteSummaryCopyWith<$Res> {
  __$RecentNoteSummaryCopyWithImpl(this._self, this._then);

  final _RecentNoteSummary _self;
  final $Res Function(_RecentNoteSummary) _then;

/// Create a copy of RecentNoteSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? preview = null,Object? timestamp = null,Object? isPinned = null,}) {
  return _then(_RecentNoteSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$RecentNotesSummary {

 List<RecentNoteSummary> get notes;
/// Create a copy of RecentNotesSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentNotesSummaryCopyWith<RecentNotesSummary> get copyWith => _$RecentNotesSummaryCopyWithImpl<RecentNotesSummary>(this as RecentNotesSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentNotesSummary&&const DeepCollectionEquality().equals(other.notes, notes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(notes));

@override
String toString() {
  return 'RecentNotesSummary(notes: $notes)';
}


}

/// @nodoc
abstract mixin class $RecentNotesSummaryCopyWith<$Res>  {
  factory $RecentNotesSummaryCopyWith(RecentNotesSummary value, $Res Function(RecentNotesSummary) _then) = _$RecentNotesSummaryCopyWithImpl;
@useResult
$Res call({
 List<RecentNoteSummary> notes
});




}
/// @nodoc
class _$RecentNotesSummaryCopyWithImpl<$Res>
    implements $RecentNotesSummaryCopyWith<$Res> {
  _$RecentNotesSummaryCopyWithImpl(this._self, this._then);

  final RecentNotesSummary _self;
  final $Res Function(RecentNotesSummary) _then;

/// Create a copy of RecentNotesSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notes = null,}) {
  return _then(_self.copyWith(
notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<RecentNoteSummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentNotesSummary].
extension RecentNotesSummaryPatterns on RecentNotesSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentNotesSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentNotesSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentNotesSummary value)  $default,){
final _that = this;
switch (_that) {
case _RecentNotesSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentNotesSummary value)?  $default,){
final _that = this;
switch (_that) {
case _RecentNotesSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RecentNoteSummary> notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentNotesSummary() when $default != null:
return $default(_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RecentNoteSummary> notes)  $default,) {final _that = this;
switch (_that) {
case _RecentNotesSummary():
return $default(_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RecentNoteSummary> notes)?  $default,) {final _that = this;
switch (_that) {
case _RecentNotesSummary() when $default != null:
return $default(_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _RecentNotesSummary implements RecentNotesSummary {
  const _RecentNotesSummary({required final  List<RecentNoteSummary> notes}): _notes = notes;
  

 final  List<RecentNoteSummary> _notes;
@override List<RecentNoteSummary> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
}


/// Create a copy of RecentNotesSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentNotesSummaryCopyWith<_RecentNotesSummary> get copyWith => __$RecentNotesSummaryCopyWithImpl<_RecentNotesSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentNotesSummary&&const DeepCollectionEquality().equals(other._notes, _notes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_notes));

@override
String toString() {
  return 'RecentNotesSummary(notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$RecentNotesSummaryCopyWith<$Res> implements $RecentNotesSummaryCopyWith<$Res> {
  factory _$RecentNotesSummaryCopyWith(_RecentNotesSummary value, $Res Function(_RecentNotesSummary) _then) = __$RecentNotesSummaryCopyWithImpl;
@override @useResult
$Res call({
 List<RecentNoteSummary> notes
});




}
/// @nodoc
class __$RecentNotesSummaryCopyWithImpl<$Res>
    implements _$RecentNotesSummaryCopyWith<$Res> {
  __$RecentNotesSummaryCopyWithImpl(this._self, this._then);

  final _RecentNotesSummary _self;
  final $Res Function(_RecentNotesSummary) _then;

/// Create a copy of RecentNotesSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notes = null,}) {
  return _then(_RecentNotesSummary(
notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<RecentNoteSummary>,
  ));
}


}

// dart format on
