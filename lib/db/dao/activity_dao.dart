import 'dart:async';
import 'package:maui/app_database.dart';
import 'package:maui/db/entity/activity.dart';
import 'package:sqflite/sqflite.dart';

class ActivityDao {
  Future<Activity> getActivity(String id, String topicId, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Activity.table,
        columns: [
          Activity.idCol,
          Activity.topicIdCol,
          Activity.orderCol,
          Activity.textCol,
          Activity.stickerPackCol
        ],
        where: "${Activity.idCol} = ? AND ${Activity.topicIdCol} = ?",
        whereArgs: [id, topicId]);
    if (maps.length > 0) {
      return Activity.fromMap(maps.first);
    }
    return null;
  }
}
