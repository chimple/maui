import 'dart:async';

import 'package:maui/app_database.dart';

import 'package:sqflite/sqflite.dart';

import '../entity/category_topic.dart';

class CategoryTopicDao {
  Future<CategoryTopic> getTopic(String categoryId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(CategoryTopic.table,
        columns: [
          CategoryTopic.categoryIdCol,
          CategoryTopic.topicIdCol,
          CategoryTopic.orderCol
        ],
        where: '${CategoryTopic.categoryIdCol} = ?',
        whereArgs: [categoryId]);
    if (maps.length > 0) {
      return CategoryTopic.fromMap(maps.first);
    }
    return null;
  }
   Future<List<CategoryTopic>> getAllCategoryTopic(String categoryId,{Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      CategoryTopic.table,
      columns: [
        CategoryTopic.categoryIdCol,
        CategoryTopic.topicIdCol,
        CategoryTopic.orderCol,
      ],
     where: '${CategoryTopic.categoryIdCol} = ?',
        whereArgs: [categoryId]);
    return maps.map((el) => new CategoryTopic.fromMap(el)).toList();
  }
}
