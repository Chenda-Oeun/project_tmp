import 'dart:ui';
import 'package:project_tmp/data/models/app_state.dart';
import 'package:project_tmp/data/models/setting.dart';
import 'package:project_tmp/data/models/user.dart';
import 'package:project_tmp/utils/exceptions/string_exception.dart';
import 'package:project_tmp/utils/helpers/general.dart';

part 'serializer.g.dart';

T deserialize<T>(dynamic json) {
  var result = deserializeType<T>(json);
  if (result != null) {
    return result;
  }
  if ([String, int, double, bool, Color].contains(T)) {
    return json as T;
  } else if (T == num) {
    return numFromDynamicJson(json) as T;
  } else if (T == Color) {
    return deserializeColor(json) as T;
  } else if (T == dynamic) {
    return json;
  }
  throw StringException('Type $T is not registered in serializer.dart');
}

List<T> deserializeList<T>(List<dynamic> json) {
  return List.generate(json.length, (index) => deserialize<T>(json[index]));
}
