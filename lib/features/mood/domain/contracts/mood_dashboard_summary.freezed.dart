// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mood_dashboard_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MoodDashboardSummary {

/// The most recent entry's level label (e.g. "Good") on the current
/// local day, or `null` if nothing has been logged yet today — Home
/// renders an honest empty state ("—" / "Log how you feel") rather
/// than a fabricated default.
 String? get todayLevelLabel; int get todayEntryCount; List<MoodEntrySummary> get recentEntries;
/// Create a copy of MoodDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoodDashboardSummaryCopyWith<MoodDashboardSummary> get copyWith => _$MoodDashboardSummaryCopyWithImpl<MoodDashboardSummary>(this as MoodDashboardSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoodDashboardSummary&&(identical(other.todayLevelLabel, todayLevelLabel) || other.todayLevelLabel == todayLevelLabel)&&(identical(other.todayEntryCount, todayEntryCount) || other.todayEntryCount == todayEntryCount)&&const DeepCollectionEquality().equals(other.recentEntries, recentEntries));
}


@override
int get hashCode => Object.hash(runtimeType,todayLevelLabel,todayEntryCount,const DeepCollectionEquality().hash(recentEntries));

@override
String toString() {
  return 'MoodDashboardSummary(todayLevelLabel: $todayLevelLabel, todayEntryCount: $todayEntryCount, recentEntries: $recentEntries)';
}


}

/// @nodoc
abstract mixin class $MoodDashboardSummaryCopyWith<$Res>  {
  factory $MoodDashboardSummaryCopyWith(MoodDashboardSummary value, $Res Function(MoodDashboardSummary) _then) = _$MoodDashboardSummaryCopyWithImpl;
@useResult
$Res call({
 String? todayLevelLabel, int todayEntryCount, List<MoodEntrySummary> recentEntries
});




}
/// @nodoc
class _$MoodDashboardSummaryCopyWithImpl<$Res>
    implements $MoodDashboardSummaryCopyWith<$Res> {
  _$MoodDashboardSummaryCopyWithImpl(this._self, this._then);

  final MoodDashboardSummary _self;
  final $Res Function(MoodDashboardSummary) _then;

/// Create a copy of MoodDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? todayLevelLabel = freezed,Object? todayEntryCount = null,Object? recentEntries = null,}) {
  return _then(_self.copyWith(
todayLevelLabel: freezed == todayLevelLabel ? _self.todayLevelLabel : todayLevelLabel // ignore: cast_nullable_to_non_nullable
as String?,todayEntryCount: null == todayEntryCount ? _self.todayEntryCount : todayEntryCount // ignore: cast_nullable_to_non_nullable
as int,recentEntries: null == recentEntries ? _self.recentEntries : recentEntries // ignore: cast_nullable_to_non_nullable
as List<MoodEntrySummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [MoodDashboardSummary].
extension MoodDashboardSummaryPatterns on MoodDashboardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoodDashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoodDashboardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoodDashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _MoodDashboardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoodDashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _MoodDashboardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? todayLevelLabel,  int todayEntryCount,  List<MoodEntrySummary> recentEntries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoodDashboardSummary() when $default != null:
return $default(_that.todayLevelLabel,_that.todayEntryCount,_that.recentEntries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? todayLevelLabel,  int todayEntryCount,  List<MoodEntrySummary> recentEntries)  $default,) {final _that = this;
switch (_that) {
case _MoodDashboardSummary():
return $default(_that.todayLevelLabel,_that.todayEntryCount,_that.recentEntries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? todayLevelLabel,  int todayEntryCount,  List<MoodEntrySummary> recentEntries)?  $default,) {final _that = this;
switch (_that) {
case _MoodDashboardSummary() when $default != null:
return $default(_that.todayLevelLabel,_that.todayEntryCount,_that.recentEntries);case _:
  return null;

}
}

}

/// @nodoc


class _MoodDashboardSummary implements MoodDashboardSummary {
  const _MoodDashboardSummary({this.todayLevelLabel, required this.todayEntryCount, required final  List<MoodEntrySummary> recentEntries}): _recentEntries = recentEntries;
  

/// The most recent entry's level label (e.g. "Good") on the current
/// local day, or `null` if nothing has been logged yet today — Home
/// renders an honest empty state ("—" / "Log how you feel") rather
/// than a fabricated default.
@override final  String? todayLevelLabel;
@override final  int todayEntryCount;
 final  List<MoodEntrySummary> _recentEntries;
@override List<MoodEntrySummary> get recentEntries {
  if (_recentEntries is EqualUnmodifiableListView) return _recentEntries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentEntries);
}


/// Create a copy of MoodDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoodDashboardSummaryCopyWith<_MoodDashboardSummary> get copyWith => __$MoodDashboardSummaryCopyWithImpl<_MoodDashboardSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoodDashboardSummary&&(identical(other.todayLevelLabel, todayLevelLabel) || other.todayLevelLabel == todayLevelLabel)&&(identical(other.todayEntryCount, todayEntryCount) || other.todayEntryCount == todayEntryCount)&&const DeepCollectionEquality().equals(other._recentEntries, _recentEntries));
}


@override
int get hashCode => Object.hash(runtimeType,todayLevelLabel,todayEntryCount,const DeepCollectionEquality().hash(_recentEntries));

@override
String toString() {
  return 'MoodDashboardSummary(todayLevelLabel: $todayLevelLabel, todayEntryCount: $todayEntryCount, recentEntries: $recentEntries)';
}


}

