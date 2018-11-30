import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:convert';
import 'dart:io';
import 'package:maui/db/dao/tile_dao.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:meta/meta.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/db/dao/user_dao.dart';
import 'package:maui/repos/p2p.dart' as p2p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:maui/repos/dot_map.dart';

class UserRepo {
  static final UserDao userDao = new UserDao();

  const UserRepo();

  Future<User> getUser(String id) async {
    return await userDao.getUser(id);
  }

  Future<List<User>> getUsers() async {
    return await userDao.getUsers();
  }

  Future<List<User>> getRemoteUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('deviceId');
    return await userDao.getUsersOtherThanDeviceId(deviceId);
  }

  Future<User> insertOrUpdateRemoteUser(
      String userId, String deviceId, String txnText) async {
    final userInfo = txnText.split(floresSeparator);
    String imagePath;
    if (userInfo.length == 3) {
      String base64Image = userInfo.last;
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      List<int> memoryImage;
      try {
        memoryImage = base64.decode(base64Image);
      } catch (e) {
        print(e);
      }
      imagePath = join(documentsDirectory.path, '$userId.png');
      await new File(imagePath).writeAsBytes(memoryImage);
    }
    User user = await userDao.getUser(userId);
    if (user == null) {
      await userDao.insert(User(
          id: userId,
          deviceId: deviceId,
          image: imagePath,
          name: userInfo.length > 1 ? userInfo[0] : null,
          color:
              userInfo.length > 2 ? int.tryParse(userInfo[1], radix: 16) : null,
          currentLessonId: 1));
    }
  }

  Future<List<User>> getLocalUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('deviceId');
    return await userDao.getUsersByDeviceId(deviceId);
  }

  Future<User> insertLocalUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('deviceId');
    final loggedInUserId = prefs.getString('userId');
    user.deviceId = deviceId;
    var config = File(user.image);
    var contents = await config.readAsBytes();
    var enc = user.name +
        floresSeparator +
        user.color.toRadixString(16) +
        floresSeparator +
        base64.encode(contents);
    try {
      p2p.addUser(user.id, deviceId, enc);
    } on PlatformException {
      print('Flores: Failed addUser');
    } catch (e, s) {
      print('Exception details:\n $e');
      print('Stack trace:\n $s');
    }

    final tileRepo = TileRepo();
    dotMap.forEach((k, v) => tileRepo.upsert(Tile(
        id: k,
        cardId: 'dummy',
        content: v,
        type: TileType.dot,
        userId: user.id)));

    return await userDao.insert(user);
  }

  Future<int> delete(int id) async {
    return await userDao.delete(id);
  }

  Future<int> update(User user) async {
    return await userDao.update(user);
  }
}
