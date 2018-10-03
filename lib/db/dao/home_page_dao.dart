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
        Home.typeCol,
        Home.typeIdCol,
        Home.userIdCol,
      ],
    );
    if (maps.length > 0) {
      return maps.map((el) => new Home.fromMap(el)).toList(growable: true);
    }
    return null;
  }

  Future<Null> insertAHomeTile(Home home, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(Home.table, home.toMap());
  }

  Future<Null> deleteAHomeTile(Home home, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.delete(Home.table,
        where: ''' ${Home.tileIdCol} = ? ''', whereArgs: [home.tileId]);
  }
}
