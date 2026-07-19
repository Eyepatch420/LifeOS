// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpcomingEventSummary {

 String get id; String get title; DateTime get startAt; bool get isAllDay;
/// Create a copy of UpcomingEventSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpcomingEventSummaryCopyWith<UpcomingEventSummary> get copyWith => _$UpcomingEventSummaryCopyWithImpl<UpcomingEventSummary>(this as UpcomingEventSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpcomingEventSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.isAllDay, isAllDay) || other.isAllDay == isAllDay));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,startAt,isAllDay);

@override
String toString() {
  return 'UpcomingEventSummary(id: $id, title: $title, startAt: $startAt, isAllDay: $isAllDay)';
}


}

/// @nodoc
abstract mixin class $UpcomingEventSummaryCopyWith<$Res>  {
  factory $UpcomingEventSummaryCopyWith(UpcomingEventSummary value, $Res Function(UpcomingEventSummary) _then) = _$UpcomingEventSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime startAt, bool isAllDay
});




}
/// @nodoc
class _$UpcomingEventSummaryCopyWithImpl<$Res>
    implements $UpcomingEventSummaryCopyWith<$Res> {
  _$UpcomingEventSummaryCopyWithImpl(this._self, this._then);

  final UpcomingEventSummary _self;
  final $Res Function(UpcomingEventSummary) _then;

/// Create a copy of UpcomingEventSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? startAt = null,Object? isAllDay = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,isAllDay: null == isAllDay ? _self.isAllDay : isAllDay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UpcomingEventSummary].
extension UpcomingEventSummaryPatterns on UpcomingEventSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpcomingEventSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpcomingEventSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpcomingEventSummary value)  $default,){
final _that = this;
switch (_that) {
case _UpcomingEventSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpcomingEventSummary value)?  $default,){
final _that = this;
switch (_that) {
case _UpcomingEventSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime startAt,  bool isAllDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpcomingEventSummary() when $default != null:
return $default(_that.id,_that.title,_that.startAt,_that.isAllDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime startAt,  bool isAllDay)  $default,) {final _that = this;
switch (_that) {
case _UpcomingEventSummary():
return $default(_that.id,_that.title,_that.startAt,_that.isAllDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime startAt,  bool isAllDay)?  $default,) {final _that = this;
switch (_that) {
case _UpcomingEventSummary() when $default != null:
return $default(_that.id,_that.title,_that.startAt,_that.isAllDay);case _:
  return null;

}
}

}

/// @nodoc


class _UpcomingEventSummary implements UpcomingEventSummary {
  const _UpcomingEventSummary({required this.id, required this.title, required this.startAt, required this.isAllDay});
  

@override final  String id;
@override final  String title;
@override final  DateTime startAt;
@override final  bool isAllDay;

/// Create a copy of UpcomingEventSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpcomingEventSummaryCopyWith<_UpcomingEventSummary> get copyWith => __$UpcomingEventSummaryCopyWithImpl<_UpcomingEventSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpcomingEventSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.isAllDay, isAllDay) || other.isAllDay == isAllDay));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,startAt,isAllDay);

@override
String toString() {
  return 'UpcomingEventSummary(id: $id, title: $title, startAt: $startAt, isAllDay: $isAllDay)';
}


}

/// @nodoc
abstract mixin class _$UpcomingEventSummaryCopyWith<$Res> implements $UpcomingEventSummaryCopyWith<$Res> {
  factory _$UpcomingEventSummaryCopyWith(_UpcomingEventSummary value, $Res Function(_UpcomingEventSummary) _then) = __$UpcomingEventSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime startAt, bool isAllDay
});




}
/// @nodoc
class __$UpcomingEventSummaryCopyWithImpl<$Res>
    implements _$UpcomingEventSummaryCopyWith<$Res> {
  __$UpcomingEventSummaryCopyWithImpl(this._self, this._then);

  final _UpcomingEventSummary _self;
  final $Res Function(_UpcomingEventSummary) _then;

/// Create a copy of UpcomingEventSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? startAt = null,Object? isAllDay = null,}) {
  return _then(_UpcomingEventSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,isAllDay: null == isAllDay ? _self.isAllDay : isAllDay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$CalendarSummary {

 List<UpcomingEventSummary> get upcoming; int get todayCount;
/// Create a copy of CalendarSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarSummaryCopyWith<CalendarSummary> get copyWith => _$CalendarSummaryCopyWithImpl<CalendarSummary>(this as CalendarSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarSummary&&const DeepCollectionEquality().equals(other.upcoming, upcoming)&&(identical(other.todayCount, todayCount) || other.todayCount == todayCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(upcoming),todayCount);

@override
String toString() {
  return 'CalendarSummary(upcoming: $upcoming, todayCount: $todayCount)';
}


}

/// @nodoc
abstract mixin class $CalendarSummaryCopyWith<$Res>  {
  factory $CalendarSummaryCopyWith(CalendarSummary value, $Res Function(CalendarSummary) _then) = _$CalendarSummaryCopyWithImpl;
@useResult
$Res call({
 List<UpcomingEventSummary> upcoming, int todayCount
});




}
/// @nodoc
class _$CalendarSummaryCopyWithImpl<$Res>
    implements $CalendarSummaryCopyWith<$Res> {
  _$CalendarSummaryCopyWithImpl(this._self, this._then);

  final CalendarSummary _self;
  final $Res Function(CalendarSummary) _then;

/// Create a copy of CalendarSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? upcoming = null,Object? todayCount = null,}) {
  return _then(_self.copyWith(
upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<UpcomingEventSummary>,todayCount: null == todayCount ? _self.todayCount : todayCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarSummary].
extension CalendarSummaryPatterns on CalendarSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarSummary value)  $default,){
final _that = this;
switch (_that) {
case _CalendarSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<UpcomingEventSummary> upcoming,  int todayCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarSummary() when $default != null:
return $default(_that.upcoming,_that.todayCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<UpcomingEventSummary> upcoming,  int todayCount)  $default,) {final _that = this;
switch (_that) {
case _CalendarSummary():
return $default(_that.upcoming,_that.todayCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<UpcomingEventSummary> upcoming,  int todayCount)?  $default,) {final _that = this;
switch (_that) {
case _CalendarSummary() when $default != null:
return $default(_that.upcoming,_that.todayCount);case _:
  return null;

}
}

}

/// @nodoc


class _CalendarSummary implements CalendarSummary {
  const _CalendarSummary({required final  List<UpcomingEventSummary> upcoming, required this.todayCount}): _upcoming = upcoming;
  

 final  List<UpcomingEventSummary> _upcoming;
@override List<UpcomingEventSummary> get upcoming {
  if (_upcoming is EqualUnmodifiableListView) return _upcoming;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upcoming);
}

@override final  int todayCount;

/// Create a copy of CalendarSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarSummaryCopyWith<_CalendarSummary> get copyWith => __$CalendarSummaryCopyWithImpl<_CalendarSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarSummary&&const DeepCollectionEquality().equals(other._upcoming, _upcoming)&&(identical(other.todayCount, todayCount) || other.todayCount == todayCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_upcoming),todayCount);

@override
String toString() {
  return 'CalendarSummary(upcoming: $upcoming, todayCount: $todayCount)';
}


}

/// @nodoc
abstract mixin class _$CalendarSummaryCopyWith<$Res> implements $CalendarSummaryCopyWith<$Res> {
  factory _$CalendarSummaryCopyWith(_CalendarSummary value, $Res Function(_CalendarSummary) _then) = __$CalendarSummaryCopyWithImpl;
@override @useResult
$Res call({
 List<UpcomingEventSummary> upcoming, int todayCount
});




}
/// @nodoc
class __$CalendarSummaryCopyWithImpl<$Res>
    implements _$CalendarSummaryCopyWith<$Res> {
  __$CalendarSummaryCopyWithImpl(this._self, this._then);

  final _CalendarSummary _self;
  final $Res Function(_CalendarSummary) _then;

/// Create a copy of CalendarSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? upcoming = null,Object? todayCount = null,}) {
  return _then(_CalendarSummary(
upcoming: null == upcoming ? _self._upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<UpcomingEventSummary>,todayCount: null == todayCount ? _self.todayCount : todayCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
