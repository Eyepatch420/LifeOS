// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListItemEntity {

 String get id; String get listId; String get label; bool get isDone; int get sortOrder;
/// Create a copy of ListItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListItemEntityCopyWith<ListItemEntity> get copyWith => _$ListItemEntityCopyWithImpl<ListItemEntity>(this as ListItemEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.listId, listId) || other.listId == listId)&&(identical(other.label, label) || other.label == label)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,listId,label,isDone,sortOrder);

@override
String toString() {
  return 'ListItemEntity(id: $id, listId: $listId, label: $label, isDone: $isDone, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $ListItemEntityCopyWith<$Res>  {
  factory $ListItemEntityCopyWith(ListItemEntity value, $Res Function(ListItemEntity) _then) = _$ListItemEntityCopyWithImpl;
@useResult
$Res call({
 String id, String listId, String label, bool isDone, int sortOrder
});




}
/// @nodoc
class _$ListItemEntityCopyWithImpl<$Res>
    implements $ListItemEntityCopyWith<$Res> {
  _$ListItemEntityCopyWithImpl(this._self, this._then);

  final ListItemEntity _self;
  final $Res Function(ListItemEntity) _then;

/// Create a copy of ListItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? listId = null,Object? label = null,Object? isDone = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,listId: null == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ListItemEntity].
extension ListItemEntityPatterns on ListItemEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListItemEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListItemEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListItemEntity value)  $default,){
final _that = this;
switch (_that) {
case _ListItemEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListItemEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ListItemEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String listId,  String label,  bool isDone,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListItemEntity() when $default != null:
return $default(_that.id,_that.listId,_that.label,_that.isDone,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String listId,  String label,  bool isDone,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _ListItemEntity():
return $default(_that.id,_that.listId,_that.label,_that.isDone,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String listId,  String label,  bool isDone,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _ListItemEntity() when $default != null:
return $default(_that.id,_that.listId,_that.label,_that.isDone,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc


class _ListItemEntity implements ListItemEntity {
  const _ListItemEntity({required this.id, required this.listId, required this.label, required this.isDone, required this.sortOrder});
  

@override final  String id;
@override final  String listId;
@override final  String label;
@override final  bool isDone;
@override final  int sortOrder;

/// Create a copy of ListItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListItemEntityCopyWith<_ListItemEntity> get copyWith => __$ListItemEntityCopyWithImpl<_ListItemEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.listId, listId) || other.listId == listId)&&(identical(other.label, label) || other.label == label)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,listId,label,isDone,sortOrder);

@override
String toString() {
  return 'ListItemEntity(id: $id, listId: $listId, label: $label, isDone: $isDone, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$ListItemEntityCopyWith<$Res> implements $ListItemEntityCopyWith<$Res> {
  factory _$ListItemEntityCopyWith(_ListItemEntity value, $Res Function(_ListItemEntity) _then) = __$ListItemEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String listId, String label, bool isDone, int sortOrder
});




}
/// @nodoc
class __$ListItemEntityCopyWithImpl<$Res>
    implements _$ListItemEntityCopyWith<$Res> {
  __$ListItemEntityCopyWithImpl(this._self, this._then);

  final _ListItemEntity _self;
  final $Res Function(_ListItemEntity) _then;

/// Create a copy of ListItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? listId = null,Object? label = null,Object? isDone = null,Object? sortOrder = null,}) {
  return _then(_ListItemEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,listId: null == listId ? _self.listId : listId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$TodoList {

 String get id; String get title; String get kind; bool get isArchived; DateTime get createdAt; List<ListItemEntity> get items;
/// Create a copy of TodoList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodoListCopyWith<TodoList> get copyWith => _$TodoListCopyWithImpl<TodoList>(this as TodoList, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodoList&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,kind,isArchived,createdAt,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'TodoList(id: $id, title: $title, kind: $kind, isArchived: $isArchived, createdAt: $createdAt, items: $items)';
}


}

/// @nodoc
abstract mixin class $TodoListCopyWith<$Res>  {
  factory $TodoListCopyWith(TodoList value, $Res Function(TodoList) _then) = _$TodoListCopyWithImpl;
@useResult
$Res call({
 String id, String title, String kind, bool isArchived, DateTime createdAt, List<ListItemEntity> items
});




}
/// @nodoc
class _$TodoListCopyWithImpl<$Res>
    implements $TodoListCopyWith<$Res> {
  _$TodoListCopyWithImpl(this._self, this._then);

  final TodoList _self;
  final $Res Function(TodoList) _then;

/// Create a copy of TodoList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? kind = null,Object? isArchived = null,Object? createdAt = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ListItemEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [TodoList].
extension TodoListPatterns on TodoList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodoList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodoList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodoList value)  $default,){
final _that = this;
switch (_that) {
case _TodoList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodoList value)?  $default,){
final _that = this;
switch (_that) {
case _TodoList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String kind,  bool isArchived,  DateTime createdAt,  List<ListItemEntity> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodoList() when $default != null:
return $default(_that.id,_that.title,_that.kind,_that.isArchived,_that.createdAt,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String kind,  bool isArchived,  DateTime createdAt,  List<ListItemEntity> items)  $default,) {final _that = this;
switch (_that) {
case _TodoList():
return $default(_that.id,_that.title,_that.kind,_that.isArchived,_that.createdAt,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String kind,  bool isArchived,  DateTime createdAt,  List<ListItemEntity> items)?  $default,) {final _that = this;
switch (_that) {
case _TodoList() when $default != null:
return $default(_that.id,_that.title,_that.kind,_that.isArchived,_that.createdAt,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _TodoList implements TodoList {
  const _TodoList({required this.id, required this.title, required this.kind, required this.isArchived, required this.createdAt, required final  List<ListItemEntity> items}): _items = items;
  

@override final  String id;
@override final  String title;
@override final  String kind;
@override final  bool isArchived;
@override final  DateTime createdAt;
 final  List<ListItemEntity> _items;
@override List<ListItemEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of TodoList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodoListCopyWith<_TodoList> get copyWith => __$TodoListCopyWithImpl<_TodoList>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodoList&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,kind,isArchived,createdAt,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'TodoList(id: $id, title: $title, kind: $kind, isArchived: $isArchived, createdAt: $createdAt, items: $items)';
}


}

/// @nodoc
abstract mixin class _$TodoListCopyWith<$Res> implements $TodoListCopyWith<$Res> {
  factory _$TodoListCopyWith(_TodoList value, $Res Function(_TodoList) _then) = __$TodoListCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String kind, bool isArchived, DateTime createdAt, List<ListItemEntity> items
});




}
/// @nodoc
class __$TodoListCopyWithImpl<$Res>
    implements _$TodoListCopyWith<$Res> {
  __$TodoListCopyWithImpl(this._self, this._then);

  final _TodoList _self;
  final $Res Function(_TodoList) _then;

/// Create a copy of TodoList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? kind = null,Object? isArchived = null,Object? createdAt = null,Object? items = null,}) {
  return _then(_TodoList(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ListItemEntity>,
  ));
}


}

// dart format on