/// @nodoc
abstract mixin class _$MoodDashboardSummaryCopyWith<$Res> implements $MoodDashboardSummaryCopyWith<$Res> {
  factory _$MoodDashboardSummaryCopyWith(_MoodDashboardSummary value, $Res Function(_MoodDashboardSummary) _then) = __$MoodDashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 String? todayLevelLabel, int todayEntryCount, List<MoodEntrySummary> recentEntries
});




}
/// @nodoc
class __$MoodDashboardSummaryCopyWithImpl<$Res>
    implements _$MoodDashboardSummaryCopyWith<$Res> {
  __$MoodDashboardSummaryCopyWithImpl(this._self, this._then);

  final _MoodDashboardSummary _self;
  final $Res Function(_MoodDashboardSummary) _then;

/// Create a copy of MoodDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? todayLevelLabel = freezed,Object? todayEntryCount = null,Object? recentEntries = null,}) {
  return _then(_MoodDashboardSummary(
todayLevelLabel: freezed == todayLevelLabel ? _self.todayLevelLabel : todayLevelLabel // ignore: cast_nullable_to_non_nullable
as String?,todayEntryCount: null == todayEntryCount ? _self.todayEntryCount : todayEntryCount // ignore: cast_nullable_to_non_nullable
as int,recentEntries: null == recentEntries ? _self._recentEntries : recentEntries // ignore: cast_nullable_to_non_nullable
as List<MoodEntrySummary>,
  ));
}


}

