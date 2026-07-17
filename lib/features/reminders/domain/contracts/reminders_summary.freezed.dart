// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminders_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReminderEntrySummary {

 String get id; String get title; DateTime get dueAt; bool get isUrgent; bool get isCompleted;
/// Create a copy of ReminderEntrySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderEntrySummaryCopyWith<ReminderEntrySummary> get copyWith => _$ReminderEntrySummaryCopyWithImpl<ReminderEntrySummary>(this as ReminderEntrySummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderEntrySummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.isUrgent, isUrgent) || other.isUrgent == isUrgent)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,dueAt,isUrgent,isCompleted);

@override
String toString() {
  return 'ReminderEntrySummary(id: $id, title: $title, dueAt: $dueAt, isUrgent: $isUrgent, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $ReminderEntrySummaryCopyWith<$Res>  {
  factory $ReminderEntrySummaryCopyWith(ReminderEntrySummary value, $Res Function(ReminderEntrySummary) _then) = _$ReminderEntrySummaryCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime dueAt, bool isUrgent, bool isCompleted
});




}
/// @nodoc
class _$ReminderEntrySummaryCopyWithImpl<$Res>
    implements $ReminderEntrySummaryCopyWith<$Res> {
  _$ReminderEntrySummaryCopyWithImpl(this._self, this._then);

  final ReminderEntrySummary _self;
  final $Res Function(ReminderEntrySummary) _then;

/// Create a copy of ReminderEntrySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? dueAt = null,Object? isUrgent = null,Object? isCompleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,isUrgent: null == isUrgent ? _self.isUrgent : isUrgent // ignore: cast_nullable_to_non_nullable
as bool,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderEntrySummary].
extension ReminderEntrySummaryPatterns on ReminderEntrySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderEntrySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderEntrySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderEntrySummary value)  $default,){
final _that = this;
switch (_that) {
case _ReminderEntrySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderEntrySummary value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderEntrySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime dueAt,  bool isUrgent,  bool isCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderEntrySummary() when $default != null:
return $default(_that.id,_that.title,_that.dueAt,_that.isUrgent,_that.isCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime dueAt,  bool isUrgent,  bool isCompleted)  $default,) {final _that = this;
switch (_that) {
case _ReminderEntrySummary():
return $default(_that.id,_that.title,_that.dueAt,_that.isUrgent,_that.isCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime dueAt,  bool isUrgent,  bool isCompleted)?  $default,) {final _that = this;
switch (_that) {
case _ReminderEntrySummary() when $default != null:
return $default(_that.id,_that.title,_that.dueAt,_that.isUrgent,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc


class _ReminderEntrySummary implements ReminderEntrySummary {
  const _ReminderEntrySummary({required this.id, required this.title, required this.dueAt, required this.isUrgent, required this.isCompleted});
  

@override final  String id;
@override final  String title;
@override final  DateTime dueAt;
@override final  bool isUrgent;
@override final  bool isCompleted;

/// Create a copy of ReminderEntrySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderEntrySummaryCopyWith<_ReminderEntrySummary> get copyWith => __$ReminderEntrySummaryCopyWithImpl<_ReminderEntrySummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderEntrySummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.isUrgent, isUrgent) || other.isUrgent == isUrgent)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,dueAt,isUrgent,isCompleted);

@override
String toString() {
  return 'ReminderEntrySummary(id: $id, title: $title, dueAt: $dueAt, isUrgent: $isUrgent, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$ReminderEntrySummaryCopyWith<$Res> implements $ReminderEntrySummaryCopyWith<$Res> {
  factory _$ReminderEntrySummaryCopyWith(_ReminderEntrySummary value, $Res Function(_ReminderEntrySummary) _then) = __$ReminderEntrySummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime dueAt, bool isUrgent, bool isCompleted
});




}
/// @nodoc
class __$ReminderEntrySummaryCopyWithImpl<$Res>
    implements _$ReminderEntrySummaryCopyWith<$Res> {
  __$ReminderEntrySummaryCopyWithImpl(this._self, this._then);

  final _ReminderEntrySummary _self;
  final $Res Function(_ReminderEntrySummary) _then;

/// Create a copy of ReminderEntrySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? dueAt = null,Object? isUrgent = null,Object? isCompleted = null,}) {
  return _then(_ReminderEntrySummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,isUrgent: null == isUrgent ? _self.isUrgent : isUrgent // ignore: cast_nullable_to_non_nullable
as bool,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$RemindersSummary {

 List<ReminderEntrySummary> get items; int get pendingCount; int get completedTodayCount;
/// Create a copy of RemindersSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemindersSummaryCopyWith<RemindersSummary> get copyWith => _$RemindersSummaryCopyWithImpl<RemindersSummary>(this as RemindersSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemindersSummary&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount)&&(identical(other.completedTodayCount, completedTodayCount) || other.completedTodayCount == completedTodayCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),pendingCount,completedTodayCount);

@override
String toString() {
  return 'RemindersSummary(items: $items, pendingCount: $pendingCount, completedTodayCount: $completedTodayCount)';
}


}

/// @nodoc
abstract mixin class $RemindersSummaryCopyWith<$Res>  {
  factory $RemindersSummaryCopyWith(RemindersSummary value, $Res Function(RemindersSummary) _then) = _$RemindersSummaryCopyWithImpl;
@useResult
$Res call({
 List<ReminderEntrySummary> items, int pendingCount, int completedTodayCount
});




}
/// @nodoc
class _$RemindersSummaryCopyWithImpl<$Res>
    implements $RemindersSummaryCopyWith<$Res> {
  _$RemindersSummaryCopyWithImpl(this._self, this._then);

  final RemindersSummary _self;
  final $Res Function(RemindersSummary) _then;

/// Create a copy of RemindersSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? pendingCount = null,Object? completedTodayCount = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ReminderEntrySummary>,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,completedTodayCount: null == completedTodayCount ? _self.completedTodayCount : completedTodayCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RemindersSummary].
extension RemindersSummaryPatterns on RemindersSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RemindersSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemindersSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RemindersSummary value)  $default,){
final _that = this;
switch (_that) {
case _RemindersSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RemindersSummary value)?  $default,){
final _that = this;
switch (_that) {
case _RemindersSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ReminderEntrySummary> items,  int pendingCount,  int completedTodayCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemindersSummary() when $default != null:
return $default(_that.items,_that.pendingCount,_that.completedTodayCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ReminderEntrySummary> items,  int pendingCount,  int completedTodayCount)  $default,) {final _that = this;
switch (_that) {
case _RemindersSummary():
return $default(_that.items,_that.pendingCount,_that.completedTodayCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ReminderEntrySummary> items,  int pendingCount,  int completedTodayCount)?  $default,) {final _that = this;
switch (_that) {
case _RemindersSummary() when $default != null:
return $default(_that.items,_that.pendingCount,_that.completedTodayCount);case _:
  return null;

}
}

}

/// @nodoc


class _RemindersSummary implements RemindersSummary {
  const _RemindersSummary({required final  List<ReminderEntrySummary> items, required this.pendingCount, required this.completedTodayCount}): _items = items;
  

 final  List<ReminderEntrySummary> _items;
@override List<ReminderEntrySummary> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int pendingCount;
@override final  int completedTodayCount;

/// Create a copy of RemindersSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemindersSummaryCopyWith<_RemindersSummary> get copyWith => __$RemindersSummaryCopyWithImpl<_RemindersSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemindersSummary&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount)&&(identical(other.completedTodayCount, completedTodayCount) || other.completedTodayCount == completedTodayCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),pendingCount,completedTodayCount);

@override
String toString() {
  return 'RemindersSummary(items: $items, pendingCount: $pendingCount, completedTodayCount: $completedTodayCount)';
}


}

/// @nodoc
abstract mixin class _$RemindersSummaryCopyWith<$Res> implements $RemindersSummaryCopyWith<$Res> {
  factory _$RemindersSummaryCopyWith(_RemindersSummary value, $Res Function(_RemindersSummary) _then) = __$RemindersSummaryCopyWithImpl;
@override @useResult
$Res call({
 List<ReminderEntrySummary> items, int pendingCount, int completedTodayCount
});




}
/// @nodoc
class __$RemindersSummaryCopyWithImpl<$Res>
    implements _$RemindersSummaryCopyWith<$Res> {
  __$RemindersSummaryCopyWithImpl(this._self, this._then);

  final _RemindersSummary _self;
  final $Res Function(_RemindersSummary) _then;

/// Create a copy of RemindersSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? pendingCount = null,Object? completedTodayCount = null,}) {
  return _then(_RemindersSummary(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ReminderEntrySummary>,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,completedTodayCount: null == completedTodayCount ? _self.completedTodayCount : completedTodayCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
