import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/db/dao/user_dao.dart';
import 'package:flores/flores.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class UserRepo {
  static final UserDao userDao = new UserDao();

  const UserRepo();

  Future<User> getUser(String id) async {
    return await userDao.getUser(id);
  }

  Future<List<User>> getUsers() async {
    return await userDao.getUsers();
  }

  Future<User> insertOrUpdateRemoteUser(
      String userId, String deviceId, String base64Image) async {
    print('UserRepo.insertOrUpdateRemoteUser: $userId $deviceId');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    List<int> memoryImage;
    try {
      memoryImage = base64.decode(base64Image);
    } catch (e) {
      print(e);
    }
    String imagePath = join(documentsDirectory.path, '$userId.png');
    await new File(imagePath).writeAsBytes(memoryImage);

    User user = await userDao.getUser(userId);
    if (user == null) {
      await userDao.insert(User(
          id: userId,
          deviceId: deviceId,
          image: imagePath,
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
    user.deviceId = deviceId;
    var config = File(user.image);
    var contents = await config.readAsBytes();
    var enc = base64.encode(contents);
    Flores().addUser(user.id, deviceId, enc);
    print(user);
    return await userDao.insert(user);
  }

  Future<int> delete(int id) async {
    return await userDao.delete(id);
  }

  Future<int> update(User user) async {
    return await userDao.update(user);
  }
}
