// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weight_dashboard_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeightDashboardSummary {

 double? get latestWeightKg;/// `latestWeightKg - previousWeightKg`, presented neutrally (not
/// color-coded good/bad — see `WeightScreen`'s doc comment) — `null`
/// when there's fewer than two measurements to compare.
 double? get changeFromPreviousKg; List<WeightEntrySummary> get recentEntries;
/// Create a copy of WeightDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightDashboardSummaryCopyWith<WeightDashboardSummary> get copyWith => _$WeightDashboardSummaryCopyWithImpl<WeightDashboardSummary>(this as WeightDashboardSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightDashboardSummary&&(identical(other.latestWeightKg, latestWeightKg) || other.latestWeightKg == latestWeightKg)&&(identical(other.changeFromPreviousKg, changeFromPreviousKg) || other.changeFromPreviousKg == changeFromPreviousKg)&&const DeepCollectionEquality().equals(other.recentEntries, recentEntries));
}


@override
int get hashCode => Object.hash(runtimeType,latestWeightKg,changeFromPreviousKg,const DeepCollectionEquality().hash(recentEntries));

@override
String toString() {
  return 'WeightDashboardSummary(latestWeightKg: $latestWeightKg, changeFromPreviousKg: $changeFromPreviousKg, recentEntries: $recentEntries)';
}


}

/// @nodoc
abstract mixin class $WeightDashboardSummaryCopyWith<$Res>  {
  factory $WeightDashboardSummaryCopyWith(WeightDashboardSummary value, $Res Function(WeightDashboardSummary) _then) = _$WeightDashboardSummaryCopyWithImpl;
@useResult
$Res call({
 double? latestWeightKg, double? changeFromPreviousKg, List<WeightEntrySummary> recentEntries
});




}
/// @nodoc
class _$WeightDashboardSummaryCopyWithImpl<$Res>
    implements $WeightDashboardSummaryCopyWith<$Res> {
  _$WeightDashboardSummaryCopyWithImpl(this._self, this._then);

  final WeightDashboardSummary _self;
  final $Res Function(WeightDashboardSummary) _then;

/// Create a copy of WeightDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latestWeightKg = freezed,Object? changeFromPreviousKg = freezed,Object? recentEntries = null,}) {
  return _then(_self.copyWith(
latestWeightKg: freezed == latestWeightKg ? _self.latestWeightKg : latestWeightKg // ignore: cast_nullable_to_non_nullable
as double?,changeFromPreviousKg: freezed == changeFromPreviousKg ? _self.changeFromPreviousKg : changeFromPreviousKg // ignore: cast_nullable_to_non_nullable
as double?,recentEntries: null == recentEntries ? _self.recentEntries : recentEntries // ignore: cast_nullable_to_non_nullable
as List<WeightEntrySummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [WeightDashboardSummary].
extension WeightDashboardSummaryPatterns on WeightDashboardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeightDashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeightDashboardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeightDashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _WeightDashboardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeightDashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _WeightDashboardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? latestWeightKg,  double? changeFromPreviousKg,  List<WeightEntrySummary> recentEntries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeightDashboardSummary() when $default != null:
return $default(_that.latestWeightKg,_that.changeFromPreviousKg,_that.recentEntries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? latestWeightKg,  double? changeFromPreviousKg,  List<WeightEntrySummary> recentEntries)  $default,) {final _that = this;
switch (_that) {
case _WeightDashboardSummary():
return $default(_that.latestWeightKg,_that.changeFromPreviousKg,_that.recentEntries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? latestWeightKg,  double? changeFromPreviousKg,  List<WeightEntrySummary> recentEntries)?  $default,) {final _that = this;
switch (_that) {
case _WeightDashboardSummary() when $default != null:
return $default(_that.latestWeightKg,_that.changeFromPreviousKg,_that.recentEntries);case _:
  return null;

}
}

}

/// @nodoc


class _WeightDashboardSummary implements WeightDashboardSummary {
  const _WeightDashboardSummary({this.latestWeightKg, this.changeFromPreviousKg, required final  List<WeightEntrySummary> recentEntries}): _recentEntries = recentEntries;
  

@override final  double? latestWeightKg;
/// `latestWeightKg - previousWeightKg`, presented neutrally (not
/// color-coded good/bad — see `WeightScreen`'s doc comment) — `null`
/// when there's fewer than two measurements to compare.
@override final  double? changeFromPreviousKg;
 final  List<WeightEntrySummary> _recentEntries;
@override List<WeightEntrySummary> get recentEntries {
  if (_recentEntries is EqualUnmodifiableListView) return _recentEntries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentEntries);
}


/// Create a copy of WeightDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeightDashboardSummaryCopyWith<_WeightDashboardSummary> get copyWith => __$WeightDashboardSummaryCopyWithImpl<_WeightDashboardSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeightDashboardSummary&&(identical(other.latestWeightKg, latestWeightKg) || other.latestWeightKg == latestWeightKg)&&(identical(other.changeFromPreviousKg, changeFromPreviousKg) || other.changeFromPreviousKg == changeFromPreviousKg)&&const DeepCollectionEquality().equals(other._recentEntries, _recentEntries));
}


@override
int get hashCode => Object.hash(runtimeType,latestWeightKg,changeFromPreviousKg,const DeepCollectionEquality().hash(_recentEntries));

@override
String toString() {
  return 'WeightDashboardSummary(latestWeightKg: $latestWeightKg, changeFromPreviousKg: $changeFromPreviousKg, recentEntries: $recentEntries)';
}


}

