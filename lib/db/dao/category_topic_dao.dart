import 'dart:async';

import 'package:maui/app_database.dart';

import 'package:sqflite/sqflite.dart';

import '../entity/category_topic.dart';

class CategoryTopicDao{
  Future<CategoryTopic> getTopic(String id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(CategoryTopic.table,
        columns: [CategoryTopic.idcCol, CategoryTopic.idtCol,CategoryTopic.orderCol],
        where: '${CategoryTopic.idcCol} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return CategoryTopic.fromMap(maps.first);
    }
    return null;
  }
}
