import 'dart:async';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSql {
  late Database database;

  Future<void> openDatabaseSql() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'cart.db');

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE cartTable(keys TEXT PRIMARY KEY, name TEXT, price TEXT, menuId TEXT, image TEXT, discount TEXT, description TEXT, quantity TEXT)",
        );
      },
    );
  }

  Future<bool> insertData(FoodModel food, int quantity) async {
    await database.insert('cartTable', {
      'keys': food.keys,
      'name': food.name,
      'price': food.price,
      'menuId': food.menuId,
      'image': food.image,
      'discount': food.discount,
      'description': food.description,
      'quantity': quantity.toString(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  Future<int?> countData() async {
    var res = await database.rawQuery('SELECT COUNT(*) FROM cartTable');
    return Sqflite.firstIntValue(res);
  }

  Future<bool> deleteData(String id) async {
    await database.delete('cartTable', where: 'keys = ?', whereArgs: [id]);
    return true;
  }

  Future<bool> deleteAllData() async {
    await database.delete('cartTable');
    return true;
  }

  Future<List<FoodModel>> getData() async {
    List<FoodModel> foodList = [];

    List<Map<String, dynamic>> maps = await database.query('cartTable');

    for (var map in maps) {
      foodList.add(FoodModel.fromMap(map));
    }
    return foodList;
  }
}
