import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:maui/db/entity/home.dart';

import 'package:maui/app_database.dart';

class HomeDao {
  Future<List<Home>> getHomeTiles({Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      Home.table,
      columns: [
        Home.tileIdCol,
        Home.disLikesCol,
        Home.articleIdCol,
        Home.likesCol,
        Home.topicIdCol,
        Home.quizIdCol,
        Home.userIdCol,
        Home.activityIdCol
      ],
    );
    if (maps.length > 0) {
      return maps.map((el) => new Home.fromMap(el)).toList(growable: false);
    }
    return null;
  }
}
