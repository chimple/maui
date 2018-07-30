import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/activity_topic.dart';
import 'package:sqflite/sqflite.dart';

class ActivityTopicDao {
  Future<List<ActivityTopic>> getActivityTopicByTopicId(String topicId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(ActivityTopic.table,
        columns: [
          ActivityTopic.activityIdCol,
          ActivityTopic.topicIdCol,
        ],
        where: "${ActivityTopic.topicIdCol} = ?",
        whereArgs: [topicId]);
    if (maps.length > 0) {
      return maps.map((el) => new ActivityTopic.fromMap(el)).toList();
    }
    return null;
  }
}
