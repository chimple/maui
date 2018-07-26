import 'dart:async';

import 'package:maui/app_database.dart';

import 'package:sqflite/sqflite.dart';

import '../entity/category_topic.dart';

class CategoryTopicDao {
  Future<CategoryTopic> getTopic(String categoryId, String topicId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(CategoryTopic.table,
        columns: [
          CategoryTopic.idcCol,
          CategoryTopic.idtCol,
          CategoryTopic.orderCol
        ],
        where: '${CategoryTopic.idcCol} = ? AND ${CategoryTopic.idtCol} = ?',
        whereArgs: [categoryId, topicId]);
    if (maps.length > 0) {
      return CategoryTopic.fromMap(maps.first);
    }
    return null;
  }
}
