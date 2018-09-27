import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/sub_category.dart';
import 'package:sqflite/sqflite.dart';

class SubCategoryDao {
  Future<Subcategory> getSubCategory(String id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Subcategory.table,
        columns: [
          Subcategory.categoryIdCol,
          Subcategory.subcategoryIdCol,
          Subcategory.serialCol
        ],
        where: '${Subcategory.categoryIdCol} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Subcategory.fromMap(maps.first);
    }
    return null;
  }
}
