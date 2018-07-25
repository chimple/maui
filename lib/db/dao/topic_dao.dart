import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/topic.dart';
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
}
