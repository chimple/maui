import 'dart:async';
import 'package:maui/app_database.dart';
import 'package:maui/db/entity/drawing.dart';
import 'package:sqflite/sqflite.dart';

class DrawingDao {
  Future<Drawing> getDrawing(String id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Drawing.table,
        columns: Drawing.allCols,
        where: "${Drawing.idCol} = ? ",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Drawing.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Drawing>> getDrawingsByActivityId(String activityId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Drawing.table,
        columns: Drawing.allCols,
        where: "${Drawing.activityIdCol} = ? ",
        whereArgs: [activityId]);
    return maps.map((el) => new Drawing.fromMap(el)).toList();
  }

  Future<Drawing> getLatestDrawingByActivityId(String activityId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Drawing.table,
        columns: Drawing.allCols,
        where: "${Drawing.activityIdCol} = ? ",
        whereArgs: [activityId],
        orderBy: '${Drawing.updatedAtCol} DESC',
        limit: 1);
    if (maps.length > 0) {
      return Drawing.fromMap(maps.first);
    }
    return null;
  }

  Future<Drawing> insert(Drawing drawing, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(Drawing.table, drawing.toMap());
    return drawing;
  }

  Future<int> delete(int id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    return await db
        .delete(Drawing.table, where: "${Drawing.idCol} = ?", whereArgs: [id]);
  }

  Future<int> update(Drawing drawing, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    return await db.update(Drawing.table, drawing.toMap(),
        where: "${Drawing.idCol} = ?", whereArgs: [drawing.id]);
  }
}
