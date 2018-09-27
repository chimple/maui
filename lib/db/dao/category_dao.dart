import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/category.dart';
import 'package:maui/db/entity/sub_category.dart';
import 'package:sqflite/sqflite.dart';

class CategoryDao {
  Future<List<Category>> getCategories({Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      Category.table,
      columns: [
        Category.idCol,
        Category.nameCol,
        Category.colorCol,
      ],
    );
    return maps.map((el) => new Category.fromMap(el)).toList();
  }

  Future<List<Category>> getSubcategoriesByCategoryId(String categoryId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps =
        await db.query('${Category.table} c, ${Subcategory.table} s', columns: [
      'c.${Category.idCol}',
      'c.${Category.nameCol}',
      'c.${Category.colorCol}',
      'c.${Category.imageCol}',
    ], where: '''
c.${Category.idCol} = s.${Subcategory.subcategoryIdCol} 
AND s.${Subcategory.categoryIdCol} = ?
''', whereArgs: [
      categoryId
    ]);
    return maps.map((el) => new Category.fromMap(el)).toList();
  }
}
