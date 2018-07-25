import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/sub_category.dart';
import 'package:sqflite/sqflite.dart';

class SubCategoryDao {
  Future<SubCategory> getSubCategory(String id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(SubCategory.table,
        columns: [SubCategory.category_idCol, SubCategory.sub_category_idCol, SubCategory.orderCol],
        where: '${SubCategory.category_idCol} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return SubCategory.fromMap(maps.first);
    }
    return null;
  }
}