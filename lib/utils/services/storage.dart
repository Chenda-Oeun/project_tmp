import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:project_tmp/data/enums/storage_box.dart';

class StorageService {
  static const defaultBoxName = StorageBox.generalBox;

  static ValueListenable<Box> getListenable(
      String? key, {
        StorageBox boxName = defaultBoxName,
      }) {
    if (key == null) {
      return Hive.box(boxName.toString()).listenable();
    }
    return Hive.box(boxName.toString()).listenable(keys: [key]);
  }

  const StorageService._();

  static Future<void> add<T>({
    required T data,
    required StorageBox boxName,
  }) async {
    final box = Hive.box(boxName.toString());
    await box.add(data);
  }

  static List<T> list<T>({
    required StorageBox boxName,
  }) {
    final box = Hive.box(boxName.toString());
    return List<T>.from(box.values);
  }

  static Future<void> remove<T>({
    required T data,
    required StorageBox boxName,
  }) async {
    final box = Hive.box(boxName.toString());
    final index = list<T>(boxName: boxName).indexOf(data);
    if (index != -1) {
      await box.deleteAt(index);
    }
  }

  static Future<void> put<T>({
    required String key,
    required T data,
    StorageBox boxName = defaultBoxName,
  }) async {
    final box = Hive.box(boxName.toString());
    await box.put(key, data);
  }

  static dynamic get({
    required String key,
    StorageBox boxName = defaultBoxName,
    dynamic defaultValue,
  }) {
    final box = Hive.box(boxName.toString());
    return box.get(
      key,
      defaultValue: defaultValue,
    );
  }

  static Future<void> delete({
    required String key,
    StorageBox boxName = defaultBoxName,
    dynamic defaultValue,
  }) async {
    final box = Hive.box(boxName.toString());
    await box.delete(key);
  }
}