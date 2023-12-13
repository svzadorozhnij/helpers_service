import 'dart:convert';

import 'package:helpers/services/error_messaging.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

enum TypeHiveItemBox { products, favorite, history, shoppingList, recipe }

class HiveDatabaseService {
  static final HiveDatabaseService _instance = HiveDatabaseService._internal();

  factory HiveDatabaseService() {
    return _instance;
  }

  HiveDatabaseService._internal();

  Future<void> init() async {
    final path = await getApplicationDocumentsDirectory();
    Hive.init('${path.path}/foodGuruFiles');
  }

  ///@data - element must have a toJson method.
  Future<void> saveOneItemData({
    required String id,
    required dynamic data,
    required TypeHiveItemBox typeHiveItemBox,
  }) async {
    try {
      if (data is List) {
        errorLog(
          reason:
              'You try save List typeData in method Hive().saveOneItemData()',
          classError: 'HiveService',
          methodError: 'saveOneItemData',
        );
        return;
      }
      String fileForSave = jsonEncode(data.toJson());
      Box box = await Hive.openBox(typeHiveItemBox.name);
      await box.put(id, fileForSave);
      box.close();
    } catch (e) {
      errorLog(
          reason: e.toString(),
          classError: 'HiveService',
          methodError: 'saveOneItemData');
    }
  }

  ///@data - elements must have a toJson method.
  Future<void> saveListData(
      {required String id,
      required List<dynamic> data,
      required TypeHiveItemBox typeHiveItemBox}) async {
    try {
      final filesInList = [for (final file in data) jsonEncode(file.toJson())];
      String fileForSave = jsonEncode(filesInList);
      Box box = await Hive.openBox(typeHiveItemBox.name);
      await box.put(id, fileForSave);
      box.close();
    } catch (e) {
      errorLog(
          reason: e.toString(),
          classError: 'HiveService',
          methodError: 'saveListData');
    }
  }

  Future<dynamic> getOneItemData({
    required String id,
    required TypeHiveItemBox typeHiveItemBox,
  }) async {
    try {
      Box box = await Hive.openBox(typeHiveItemBox.name);
      final dataFromDB = await box.get(id);
      box.close();
      if (dataFromDB != null) {
        return jsonDecode(dataFromDB);
      }
      return null;
    } catch (e) {
      errorLog(
          reason: e.toString(),
          classError: 'HiveService',
          methodError: 'getOneItemData');
    }
  }

  Future<List<dynamic>> getListData({
    required String id,
    required TypeHiveItemBox typeHiveItemBox,
  }) async {
    try {
      Box box = await Hive.openBox(typeHiveItemBox.name);
      final dataFromDB = await box.get(id);
      box.close();
      if (dataFromDB != null) {
        final listData = jsonDecode(dataFromDB);
        return listData.map((e) => jsonDecode(e)).toList();
      }
    } catch (e) {
      errorLog(
          reason: e.toString(),
          classError: 'HiveService',
          methodError: 'getListData');
    }
    return [];
  }

  Future<void> cleanHiveData() async {
    await Hive.deleteFromDisk();
  }
}
