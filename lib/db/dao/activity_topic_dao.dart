import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/activity_topic.dart';
import 'package:sqflite/sqflite.dart';

class ActivityTopicDao {
  Future<ActivityTopic> getActivityTopic(String id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    print("there is new data $db");
    List<Map> maps = await db.query(ActivityTopic.table,
        columns: [ActivityTopic.activityIdCol, ActivityTopic.topicIdCol],
        where: '${ActivityTopic.activityIdCol} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      print("this is my data");
      return ActivityTopic.fromMap(maps.first);
    }
    return null;
  }
}
