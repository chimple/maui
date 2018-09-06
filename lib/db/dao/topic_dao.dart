import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/topic.dart';
import 'package:maui/db/entity/category_topic.dart';
import 'package:sqflite/sqflite.dart';

class TopicDao {
  Future<Topic> getTopic(String id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Topic.table,
        columns: [Topic.idCol, Topic.nameCol, Topic.imageCol, Topic.colorCol],
        where: '${Topic.idCol} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Topic.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Topic>> getTopicsForCategoryId(String categoryId,
      {Database db}) async {
    print("hello the id was in this is...::$categoryId");
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
        '${Topic.table} t, ${CategoryTopic.table} c',
        columns: [Topic.idCol, Topic.nameCol, Topic.imageCol, Topic.colorCol],
        where: '''
t.${Topic.idCol} = c.${CategoryTopic.topicIdCol}
AND c.${CategoryTopic.categoryIdCol} = ?
''',
        whereArgs: [categoryId]);

    print("the data from database is....::$maps");
    return maps.map((el) => new Topic.fromMap(el)).toList();
  }

  Future<List<Topic>> getAllTopics({Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      Topic.table,
      columns: [Topic.idCol, Topic.nameCol, Topic.imageCol, Topic.colorCol],
    );
    return maps.map((el) => new Topic.fromMap(el)).toList();
  }
}
