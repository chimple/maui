import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/user.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  Future<User> getUser(String id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(User.table,
        columns: User.allCols, where: "${User.idCol} = ?", whereArgs: [id]);
    if (maps.length > 0) {
      return new User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> getUsersByDeviceId(String deviceId, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(User.table,
        columns: User.allCols,
        where: "${User.deviceIdCol} = ?",
        whereArgs: [deviceId]);
    return maps.map((userMap) => new User.fromMap(userMap)).toList();
  }

  Future<List<User>> getUsersOtherThanDeviceId(String deviceId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(User.table,
        columns: User.allCols,
        where: "${User.deviceIdCol} != ?",
        whereArgs: [deviceId]);
    return maps.map((userMap) => new User.fromMap(userMap)).toList();
  }

  Future<List<User>> getUsers({Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(User.table, columns: User.allCols);
    return maps.map((userMap) => new User.fromMap(userMap)).toList();
  }

  Future<User> insert(User user, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(User.table, user.toMap());
    return user;
  }

  Future<int> delete(int id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    return await db
        .delete(User.table, where: "${User.idCol} = ?", whereArgs: [id]);
  }

  Future<int> update(User user, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    return await db.update(User.table, user.toMap(),
        where: "${User.idCol} = ?", whereArgs: [user.id]);
  }
}
