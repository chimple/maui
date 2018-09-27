import 'dart:async';

import 'package:maui/app_database.dart';

import 'package:sqflite/sqflite.dart';

import '../entity/category_topic.dart';

class CategoryTopicDao {
  Future<List<CategoryTopic>> getCategoryTopicsByCategoryId(String categoryId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(CategoryTopic.table,
        columns: [
          CategoryTopic.categoryIdCol,
          CategoryTopic.topicIdCol,
          CategoryTopic.serialCol,
        ],
        where: '${CategoryTopic.categoryIdCol} = ?',
        whereArgs: [categoryId]);
    return maps.map((el) => new CategoryTopic.fromMap(el)).toList();
  }
}
