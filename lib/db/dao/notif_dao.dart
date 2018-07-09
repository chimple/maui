import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/notif.dart';
import 'package:sqflite/sqflite.dart';

class NotifDao {
  Future<Notif> getNotif(String userId, String type, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Notif.table,
        columns: [
          Notif.userIdCol,
          Notif.typeCol,
          Notif.numNotifsCol,
        ],
        where: "${Notif.userIdCol} = ? AND ${Notif.typeCol} = ?",
        whereArgs: [userId, type]);
    if (maps.length > 0) {
      return new Notif.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Notif>> getNotifs({Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      Notif.table,
      columns: [
        Notif.userIdCol,
        Notif.typeCol,
        Notif.numNotifsCol,
      ],
    );
    return maps.map((el) => new Notif.fromMap(el)).toList();
  }

  Future<List<Notif>> getNotifsByType(String type, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Notif.table,
        columns: [
          Notif.userIdCol,
          Notif.typeCol,
          Notif.numNotifsCol,
        ],
        where: "${Notif.typeCol} = ?",
        whereArgs: [type]);
    return maps.map((el) => new Notif.fromMap(el)).toList();
  }

  Future<Notif> insert(Notif notif, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(Notif.table, notif.toMap());
    return notif;
  }

  Future<Map<String, int>> getNotifCountByUser({Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Notif.table,
        columns: [Notif.userIdCol, 'count(${Notif.userIdCol})'],
        groupBy: '${Notif.userIdCol}');
    Map<String, int> returnMap = Map<String, int>();
    maps.forEach(
        (n) => returnMap[n[Notif.userIdCol]] = n['count(${Notif.userIdCol})']);
    return returnMap;
  }

  Future<Map<String, int>> getNotifCountByType({Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Notif.table,
        columns: [Notif.typeCol, 'count(${Notif.typeCol})'],
        groupBy: '${Notif.typeCol}');
    print('getNotifCountByType: $maps');
    Map<String, int> returnMap = Map<String, int>();
    maps.forEach(
        (n) => returnMap[n[Notif.typeCol]] = n['count(${Notif.typeCol})']);
    print('getNotifCountByType: $returnMap');
    return returnMap;
  }

  Future<int> update(Notif notif, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    return await db.update(Notif.table, notif.toMap(),
        where: "${Notif.userIdCol} = ? AND ${Notif.typeCol} = ?",
        whereArgs: [notif.userId, notif.type]);
  }

  Future<int> delete(String userId, String type, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    return await db.delete(Notif.table,
        where: "${Notif.userIdCol} = ? AND ${Notif.typeCol} = ?",
        whereArgs: [userId, type]);
  }
}