/// @nodoc
abstract mixin class _$WeightDashboardSummaryCopyWith<$Res> implements $WeightDashboardSummaryCopyWith<$Res> {
  factory _$WeightDashboardSummaryCopyWith(_WeightDashboardSummary value, $Res Function(_WeightDashboardSummary) _then) = __$WeightDashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 double? latestWeightKg, double? changeFromPreviousKg, List<WeightEntrySummary> recentEntries
});




}
/// @nodoc
class __$WeightDashboardSummaryCopyWithImpl<$Res>
    implements _$WeightDashboardSummaryCopyWith<$Res> {
  __$WeightDashboardSummaryCopyWithImpl(this._self, this._then);

  final _WeightDashboardSummary _self;
  final $Res Function(_WeightDashboardSummary) _then;

/// Create a copy of WeightDashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latestWeightKg = freezed,Object? changeFromPreviousKg = freezed,Object? recentEntries = null,}) {
  return _then(_WeightDashboardSummary(
latestWeightKg: freezed == latestWeightKg ? _self.latestWeightKg : latestWeightKg // ignore: cast_nullable_to_non_nullable
as double?,changeFromPreviousKg: freezed == changeFromPreviousKg ? _self.changeFromPreviousKg : changeFromPreviousKg // ignore: cast_nullable_to_non_nullable
as double?,recentEntries: null == recentEntries ? _self._recentEntries : recentEntries // ignore: cast_nullable_to_non_nullable
as List<WeightEntrySummary>,
  ));
}


}

/// @nodoc
mixin _$WeightEntrySummary {

 String get id; double get weightKg; String? get note; DateTime get recordedAt;
/// Create a copy of WeightEntrySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightEntrySummaryCopyWith<WeightEntrySummary> get copyWith => _$WeightEntrySummaryCopyWithImpl<WeightEntrySummary>(this as WeightEntrySummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightEntrySummary&&(identical(other.id, id) || other.id == id)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.note, note) || other.note == note)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,weightKg,note,recordedAt);

@override
String toString() {
  return 'WeightEntrySummary(id: $id, weightKg: $weightKg, note: $note, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class $WeightEntrySummaryCopyWith<$Res>  {
  factory $WeightEntrySummaryCopyWith(WeightEntrySummary value, $Res Function(WeightEntrySummary) _then) = _$WeightEntrySummaryCopyWithImpl;
@useResult
$Res call({
 String id, double weightKg, String? note, DateTime recordedAt
});




}
/// @nodoc
class _$WeightEntrySummaryCopyWithImpl<$Res>
    implements $WeightEntrySummaryCopyWith<$Res> {
  _$WeightEntrySummaryCopyWithImpl(this._self, this._then);

  final WeightEntrySummary _self;
  final $Res Function(WeightEntrySummary) _then;

/// Create a copy of WeightEntrySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? weightKg = null,Object? note = freezed,Object? recordedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WeightEntrySummary].
extension WeightEntrySummaryPatterns on WeightEntrySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeightEntrySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeightEntrySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeightEntrySummary value)  $default,){
final _that = this;
switch (_that) {
case _WeightEntrySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeightEntrySummary value)?  $default,){
final _that = this;
switch (_that) {
case _WeightEntrySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  double weightKg,  String? note,  DateTime recordedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeightEntrySummary() when $default != null:
return $default(_that.id,_that.weightKg,_that.note,_that.recordedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  double weightKg,  String? note,  DateTime recordedAt)  $default,) {final _that = this;
switch (_that) {
case _WeightEntrySummary():
return $default(_that.id,_that.weightKg,_that.note,_that.recordedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  double weightKg,  String? note,  DateTime recordedAt)?  $default,) {final _that = this;
switch (_that) {
case _WeightEntrySummary() when $default != null:
return $default(_that.id,_that.weightKg,_that.note,_that.recordedAt);case _:
  return null;

}
}

}

/// @nodoc


class _WeightEntrySummary implements WeightEntrySummary {
  const _WeightEntrySummary({required this.id, required this.weightKg, this.note, required this.recordedAt});
  

@override final  String id;
@override final  double weightKg;
@override final  String? note;
@override final  DateTime recordedAt;

/// Create a copy of WeightEntrySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeightEntrySummaryCopyWith<_WeightEntrySummary> get copyWith => __$WeightEntrySummaryCopyWithImpl<_WeightEntrySummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeightEntrySummary&&(identical(other.id, id) || other.id == id)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.note, note) || other.note == note)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,weightKg,note,recordedAt);

@override
String toString() {
  return 'WeightEntrySummary(id: $id, weightKg: $weightKg, note: $note, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class _$WeightEntrySummaryCopyWith<$Res> implements $WeightEntrySummaryCopyWith<$Res> {
  factory _$WeightEntrySummaryCopyWith(_WeightEntrySummary value, $Res Function(_WeightEntrySummary) _then) = __$WeightEntrySummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, double weightKg, String? note, DateTime recordedAt
});




}
/// @nodoc
class __$WeightEntrySummaryCopyWithImpl<$Res>
    implements _$WeightEntrySummaryCopyWith<$Res> {
  __$WeightEntrySummaryCopyWithImpl(this._self, this._then);

  final _WeightEntrySummary _self;
  final $Res Function(_WeightEntrySummary) _then;

/// Create a copy of WeightEntrySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? weightKg = null,Object? note = freezed,Object? recordedAt = null,}) {
  return _then(_WeightEntrySummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
