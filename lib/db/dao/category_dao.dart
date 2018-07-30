import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/category.dart';
import 'package:sqflite/sqflite.dart';

class CategoryDao {
  Future<List<Category>> getTheCategories({Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      Category.table,
      columns: [
        Category.categoryIdCol,
        Category.nameCol,
        Category.colorCol,
      ],
    );
    return maps.map((el) => new Category.fromMap(el)).toList();
  }
}
