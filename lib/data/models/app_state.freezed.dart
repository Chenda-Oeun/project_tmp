// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppState {

@HiveField(0) String? get accessToken;@HiveField(0) set accessToken(String? value);@HiveField(1)@JsonKey(fromJson: dateFromJson, toJson: dateToJson) DateTime? get tokenCreatedAt;@HiveField(1)@JsonKey(fromJson: dateFromJson, toJson: dateToJson) set tokenCreatedAt(DateTime? value);@HiveField(2) User? get user;@HiveField(2) set user(User? value);@HiveField(3) String? get refreshToken;@HiveField(3) set refreshToken(String? value);
/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppStateCopyWith<AppState> get copyWith => _$AppStateCopyWithImpl<AppState>(this as AppState, _$identity);

  /// Serializes this AppState to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  final _this = this as AppState;
  return 'AppState(accessToken: ${_this.accessToken}, tokenCreatedAt: ${_this.tokenCreatedAt}, user: ${_this.user}, refreshToken: ${_this.refreshToken})';
}


}

/// @nodoc
abstract mixin class $AppStateCopyWith<$Res>  {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) _then) = _$AppStateCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String? accessToken,@HiveField(1)@JsonKey(fromJson: dateFromJson, toJson: dateToJson) DateTime? tokenCreatedAt,@HiveField(2) User? user,@HiveField(3) String? refreshToken
});


$UserCopyWith<$Res>? get user;

}
/// @nodoc
class _$AppStateCopyWithImpl<$Res>
    implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._self, this._then);

  final AppState _self;
  final $Res Function(AppState) _then;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = freezed,Object? tokenCreatedAt = freezed,Object? user = freezed,Object? refreshToken = freezed,}) {
  return _then(AppState(
accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,tokenCreatedAt: freezed == tokenCreatedAt ? _self.tokenCreatedAt : tokenCreatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppState].
extension AppStatePatterns on AppState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppState value)  $default,){
final _that = this;
switch (_that) {
case _AppState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppState value)?  $default,){
final _that = this;
switch (_that) {
case _AppState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String? accessToken, @HiveField(1)@JsonKey(fromJson: dateFromJson, toJson: dateToJson)  DateTime? tokenCreatedAt, @HiveField(2)  User? user, @HiveField(3)  String? refreshToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppState() when $default != null:
return $default(_that.accessToken,_that.tokenCreatedAt,_that.user,_that.refreshToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String? accessToken, @HiveField(1)@JsonKey(fromJson: dateFromJson, toJson: dateToJson)  DateTime? tokenCreatedAt, @HiveField(2)  User? user, @HiveField(3)  String? refreshToken)  $default,) {final _that = this;
switch (_that) {
case _AppState():
return $default(_that.accessToken,_that.tokenCreatedAt,_that.user,_that.refreshToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String? accessToken, @HiveField(1)@JsonKey(fromJson: dateFromJson, toJson: dateToJson)  DateTime? tokenCreatedAt, @HiveField(2)  User? user, @HiveField(3)  String? refreshToken)?  $default,) {final _that = this;
switch (_that) {
case _AppState() when $default != null:
return $default(_that.accessToken,_that.tokenCreatedAt,_that.user,_that.refreshToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppState extends AppState {
   _AppState({@HiveField(0) this.accessToken, @HiveField(1)@JsonKey(fromJson: dateFromJson, toJson: dateToJson) this.tokenCreatedAt, @HiveField(2) this.user, @HiveField(3) this.refreshToken}): super._();
  factory _AppState.fromJson(Map<String, dynamic> json) => _$AppStateFromJson(json);

@override@HiveField(0)  String? accessToken;
@override@HiveField(1)@JsonKey(fromJson: dateFromJson, toJson: dateToJson)  DateTime? tokenCreatedAt;
@override@HiveField(2)  User? user;
@override@HiveField(3)  String? refreshToken;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppStateCopyWith<_AppState> get copyWith => __$AppStateCopyWithImpl<_AppState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppStateToJson(this, );
}



@override
String toString() {
    return 'AppState(accessToken: $accessToken, tokenCreatedAt: $tokenCreatedAt, user: $user, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class _$AppStateCopyWith<$Res> implements $AppStateCopyWith<$Res> {
  factory _$AppStateCopyWith(_AppState value, $Res Function(_AppState) _then) = __$AppStateCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String? accessToken,@HiveField(1)@JsonKey(fromJson: dateFromJson, toJson: dateToJson) DateTime? tokenCreatedAt,@HiveField(2) User? user,@HiveField(3) String? refreshToken
});


@override $UserCopyWith<$Res>? get user;

}
/// @nodoc
class __$AppStateCopyWithImpl<$Res>
    implements _$AppStateCopyWith<$Res> {
  __$AppStateCopyWithImpl(this._self, this._then);

  final _AppState _self;
  final $Res Function(_AppState) _then;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = freezed,Object? tokenCreatedAt = freezed,Object? user = freezed,Object? refreshToken = freezed,}) {
  return _then(_AppState(
accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,tokenCreatedAt: freezed == tokenCreatedAt ? _self.tokenCreatedAt : tokenCreatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
