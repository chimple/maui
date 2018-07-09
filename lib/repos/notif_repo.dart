import 'dart:async';
import 'dart:core';

import 'package:maui/db/entity/notif.dart';
import 'package:maui/db/dao/notif_dao.dart';

class NotifRepo {
  static final NotifDao notifDao = new NotifDao();

  const NotifRepo();

  Future<Notif> getNotif(String userId, String type) async {
    return await notifDao.getNotif(userId, type);
  }

  Future<List<Notif>> getNotifs() async {
    return await notifDao.getNotifs();
  }

  Future<List<Notif>> getNotifsByType(String type) async {
    return await notifDao.getNotifsByType(type);
  }

  Future<Map<String, int>> getNotifCountByUser() async {
    return await notifDao.getNotifCountByUser();
  }

  Future<Map<String, int>> getNotifCountByType() async {
    return await notifDao.getNotifCountByType();
  }

  Future<int> increment(String userId, String type, int incr) async {
    Notif n = await notifDao.getNotif(userId, type);
    if (n == null && incr > 0) {
      n = await notifDao
          .insert(Notif(userId: userId, type: type, numNotifs: incr));
      return 1;
    } else if (n.numNotifs + incr > 0) {
      n.numNotifs = n.numNotifs + incr;
      return await notifDao.update(n);
    } else {
      return await notifDao.delete(userId, type);
    }
  }

  Future<int> delete(String userId, String type) async {
    return await notifDao.delete(userId, type);
  }
}
