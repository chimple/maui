import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    List<dynamic> friends;
    try {
      friends = await Flores().users;
    } on PlatformException {
      print('Failed getting friends');
    }

    List<User> users = await userDao.getUsers();
    friends.forEach((f) async {
      if (users.any((u) => u.id == f['userId'])) {
      } else {
        List<int> memoryImage;
        try {
          memoryImage = base64.decode(f['message']);
        } catch (e) {
          print(e);
        }
        String userId = f['userId'];
        String imagePath = join(documentsDirectory.path, '$userId.png');
        await new File(imagePath).writeAsBytes(memoryImage);
        User user = User(
            id: f['userId'],
            deviceId: f['deviceId'],
            image: imagePath,
            currentLessonId: 1);
        await new UserRepo().insertLocalUser(user);
        users.add(user);
      }
    });
    return users;
  }

  Future<List<User>> getLocalUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('deviceId');
    return await userDao.getUsersByDeviceId(deviceId);
  }

  Future<User> insertLocalUser(User user) async {
//    StorageReference ref = FirebaseStorage.instance
//        .ref()
//        .child("user_${user.id}.jpg");
//    StorageUploadTask uploadTask = ref.put(new File(user.image));
//    Uri downloadUrl = (await uploadTask.future).downloadUrl;
//
//    final reference = FirebaseDatabase.instance.reference().child('users');
//    reference.push().set({
//      'id': user.id,
//      'name': user.name,
//      'image': downloadUrl.toString()
//    });
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
