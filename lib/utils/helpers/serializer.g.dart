part of 'serializer.dart';

T? deserializeType<T>(dynamic json) {
  var types = [User,AppState,Setting];
  if (types.contains(T)) {
    if (T == User) {
      return User.fromJson(json) as T;
    } else if (T == AppState) {
      return AppState.fromJson(json) as T;
    } else if (T == Setting) {
      return Setting.fromJson(json) as T;
    }
  }
  return null;
}
      