/// @nodoc
mixin _$MoodEntrySummary {

 String get id; String get levelLabel; String get levelEmoji; String? get note; DateTime get recordedAt;
/// Create a copy of MoodEntrySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoodEntrySummaryCopyWith<MoodEntrySummary> get copyWith => _$MoodEntrySummaryCopyWithImpl<MoodEntrySummary>(this as MoodEntrySummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoodEntrySummary&&(identical(other.id, id) || other.id == id)&&(identical(other.levelLabel, levelLabel) || other.levelLabel == levelLabel)&&(identical(other.levelEmoji, levelEmoji) || other.levelEmoji == levelEmoji)&&(identical(other.note, note) || other.note == note)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,levelLabel,levelEmoji,note,recordedAt);

@override
String toString() {
  return 'MoodEntrySummary(id: $id, levelLabel: $levelLabel, levelEmoji: $levelEmoji, note: $note, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class $MoodEntrySummaryCopyWith<$Res>  {
  factory $MoodEntrySummaryCopyWith(MoodEntrySummary value, $Res Function(MoodEntrySummary) _then) = _$MoodEntrySummaryCopyWithImpl;
@useResult
$Res call({
 String id, String levelLabel, String levelEmoji, String? note, DateTime recordedAt
});




}
/// @nodoc
class _$MoodEntrySummaryCopyWithImpl<$Res>
    implements $MoodEntrySummaryCopyWith<$Res> {
  _$MoodEntrySummaryCopyWithImpl(this._self, this._then);

  final MoodEntrySummary _self;
  final $Res Function(MoodEntrySummary) _then;

/// Create a copy of MoodEntrySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? levelLabel = null,Object? levelEmoji = null,Object? note = freezed,Object? recordedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,levelLabel: null == levelLabel ? _self.levelLabel : levelLabel // ignore: cast_nullable_to_non_nullable
as String,levelEmoji: null == levelEmoji ? _self.levelEmoji : levelEmoji // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MoodEntrySummary].
extension MoodEntrySummaryPatterns on MoodEntrySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoodEntrySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoodEntrySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoodEntrySummary value)  $default,){
final _that = this;
switch (_that) {
case _MoodEntrySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoodEntrySummary value)?  $default,){
final _that = this;
switch (_that) {
case _MoodEntrySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String levelLabel,  String levelEmoji,  String? note,  DateTime recordedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoodEntrySummary() when $default != null:
return $default(_that.id,_that.levelLabel,_that.levelEmoji,_that.note,_that.recordedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String levelLabel,  String levelEmoji,  String? note,  DateTime recordedAt)  $default,) {final _that = this;
switch (_that) {
case _MoodEntrySummary():
return $default(_that.id,_that.levelLabel,_that.levelEmoji,_that.note,_that.recordedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String levelLabel,  String levelEmoji,  String? note,  DateTime recordedAt)?  $default,) {final _that = this;
switch (_that) {
case _MoodEntrySummary() when $default != null:
return $default(_that.id,_that.levelLabel,_that.levelEmoji,_that.note,_that.recordedAt);case _:
  return null;

}
}

}

/// @nodoc


class _MoodEntrySummary implements MoodEntrySummary {
  const _MoodEntrySummary({required this.id, required this.levelLabel, required this.levelEmoji, this.note, required this.recordedAt});
  

@override final  String id;
@override final  String levelLabel;
@override final  String levelEmoji;
@override final  String? note;
@override final  DateTime recordedAt;

/// Create a copy of MoodEntrySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoodEntrySummaryCopyWith<_MoodEntrySummary> get copyWith => __$MoodEntrySummaryCopyWithImpl<_MoodEntrySummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoodEntrySummary&&(identical(other.id, id) || other.id == id)&&(identical(other.levelLabel, levelLabel) || other.levelLabel == levelLabel)&&(identical(other.levelEmoji, levelEmoji) || other.levelEmoji == levelEmoji)&&(identical(other.note, note) || other.note == note)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,levelLabel,levelEmoji,note,recordedAt);

@override
String toString() {
  return 'MoodEntrySummary(id: $id, levelLabel: $levelLabel, levelEmoji: $levelEmoji, note: $note, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class _$MoodEntrySummaryCopyWith<$Res> implements $MoodEntrySummaryCopyWith<$Res> {
  factory _$MoodEntrySummaryCopyWith(_MoodEntrySummary value, $Res Function(_MoodEntrySummary) _then) = __$MoodEntrySummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String levelLabel, String levelEmoji, String? note, DateTime recordedAt
});




}
/// @nodoc
class __$MoodEntrySummaryCopyWithImpl<$Res>
    implements _$MoodEntrySummaryCopyWith<$Res> {
  __$MoodEntrySummaryCopyWithImpl(this._self, this._then);

  final _MoodEntrySummary _self;
  final $Res Function(_MoodEntrySummary) _then;

/// Create a copy of MoodEntrySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? levelLabel = null,Object? levelEmoji = null,Object? note = freezed,Object? recordedAt = null,}) {
  return _then(_MoodEntrySummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,levelLabel: null == levelLabel ? _self.levelLabel : levelLabel // ignore: cast_nullable_to_non_nullable
as String,levelEmoji: null == levelEmoji ? _self.levelEmoji : levelEmoji // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
